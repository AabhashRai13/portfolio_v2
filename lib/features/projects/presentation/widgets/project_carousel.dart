import 'dart:async';
import 'dart:math' as math;
import 'dart:ui' show lerpDouble;

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:my_portfolio/constants/breakpoints.dart';
import 'package:my_portfolio/core/presentation/widgets/press_scale.dart';
import 'package:my_portfolio/core/presentation/widgets/tappable.dart';
import 'package:my_portfolio/core/resources/styles/home_palette.dart';
import 'package:my_portfolio/core/resources/styles/site_text.dart';
import 'package:my_portfolio/core/services/tap_feedback.dart';
import 'package:my_portfolio/features/projects/domain/models/project_summary.dart';
import 'package:my_portfolio/features/projects/presentation/widgets/project_poster.dart';

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

/// One poster in the middle, lifted, with smaller, quieter neighbours either
/// side, on a frosted glass stage over a soft peach and lavender glow. The
/// middle project's name and one line about it sit under the stage. Loops
/// endlessly and rotates on its own until someone hovers, drags or opens a
/// project. Every transform reads the live page value, so motion follows a
/// drag.
class ProjectCarousel extends StatefulWidget {
  const ProjectCarousel({
    required this.projects,
    required this.onOpen,
    this.maxCardHeight = double.infinity,
    super.key,
  });

  static const Key previousKey = ValueKey<String>('project-carousel-previous');
  static const Key nextKey = ValueKey<String>('project-carousel-next');
  static const Duration autoplayInterval = Duration(seconds: 5);

  final List<FeaturedProject> projects;

  /// Called when the middle card is tapped, with the card's global rect so
  /// the project view can grow out of it. The carousel stays paused until
  /// the returned future completes (the project view closes).
  final Future<void> Function(FeaturedProject project, Rect origin) onOpen;

  /// Tallest the middle card may be. On a short window the whole stage
  /// narrows to keep this, so the cards keep their shape and spacing.
  final double maxCardHeight;

  @override
  State<ProjectCarousel> createState() => _ProjectCarouselState();
}

class _ProjectCarouselState extends State<ProjectCarousel> {
  /// The arrows look 40 px wide but take taps across 48 px.
  static const double _arrowSize = 40;
  static const double _arrowTarget = 48;

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
    final layout = MediaQuery.sizeOf(context).width < Breakpoints.tablet
        ? _phone
        : _desktop;
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
    // Unattached while this page sits unbuilt under another route (a direct
    // visit to /work/all); the auto-rotate timer still fires there.
    final controller = _controller;
    if (controller == null || !controller.hasClients) return;
    unawaited(
      controller.animateToPage(
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

  Future<void> _openCurrent(BuildContext card, FeaturedProject project) async {
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
              animation: _controller!,
              builder: (context, _) => Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  LayoutBuilder(
                    builder: (context, constraints) =>
                        _stage(context, constraints.maxWidth),
                  ),
                  SizedBox(height: _layout == _phone ? 20 : 24),
                  _caption(context),
                  const SizedBox(height: 12),
                  _pills(context),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  /// The glass panel, the glow behind it, the sliding posters and, on
  /// desktop, the arrows on the glass's outer edges.
  Widget _stage(BuildContext context, double width) {
    final isNarrow = _layout == _phone;
    // Desktop arrows sit centred on the glass's left and right edges; leave
    // half a tap target either side so their outer halves stay tappable.
    final arrowRoom = isNarrow ? 0.0 : _arrowTarget / 2;
    // Room inside the glass so card shadows fade out before its edge.
    final pad = isNarrow
        ? const EdgeInsets.symmetric(horizontal: 10, vertical: 32)
        : const EdgeInsets.symmetric(horizontal: 20, vertical: 32);
    final pageWidth = math.min(
      (width - arrowRoom * 2 - pad.horizontal) * _layout.fraction,
      widget.maxCardHeight * kPosterAspect / _layout.centerScale,
    );
    final stageWidth =
        pageWidth / _layout.fraction + pad.horizontal + arrowRoom * 2;

    return Center(
      child: SizedBox(
        width: stageWidth,
        child: _stageLayers(isNarrow, arrowRoom, pad, pageWidth),
      ),
    );
  }

  Widget _stageLayers(
    bool isNarrow,
    double arrowRoom,
    EdgeInsets pad,
    double pageWidth,
  ) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        const Positioned.fill(
          left: -160,
          right: -160,
          top: -120,
          bottom: -120,
          child: _StageGlow(),
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: arrowRoom),
          child: _GlassStage(
            padding: pad,
            child: SizedBox(
              height: pageWidth * _layout.centerScale / kPosterAspect,
              child: Stack(
                children: [
                  Positioned.fill(
                    child: PageView.builder(
                      // A fresh scroll position per layout. Reusing the old
                      // one makes the new controller change its viewport
                      // fraction mid-build, which notifies the
                      // AnimatedBuilder above during build.
                      key: ValueKey(_layout),
                      controller: _controller,
                      // The glass clips instead, past the card shadows.
                      clipBehavior: Clip.none,
                      itemCount: _count > 1 ? null : 1,
                      itemBuilder: (context, index) =>
                          _buildSlide(context, index, pageWidth),
                    ),
                  ),
                  // Above the PageView so it claims wheel events first; the
                  // PageView ignores its children while it animates.
                  Positioned.fill(
                    child: Listener(
                      behavior: HitTestBehavior.translucent,
                      onPointerSignal: _onPointerSignal,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        // Phones swipe; arrows there would sit on the poster.
        if (!isNarrow) ...[
          Positioned(
            left: 0,
            top: 0,
            bottom: 0,
            child: Center(
              child: _Arrow(
                key: ProjectCarousel.previousKey,
                size: _arrowSize,
                icon: Icons.chevron_left_rounded,
                tooltip: 'Previous project',
                onPressed: () => _go(_index - 1),
              ),
            ),
          ),
          Positioned(
            right: 0,
            top: 0,
            bottom: 0,
            child: Center(
              child: _Arrow(
                key: ProjectCarousel.nextKey,
                size: _arrowSize,
                icon: Icons.chevron_right_rounded,
                tooltip: 'Next project',
                onPressed: () => _go(_index + 1),
              ),
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildSlide(BuildContext context, int index, double pageWidth) {
    final palette = Theme.of(context).homePalette;
    final project = widget.projects[index % _count];
    final distance = (index - _page).abs().clamp(0.0, 1.0);
    final isCurrent = index == _index;
    final scale = lerpDouble(
      _layout.centerScale,
      _layout.sideScale,
      distance,
    )!;

    return Center(
      child: SizedBox(
        width: pageWidth,
        height: pageWidth / kPosterAspect,
        child: Transform.scale(
          scale: scale,
          child: Builder(
            builder: (card) => Tappable(
              label: isCurrent
                  ? 'Open ${project.title}'
                  : 'Show ${project.title}',
              onTap: () => isCurrent
                  ? unawaited(_openCurrent(card, project))
                  : _go(index),
              // Neighbours step back, a little faded and less saturated,
              // so the middle card holds the eye.
              child: Opacity(
                opacity: 1 - 0.15 * distance,
                child: ColorFiltered(
                  colorFilter: ColorFilter.matrix(
                    _saturation(1 - 0.4 * distance),
                  ),
                  child: ProjectPoster(
                    project: project,
                    // The same corner on screen at every scale.
                    radius: kPosterRadius / scale,
                    shadow: BoxShadow.lerp(
                      BoxShadow(
                        color: palette.shadowColor.withValues(alpha: 0.3),
                        blurRadius: 48,
                        offset: const Offset(0, 24),
                      ),
                      BoxShadow(
                        color: palette.shadowColor.withValues(alpha: 0.1),
                        blurRadius: 16,
                        offset: const Offset(0, 8),
                      ),
                      distance,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  /// The middle project's name and what it is. Fades out as its card leaves
  /// the middle and back in as the next arrives, so it follows a drag.
  Widget _caption(BuildContext context) {
    final palette = Theme.of(context).homePalette;
    final isNarrow = _layout == _phone;
    final page = _page;
    final project = widget.projects[_selected];
    return Opacity(
      opacity: (1 - (page - page.round()).abs() * 2).clamp(0.0, 1.0),
      child: Column(
        children: [
          Text(
            project.title,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.center,
            style: SiteText.body(
              palette.textStrong,
              size: isNarrow ? 18 : 20,
            ).copyWith(fontWeight: FontWeight.w600, height: 1.3),
          ),
          const SizedBox(height: 2),
          Text(
            project.about,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.center,
            style: SiteText.body(palette.textSecondary, size: 15),
          ),
        ],
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

/// Colour matrix that keeps [s] of the saturation: 1 leaves colours alone,
/// 0 is greyscale (Rec. 709 luma weights).
List<double> _saturation(double s) {
  const r = 0.2126;
  const g = 0.7152;
  const b = 0.0722;
  final k = 1 - s;
  return [
    r * k + s, g * k, b * k, 0, 0, //
    r * k, g * k + s, b * k, 0, 0, //
    r * k, g * k, b * k + s, 0, 0, //
    0, 0, 0, 1, 0, //
  ];
}

/// Light gathered behind the stage: soft peach low on the left and dusty
/// lavender high on the right, both fading out well before the page edge so
/// the rest of the page stays plain warm cream. Radial gradients rather than
/// a blur, so it paints once and costs nothing while the carousel moves.
class _StageGlow extends StatelessWidget {
  const _StageGlow();

  @override
  Widget build(BuildContext context) {
    final [peach, lavender] = Theme.of(context).homePalette.stageGlow;
    return IgnorePointer(
      child: RepaintBoundary(
        child: Stack(
          fit: StackFit.expand,
          children: [
            _wash(peach, const Alignment(-0.7, 0.45)),
            _wash(lavender, const Alignment(0.7, -0.45)),
          ],
        ),
      ),
    );
  }

  /// A wide, soft oval of [color] centred at [at]. The gradient reaches
  /// transparent at the box's short edges, so nothing ends in a hard line.
  static Widget _wash(Color color, Alignment at) => Align(
    alignment: at,
    child: FractionallySizedBox(
      widthFactor: 0.42,
      heightFactor: 0.9,
      child: Transform.scale(
        scaleX: 1.5,
        child: DecoratedBox(
          decoration: BoxDecoration(
            gradient: RadialGradient(
              colors: [color, color.withValues(alpha: 0)],
            ),
          ),
        ),
      ),
    ),
  );
}

/// Frosted panel from the first version of the site: a faint white sheen,
/// a hairline border and rounded corners that clip what slides past them.
class _GlassStage extends StatelessWidget {
  const _GlassStage({required this.padding, required this.child});

  final EdgeInsets padding;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final palette = Theme.of(context).homePalette;
    final radius = BorderRadius.circular(36);
    return DecoratedBox(
      decoration: BoxDecoration(
        borderRadius: radius,
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            palette.glassHighlightStrong,
            palette.glassFill,
            palette.glassHighlightSoft,
          ],
        ),
        border: Border.all(color: palette.glassBorder, width: 1.2),
      ),
      child: ClipRRect(
        borderRadius: radius,
        child: Padding(padding: padding, child: child),
      ),
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
        icon: Icon(icon, size: 24),
        style: IconButton.styleFrom(
          fixedSize: Size.square(size),
          // Drawn at [size] but tappable across 48 px.
          tapTargetSize: MaterialTapTargetSize.padded,
          foregroundColor: palette.textStrong,
          backgroundColor: palette.surfaceCard,
          elevation: 3,
          shadowColor: palette.shadowColor.withValues(alpha: 0.35),
        ),
      ),
    );
  }
}
