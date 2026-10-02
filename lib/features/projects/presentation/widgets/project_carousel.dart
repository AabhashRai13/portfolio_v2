import 'dart:async';
import 'dart:ui' show ImageFilter;

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:my_portfolio/core/presentation/widgets/press_scale.dart';
import 'package:my_portfolio/core/resources/styles/home_palette.dart';
import 'package:my_portfolio/core/services/tap_feedback.dart';
import 'package:my_portfolio/features/projects/domain/models/project_summary.dart';

/// Posters only, one project in the middle with smaller neighbours either
/// side. Rotates on its own until someone hovers, drags or opens a project.
/// Every transform reads the live page value, so motion follows a drag.
class ProjectCarousel extends StatefulWidget {
  const ProjectCarousel({
    required this.projects,
    required this.onOpen,
    super.key,
  });

  static const Key previousKey = ValueKey<String>('project-carousel-previous');
  static const Key nextKey = ValueKey<String>('project-carousel-next');
  static const Duration autoplayInterval = Duration(seconds: 5);

  final List<ProjectSummary> projects;

  /// Called when the middle card is tapped, with the card's global rect so
  /// the project view can grow out of it. The carousel stays paused until
  /// the returned future completes (the project view closes).
  final Future<void> Function(ProjectSummary project, Rect origin) onOpen;

  @override
  State<ProjectCarousel> createState() => _ProjectCarouselState();
}

class _ProjectCarouselState extends State<ProjectCarousel> {
  static const _sideScale = 0.82;

  final FocusNode _focus = FocusNode(skipTraversal: true);
  PageController? _controller;
  double? _fraction;

  Timer? _autoplay;
  bool _hovering = false;
  bool _pressed = false;
  bool _open = false;

  double _wheelDx = 0;
  bool _wheelLocked = false;
  Timer? _wheelIdle;

  int get _count => widget.projects.length;

  double get _page {
    final controller = _controller;
    return controller != null &&
            controller.hasClients &&
            controller.position.hasContentDimensions
        ? controller.page ?? 0
        : 0;
  }

  int get _index => _page.round();

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // viewportFraction is fixed per controller, so swap it at the breakpoint
    // and keep the current page.
    final fraction = MediaQuery.sizeOf(context).width < 720 ? 0.82 : 0.6;
    if (fraction != _fraction) {
      final old = _controller;
      _controller = PageController(
        viewportFraction: fraction,
        initialPage: old == null ? 0 : _index,
      );
      _fraction = fraction;
      if (old != null) {
        WidgetsBinding.instance.addPostFrameCallback((_) => old.dispose());
      }
    }
    _restartAutoplay();
  }

  void _restartAutoplay() {
    _autoplay?.cancel();
    if (MediaQuery.disableAnimationsOf(context) || _count < 2) return;
    _autoplay = Timer.periodic(ProjectCarousel.autoplayInterval, (_) {
      if (_hovering || _pressed || _open) return;
      _animateTo((_index + 1) % _count);
    });
  }

  void _animateTo(int index) {
    unawaited(
      _controller?.animateToPage(
        index,
        duration: const Duration(milliseconds: 600),
        curve: Curves.easeInOutCubic,
      ),
    );
  }

  /// User navigation wraps around, like the auto-rotation, and resets the
  /// auto-rotate clock so it never jumps right after a tap.
  void _go(int index) {
    _animateTo(index % _count);
    _restartAutoplay();
  }

  Future<void> _openCurrent(BuildContext card, ProjectSummary project) async {
    final box = card.findRenderObject()! as RenderBox;
    setState(() => _open = true);
    await widget.onOpen(project, box.localToGlobal(Offset.zero) & box.size);
    if (!mounted) return;
    setState(() => _open = false);
    _restartAutoplay();
  }

  /// PageView snaps back after every small wheel delta, so a trackpad swipe
  /// never turns the page. Claim horizontal wheel events here instead and
  /// step one page per burst (a swipe plus its momentum tail).
  // ponytail: 40 px / 200 ms idle heuristic; tune if trackpads feel sticky.
  void _onPointerSignal(PointerSignalEvent event) {
    if (event is! PointerScrollEvent) return;
    final dx = event.scrollDelta.dx;
    if (dx.abs() <= event.scrollDelta.dy.abs()) return;
    GestureBinding.instance.pointerSignalResolver.register(event, (_) {
      _wheelIdle?.cancel();
      _wheelIdle = Timer(const Duration(milliseconds: 200), () {
        _wheelDx = 0;
        _wheelLocked = false;
      });
      if (_wheelLocked) return;
      _wheelDx += dx;
      if (_wheelDx.abs() < 40) return;
      _wheelLocked = true;
      _go(_index + _wheelDx.sign.toInt());
    });
  }

  @override
  void dispose() {
    _autoplay?.cancel();
    _wheelIdle?.cancel();
    _controller?.dispose();
    _focus.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isNarrow = MediaQuery.sizeOf(context).width < 720;
    final controller = _controller!;

    return CallbackShortcuts(
      bindings: {
        const SingleActivator(LogicalKeyboardKey.arrowLeft): () =>
            _go(_index - 1),
        const SingleActivator(LogicalKeyboardKey.arrowRight): () =>
            _go(_index + 1),
      },
      child: Focus(
        focusNode: _focus,
        // Otherwise this node merges every label inside into one.
        includeSemantics: false,
        child: Listener(
          // Any click or drag inside makes the arrow keys work and holds the
          // auto-rotation while a finger or mouse button is down.
          onPointerDown: (_) {
            _focus.requestFocus();
            _pressed = true;
          },
          onPointerUp: (_) => _pressed = false,
          onPointerCancel: (_) => _pressed = false,
          child: MouseRegion(
            onEnter: (_) => _hovering = true,
            onExit: (_) => _hovering = false,
            child: AnimatedBuilder(
              animation: controller,
              builder: (context, _) => Column(
                children: [
                  LayoutBuilder(
                    builder: (context, constraints) => SizedBox(
                      height:
                          constraints.maxWidth *
                          _fraction! /
                          (isNarrow ? 1.6 : 1.9),
                      child: Stack(
                        children: [
                          PageView.builder(
                            controller: controller,
                            itemCount: _count,
                            itemBuilder: _buildSlide,
                          ),
                          // Above the PageView so it claims wheel events
                          // first; the PageView ignores its children while
                          // it animates.
                          Positioned.fill(
                            child: Listener(
                              behavior: HitTestBehavior.translucent,
                              onPointerSignal: _onPointerSignal,
                            ),
                          ),
                          Align(
                            alignment: Alignment.centerLeft,
                            child: _Arrow(
                              key: ProjectCarousel.previousKey,
                              icon: Icons.chevron_left_rounded,
                              tooltip: 'Previous project',
                              onPressed: () => _go(_index - 1),
                            ),
                          ),
                          Align(
                            alignment: Alignment.centerRight,
                            child: _Arrow(
                              key: ProjectCarousel.nextKey,
                              icon: Icons.chevron_right_rounded,
                              tooltip: 'Next project',
                              onPressed: () => _go(_index + 1),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  _pills(context),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSlide(BuildContext context, int index) {
    final project = widget.projects[index];
    final distance = (index - _page).abs().clamp(0.0, 1.0);
    final isCurrent = index == _index;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Transform.scale(
        scale: 1 - distance * (1 - _sideScale),
        child: Opacity(
          opacity: 1 - distance * 0.25,
          child: Semantics(
            button: true,
            label: isCurrent
                ? 'Open ${project.title}'
                : 'Show ${project.title}',
            excludeSemantics: true,
            child: Builder(
              builder: (card) => GestureDetector(
                onTap: () {
                  tapFeedback();
                  isCurrent
                      ? unawaited(_openCurrent(card, project))
                      : _go(index);
                },
                child: MouseRegion(
                  cursor: SystemMouseCursors.click,
                  child: PressScale(
                    pressedScale: 0.97,
                    child: ProjectPoster(project: project),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _pills(BuildContext context) {
    final palette = Theme.of(context).homePalette;
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        for (var i = 0; i < _count; i++)
          Semantics(
            button: true,
            selected: i == _index,
            label: 'Show ${widget.projects[i].title}',
            excludeSemantics: true,
            child: GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: () {
                tapFeedback();
                _go(i);
              },
              child: MouseRegion(
                cursor: SystemMouseCursors.click,
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 4,
                    vertical: 12,
                  ),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeOutCubic,
                    width: i == _index ? 32 : 14,
                    height: 4,
                    decoration: BoxDecoration(
                      color: i == _index
                          ? palette.textStrong
                          : palette.textSecondary.withValues(alpha: 0.35),
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
              ),
            ),
          ),
      ],
    );
  }
}

class _Arrow extends StatelessWidget {
  const _Arrow({
    required this.icon,
    required this.tooltip,
    required this.onPressed,
    super.key,
  });

  final IconData icon;
  final String tooltip;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final palette = Theme.of(context).homePalette;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: PressScale(
        child: IconButton(
          tooltip: tooltip,
          onPressed: () {
            tapFeedback();
            onPressed();
          },
          icon: Icon(icon, size: 28),
          style: IconButton.styleFrom(
            fixedSize: const Size.square(48),
            foregroundColor: palette.textStrong,
            backgroundColor: palette.surfaceCard.withValues(alpha: 0.75),
            elevation: 2,
            shadowColor: palette.shadowColor.withValues(alpha: 0.3),
          ),
        ),
      ),
    );
  }
}

/// The store poster shown whole, over a blurred copy of itself, so posters
/// of any shape fill the card without cropping their screens.
class ProjectPoster extends StatelessWidget {
  const ProjectPoster({required this.project, super.key});

  final ProjectSummary project;

  @override
  Widget build(BuildContext context) {
    final palette = Theme.of(context).homePalette;
    final image = project.banner ?? project.icon;

    return DecoratedBox(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: palette.shadowColor.withValues(alpha: 0.25),
            blurRadius: 24,
            offset: const Offset(0, 12),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: ColoredBox(
          color: palette.surfaceMuted,
          child: image == null
              ? const SizedBox.expand()
              : Stack(
                  fit: StackFit.expand,
                  children: [
                    ImageFiltered(
                      imageFilter: ImageFilter.blur(sigmaX: 28, sigmaY: 28),
                      child: Image.asset(image, fit: BoxFit.cover),
                    ),
                    ColoredBox(color: Colors.black.withValues(alpha: 0.12)),
                    Image.asset(image, fit: BoxFit.contain),
                  ],
                ),
        ),
      ),
    );
  }
}
