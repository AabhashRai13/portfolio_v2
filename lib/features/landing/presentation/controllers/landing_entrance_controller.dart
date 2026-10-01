import 'package:flutter/animation.dart';

/// Owns the landing entrance timeline while the widget layer only renders it.
class LandingEntranceController {
  LandingEntranceController({required TickerProvider vsync})
    : animation = AnimationController(
        vsync: vsync,
        duration: const Duration(milliseconds: 1800),
      );

  final AnimationController animation;

  void sync({required bool routeActive, required bool reduceMotion}) {
    if (reduceMotion) {
      animation
        ..stop()
        ..value = 1;
      return;
    }

    if (!routeActive) {
      animation.stop();
      return;
    }

    if (!animation.isAnimating && animation.value < 1) {
      animation.forward();
    }
  }

  void dispose() => animation.dispose();
}
