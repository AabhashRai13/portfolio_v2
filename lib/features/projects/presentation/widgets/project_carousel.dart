import 'dart:async';
import 'dart:ui' show lerpDouble;

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:my_portfolio/core/presentation/widgets/press_scale.dart';
import 'package:my_portfolio/core/resources/styles/home_palette.dart';
import 'package:my_portfolio/core/services/tap_feedback.dart';
import 'package:my_portfolio/features/projects/domain/models/project_summary.dart';

/// Width / height of every poster card. Posters are drawn for this shape.
const double kPosterAspect = 0.78;

/// Page width as a share of the carousel, and card scale in the middle and
/// at the sides. On desktop these fit all three cards edge to edge with a
/// small gap; on phones the neighbours only peek.
typedef _Layout = ({double fraction, double centerScale, double sideScale});

const _Layout _desktop = (
  fraction: 0.356,
  centerScale: 1.075,
  sideScale: 0.806,
);
const _Layout _phone = (fraction: 0.74, centerScale: 1, sideScale: 0.85);

/// Posters only, one project in the middle with smaller neighbours either
/// side, under a "title · 01 / 03" header. Loops endlessly and rotates on
/// its own until someone hovers, drags or opens a project. Every transform
/// reads the live page value, so motion follows a drag.
class ProjectCarousel extends StatefulWidget {
  const ProjectCarousel({
    required this.title,
    required this.projects,
    required this.onOpen,
    super.key,
  });

  static const Key previousKey = ValueKey<String>('project-carousel-previous');
  static const Key nextKey = ValueKey<String>('project-carousel-next');
  static const Duration autoplayInterval = Duration(seconds: 5);

  final String title;
  final List<ProjectSummary> projects;

  /// Called when the middle card is tapped, with the card's global rect so
  /// the project view can grow out of it. The carousel stays paused until
  /// the returned future completes (the project view closes).
  final Future<void> Function(ProjectSummary project, Rect origin) onOpen;

  @override
  State<ProjectCarousel> createState() => _ProjectCarouselState();
}

class _ProjectCarouselState extends State<ProjectCarousel> {
  static const double _arrowSize = 56;

  final FocusNode _focus = FocusNode(skipTraversal: true);
  PageController? _controller;
  _Layout _layout = _desktop;

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
        : controller?.initialPage.toDouble() ?? 0;
  }

  /// Raw page: the PageView is endless, so pages repeat the projects.
  int get _index => _page.round();

  int get _selected => _index % _count;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // viewportFraction is fixed per controller, so swap it at the breakpoint
    // and keep the current page.
    final layout = MediaQuery.sizeOf(context).width < 720 ? _phone : _desktop;
    if (_controller == null || layout != _layout) {
      final old = _controller;
      _controller = PageController(
        viewportFraction: layout.fraction,
        // Start deep in the endless list so there is room to go back.
        initialPage: old == null ? _count * 1000 : _index,
      );
      _layout = layout;
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
      _animateTo(_index + 1);
    });
  }

  void _animateTo(int page) {
    unawaited(
      _controller?.animateToPage(
        page,
        duration: const Duration(milliseconds: 600),
        curve: Curves.easeInOutCubic,
      ),
    );
  }

  /// Moves to a raw page and resets the auto-rotate clock so it never jumps
  /// right after a tap.
  void _go(int page) {
    _animateTo(page);
    _restartAutoplay();
  }

  /// The nearest page showing project [i], going whichever way is shorter.
  void _goToProject(int i) {
    var delta = i - _selected;
    if (delta > _count / 2) delta -= _count;
    if (delta < -_count / 2) delta += _count;
    _go(_index + delta);
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
    final isNarrow = _layout == _phone;
    final controller = _controller!;
    // Desktop arrows sit centred on the side cards' outer edges; inset the
    // cards by half an arrow so the arrows stay inside and tappable.
    final inset = isNarrow ? 0.0 : _arrowSize / 2;

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
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _header(context, isNarrow: isNarrow),
                  SizedBox(height: isNarrow ? 20 : 28),
                  LayoutBuilder(
                    builder: (context, constraints) {
                      final pageWidth =
                          (constraints.maxWidth - inset * 2) * _layout.fraction;
                      return SizedBox(
                        height: pageWidth * _layout.centerScale / kPosterAspect,
                        child: Stack(
                          children: [
                            Positioned.fill(
                              left: inset,
                              right: inset,
                              child: PageView.builder(
                                controller: controller,
                                itemCount: _count > 1 ? null : 1,
                                itemBuilder: (context, index) =>
                                    _buildSlide(index, pageWidth),
                              ),
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
                            // Phones swipe; arrows there would sit on the
                            // poster.
                            if (!isNarrow) ...[
                              Align(
                                alignment: Alignment.centerLeft,
                                child: _Arrow(
                                  key: ProjectCarousel.previousKey,
                                  size: _arrowSize,
                                  icon: Icons.chevron_left_rounded,
                                  tooltip: 'Previous project',
                                  onPressed: () => _go(_index - 1),
                                ),
                              ),
                              Align(
                                alignment: Alignment.centerRight,
                                child: _Arrow(
                                  key: ProjectCarousel.nextKey,
                                  size: _arrowSize,
                                  icon: Icons.chevron_right_rounded,
                                  tooltip: 'Next project',
                                  onPressed: () => _go(_index + 1),
                                ),
                              ),
                            ],
                          ],
                        ),
                      );
                    },
                  ),
                  SizedBox(height: isNarrow ? 16 : 24),
                  _pills(context),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  /// "Work ······ 01 / 03" over a hairline.
  Widget _header(BuildContext context, {required bool isNarrow}) {
    final palette = Theme.of(context).homePalette;
    final size = isNarrow ? 26.0 : 36.0;
    String pad(int n) => n.toString().padLeft(2, '0');

    return Container(
      padding: const EdgeInsets.only(bottom: 14),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: palette.textSecondary.withValues(alpha: 0.35),
          ),
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.baseline,
        textBaseline: TextBaseline.alphabetic,
        children: [
          Semantics(
            header: true,
            child: Text(
              widget.title,
              style: TextStyle(fontSize: size, color: palette.textStrong),
            ),
          ),
          const Spacer(),
          Text.rich(
            TextSpan(
              children: [
                TextSpan(
                  text: pad(_selected + 1),
                  style: TextStyle(color: palette.textStrong),
                ),
                TextSpan(
                  text: ' / ${pad(_count)}',
                  style: TextStyle(
                    color: palette.textSecondary.withValues(alpha: 0.6),
                  ),
                ),
              ],
            ),
            style: TextStyle(fontSize: size * 0.8),
          ),
        ],
      ),
    );
  }

  Widget _buildSlide(int index, double pageWidth) {
    final project = widget.projects[index % _count];
    final distance = (index - _page).abs().clamp(0.0, 1.0);
    final isCurrent = index == _index;

    return Center(
      child: SizedBox(
        width: pageWidth,
        height: pageWidth / kPosterAspect,
        child: Transform.scale(
          scale: lerpDouble(
            _layout.centerScale,
            _layout.sideScale,
            distance,
          ),
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
            selected: i == _selected,
            label: 'Show ${widget.projects[i].title}',
            excludeSemantics: true,
            child: GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: () {
                tapFeedback();
                _goToProject(i);
              },
              child: MouseRegion(
                cursor: SystemMouseCursors.click,
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 5,
                    vertical: 12,
                  ),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeOutCubic,
                    width: i == _selected ? 44 : 26,
                    height: 6,
                    decoration: BoxDecoration(
                      color: i == _selected
                          ? palette.textStrong
                          : palette.textSecondary.withValues(alpha: 0.3),
                      borderRadius: BorderRadius.circular(3),
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
    required this.size,
    required this.icon,
    required this.tooltip,
    required this.onPressed,
    super.key,
  });

  final double size;
  final IconData icon;
  final String tooltip;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final palette = Theme.of(context).homePalette;
    return PressScale(
      child: IconButton(
        tooltip: tooltip,
        onPressed: () {
          tapFeedback();
          onPressed();
        },
        icon: Icon(icon, size: 30),
        style: IconButton.styleFrom(
          fixedSize: Size.square(size),
          foregroundColor: palette.textStrong,
          backgroundColor: palette.surfaceCard,
          elevation: 3,
          shadowColor: palette.shadowColor.withValues(alpha: 0.35),
        ),
      ),
    );
  }
}

/// A project's poster filling a rounded card. Posters are drawn at
/// [kPosterAspect]; other shapes are cropped to the centre.
class ProjectPoster extends StatelessWidget {
  const ProjectPoster({required this.project, super.key});

  final ProjectSummary project;

  @override
  Widget build(BuildContext context) {
    final palette = Theme.of(context).homePalette;
    final image = project.banner ?? project.icon;

    return DecoratedBox(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(28),
        boxShadow: [
          BoxShadow(
            color: palette.shadowColor.withValues(alpha: 0.22),
            blurRadius: 28,
            offset: const Offset(0, 14),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(28),
        child: ColoredBox(
          color: palette.surfaceMuted,
          child: image == null
              ? const SizedBox.expand()
              : Image.asset(image, fit: BoxFit.cover),
        ),
      ),
    );
  }
}
