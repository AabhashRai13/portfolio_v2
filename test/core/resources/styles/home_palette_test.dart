import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:my_portfolio/core/resources/styles/home_palette.dart';

void main() {
  test('tagline text uses the deep tan in light and dark', () {
    expect(HomePalette.light.taglineText, const Color(0xFFA67B5B));
    expect(HomePalette.dark.taglineText, const Color(0xFFD4B896));
  });

  test('lerp and copyWith carry taglineText', () {
    final mid = HomePalette.light.lerp(HomePalette.dark, 0.5);
    expect(
      mid.taglineText,
      Color.lerp(const Color(0xFFA67B5B), const Color(0xFFD4B896), 0.5),
    );

    final copy = HomePalette.light.copyWith(
      taglineText: const Color(0xFF000000),
    );
    expect(copy.taglineText, const Color(0xFF000000));
  });

  test('link hover/focus colour is a darker rose in light, coral in dark', () {
    expect(HomePalette.light.linkActive, const Color(0xFF9E4F52));
    expect(HomePalette.dark.linkActive, const Color(0xFFE6A4A4));
  });
}
