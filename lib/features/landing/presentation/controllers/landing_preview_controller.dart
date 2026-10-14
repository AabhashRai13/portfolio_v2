import 'dart:async';

import 'package:flutter/animation.dart';

/// Owns the looping timeline used by one live landing preview.
class LandingPreviewController {
  LandingPreviewController({
    required TickerProvider vsync,
    required Duration duration,
  }) : animation = AnimationController(vsync: vsync, duration: duration);

  /// Loops played before the preview rests on its final frame, so an idle
  /// landing stops drawing.
  static const int loops = 2;

  final AnimationController animation;

  Duration get duration => animation.duration!;
  set duration(Duration value) => animation.duration = value;

  void sync({required bool tickerEnabled, required bool reduceMotion}) {
    if (reduceMotion) {
      animation
        ..stop()
        ..value = 1;
    } else if (tickerEnabled && !animation.isAnimating) {
      // repeat(count:) stops on whichever tick ends it; land on the last frame.
      unawaited(
        animation.repeat(count: loops).then((_) => animation.value = 1),
      );
    } else if (!tickerEnabled) {
      animation.stop();
    }
  }

  void dispose() => animation.dispose();
}
