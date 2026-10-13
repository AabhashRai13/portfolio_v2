import 'package:flutter/widgets.dart';
import 'package:my_portfolio/features/landing/presentation/controllers/landing_preview_controller.dart';

/// Rebuilds [builder] on a looping timeline of [duration]. Pauses while
/// tickers are off (another route covers the landing) and rests on the
/// final frame with reduced motion.
class LandingLoopingPreview extends StatefulWidget {
  const LandingLoopingPreview({
    required this.duration,
    required this.builder,
    super.key,
  });

  final Duration duration;
  final Widget Function(BuildContext, Animation<double>) builder;

  @override
  State<LandingLoopingPreview> createState() => _LandingLoopingPreviewState();
}

class _LandingLoopingPreviewState extends State<LandingLoopingPreview>
    with SingleTickerProviderStateMixin {
  late final LandingPreviewController _motion;

  @override
  void initState() {
    super.initState();
    _motion = LandingPreviewController(
      vsync: this,
      duration: widget.duration,
    );
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final motionDisabled = MediaQuery.of(context).disableAnimations;
    final tickerEnabled = TickerMode.valuesOf(context).enabled;

    _motion.sync(
      tickerEnabled: tickerEnabled,
      reduceMotion: motionDisabled,
    );
  }

  @override
  void didUpdateWidget(LandingLoopingPreview oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.duration != widget.duration) {
      _motion.duration = widget.duration;
    }
  }

  @override
  void dispose() {
    _motion.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _motion.animation,
      builder: (context, _) => widget.builder(context, _motion.animation),
    );
  }
}
