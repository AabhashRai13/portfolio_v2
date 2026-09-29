import 'package:flutter/painting.dart';

/// Type styles for the landing hub and inner pages. Families are bundled in
/// `assets/fonts/` (see pubspec), not fetched at runtime.
abstract final class SiteText {
  static const String displayFamily = 'ArchivoExtraCondensed';
  static const String taglineFamily = 'ArchivoCondensed';
  static const String monoFamily = 'IBMPlexMono';

  /// Huge condensed caps: the name and page titles.
  static TextStyle display(Color color, {required double size}) => TextStyle(
    fontFamily: displayFamily,
    fontWeight: FontWeight.w900,
    fontSize: size,
    height: 0.92,
    letterSpacing: -0.01 * size,
    color: color,
  );

  /// Slightly wider condensed caps for the tagline.
  static TextStyle tagline(Color color, {required double size}) => TextStyle(
    fontFamily: taglineFamily,
    fontWeight: FontWeight.w800,
    fontSize: size,
    height: 1,
    color: color,
  );

  /// Small tracked mono caps: labels, links, captions.
  static TextStyle label(Color color, {double size = 13}) => TextStyle(
    fontFamily: monoFamily,
    fontWeight: FontWeight.w500,
    fontSize: size,
    letterSpacing: size * 0.18,
    color: color,
  );

  /// Readable body copy in the app's default text font.
  static TextStyle body(Color color, {double size = 18}) =>
      TextStyle(fontSize: size, height: 1.6, color: color);
}
