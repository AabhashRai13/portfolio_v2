import 'package:flutter/material.dart';
import 'package:my_portfolio/resources/configs/ui.dart';

class AppDimensions {
  static double? maxContainerWidth;
  static double? miniContainerWidth;

  static bool? isLandscape;
  static double? padding;
  static double ratio = 0;

  static Size? size;

  static void init() {
    ratio = UI.width! / UI.height!;
    final pixelDensity = UI.mediaQuery().devicePixelRatio;
    ratio = ratio + ((pixelDensity + ratio) / 2);

    if (UI.width! <= 380 && pixelDensity >= 3) {
      ratio *= 0.85;
    }

    _initLargeScreens();
    _initSmallScreensHighDensity();

    padding = ratio * 3;
  }

  static void _initLargeScreens() {
    const safe = 2.4;

    ratio *= 1.5;

    if (ratio > safe) {
      ratio = safe;
    }
  }

  static void _initSmallScreensHighDensity() {
    if (!UI.sm! && ratio > 2.0) {
      ratio = 2.0;
    }
    if (!UI.xs! && ratio > 1.6) {
      ratio = 1.6;
    }
    if (!UI.xxs! && ratio > 1.4) {
      ratio = 1.4;
    }
  }


  static double space([double multiplier = 1.0]) {
    return AppDimensions.padding! * 3 * multiplier;
  }

  static double normalize(double unit) {
    return (AppDimensions.ratio * unit * 0.77) + unit;
  }

  static double font(double unit) {
    return (AppDimensions.ratio * unit * 0.125) + unit * 1.90;
  }
}
