import 'package:flutter/material.dart';
import 'package:my_portfolio/features/about/presentation/widgets/viewport_span.dart';

typedef RevealBuilder =
    Widget Function(BuildContext context, Animation<double> reveal);

/// Plays [builder]'s entrance once, when its top scrolls up past
/// [triggerLine]. What is on screen at load is shown still, and so is
/// everything when the platform asks for less motion.
///
/// `reveal` runs 0 to 1 linearly; builders pick their own curves and should
/// animate only transforms and opacity, so frames repaint without layout.
class ScrollReveal extends StatefulWidget {
  const ScrollReveal({
    required this.builder,
    this.duration = const Duration(milliseconds: 600),
    super.key,
  });

  /// Fraction of the screen's height, from the top, the widget's top edge
  /// must pass, so the entrance plays where it can be seen.
  static const double triggerLine = 0.85;

  final RevealBuilder builder;
  final Duration duration;

  @override
  State<ScrollReveal> createState() => _ScrollRevealState();
}

class _ScrollRevealState extends State<ScrollReveal>
    with SingleTickerProviderStateMixin {
  late final AnimationController _reveal = AnimationController(
    vsync: this,
    duration: widget.duration,
  );
  ScrollPosition? _position;
  bool _checkedAtLoad = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // A resized window re-checks what is now on screen.
    MediaQuery.sizeOf(context);
    final position = Scrollable.maybeOf(context)?.position;
    if (MediaQuery.disableAnimationsOf(context) || position == null) {
      _show();
      return;
    }
    if (!_reveal.isDismissed) return;
    _listenTo(position);
    WidgetsBinding.instance.addPostFrameCallback((_) => _check());
  }

  void _listenTo(ScrollPosition? position) {
    if (position == _position) return;
    _position?.removeListener(_onScroll);
    _position = position?..addListener(_onScroll);
  }

  void _onScroll() => afterLayout(_check);

  void _check() {
    final position = _position;
    if (!mounted || position == null || !_reveal.isDismissed) return;
    final span = viewportSpan(context);
    if (span == null) return;

    final atLoad = !_checkedAtLoad;
    _checkedAtLoad = true;
    final onScreen = span.top < 1 && span.bottom > 0;
    if (span.bottom <= 0 || (atLoad && onScreen)) {
      // Already passed, or there from the start: nothing to play.
      _show();
    } else if (span.top < ScrollReveal.triggerLine ||
        (onScreen && atScrollEnd(position))) {
      _listenTo(null);
      _reveal.forward();
    }
  }

  void _show() {
    _listenTo(null);
    _reveal.value = 1;
  }

  @override
  void dispose() {
    _listenTo(null);
    _reveal.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => widget.builder(context, _reveal);
}

/// Fades [child] in while it rises [rise] px into place.
class FadeUp extends StatelessWidget {
  const FadeUp({
    required this.reveal,
    required this.child,
    this.rise = 24,
    super.key,
  });

  final Animation<double> reveal;
  final Widget child;
  final double rise;

  @override
  Widget build(BuildContext context) {
    final eased = reveal.drive(CurveTween(curve: Curves.easeOutCubic));
    return MatrixTransition(
      animation: eased,
      onTransform: (t) => Matrix4.translationValues(0, (1 - t) * rise, 0),
      child: ClippedFade(opacity: eased, child: child),
    );
  }
}

/// A [FadeTransition] clipped just past [child]'s edges. On the web a fade
/// is an offscreen layer as big as the clip around it, and a dozen
/// screen-sized ones at once stutter the scroll.
class ClippedFade extends StatelessWidget {
  const ClippedFade({required this.opacity, required this.child, super.key});

  final Animation<double> opacity;
  final Widget child;

  @override
  Widget build(BuildContext context) => ClipRect(
    clipper: const _Bleed(),
    child: FadeTransition(
      opacity: opacity,
      // Hidden still reaches screen readers.
      alwaysIncludeSemantics: true,
      child: child,
    ),
  );
}

/// Room for glyphs that overhang tight line heights.
class _Bleed extends CustomClipper<Rect> {
  const _Bleed();

  @override
  Rect getClip(Size size) => (Offset.zero & size).inflate(16);

  @override
  bool shouldReclip(_Bleed oldClipper) => false;
}

/// The part of [reveal] that child [index] of [count] enters in, so a group
/// arrives one after another. Each child takes [span] of the whole.
Animation<double> staggered(
  Animation<double> reveal, {
  required int index,
  required int count,
  double span = 0.5,
}) {
  if (count < 2) return reveal;
  final start = (1 - span) * index / (count - 1);
  return reveal.drive(CurveTween(curve: Interval(start, start + span)));
}
