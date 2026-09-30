import 'package:flutter/animation.dart';

/// Owns the looping timeline used by one live landing preview.
class LandingPreviewController {
  LandingPreviewController({
    required TickerProvider vsync,
    required Duration duration,
  }) : animation = AnimationController(vsync: vsync, duration: duration);

  final AnimationController animation;

  Duration get duration => animation.duration!;
  set duration(Duration value) => animation.duration = value;

  void sync({required bool tickerEnabled, required bool reduceMotion}) {
    if (reduceMotion) {
      animation
        ..stop()
        ..value = 1;
    } else if (tickerEnabled && !animation.isAnimating) {
      animation.repeat();
    } else if (!tickerEnabled) {
      animation.stop();
    }
  }

  void dispose() => animation.dispose();
}
