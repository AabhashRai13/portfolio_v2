import 'package:flutter/material.dart';

/// Semantic colors for the home page surfaces (hero, skills, projects,
/// contact, footer, and game overlays).
///
/// Mirrors `BlogPalette`: a [ThemeExtension] with `.light` / `.dark` variants
/// registered on `kLightTheme` / `kDarkTheme`, consumed via
/// `Theme.of(context).homePalette`. The `.light` values reproduce the colors
/// the home page used before theming, so light mode is visually unchanged.
@immutable
class HomePalette extends ThemeExtension<HomePalette> {
  const HomePalette({
    required this.heroGradient,
    required this.sectionBackground,
    required this.surfaceCard,
    required this.surfaceMuted,
    required this.glassFill,
    required this.glassBorder,
    required this.glassHighlightStrong,
    required this.glassHighlightSoft,
    required this.textStrong,
    required this.textSecondary,
    required this.onAccent,
    required this.primaryAccent,
    required this.secondaryAccent,
    required this.accentGradient,
    required this.nameGradient,
    required this.shadowColor,
  });

  /// Hero background gradient stops (4 stops, top-left radial).
  final List<Color> heroGradient;

  /// Solid background for full-bleed sections (skills, contact outer).
  final Color sectionBackground;

  /// Elevated card/tile surface (skill cards, project cards, contact card).
  final Color surfaceCard;

  /// Muted surface for secondary tiles (footer, mobile skill tiles, chips).
  final Color surfaceMuted;

  /// Frosted-glass fill tint.
  final Color glassFill;

  /// Frosted-glass border tint.
  final Color glassBorder;

  /// Stronger stop of the glass sheen overlay.
  final Color glassHighlightStrong;

  /// Softer stop of the glass sheen overlay.
  final Color glassHighlightSoft;

  /// Primary, high-emphasis text.
  final Color textStrong;

  /// Secondary, medium-emphasis text.
  final Color textSecondary;

  /// Foreground used on top of accent-colored surfaces (buttons).
  final Color onAccent;

  /// Brand primary accent.
  final Color primaryAccent;

  /// Brand secondary accent (coral).
  final Color secondaryAccent;

  /// Primary -> secondary accent gradient (bars, dividers, CTAs).
  final List<Color> accentGradient;

  /// Gradient used for the hero name shader.
  final List<Color> nameGradient;

  /// Generic shadow color.
  final Color shadowColor;

  static const HomePalette light = HomePalette(
    heroGradient: <Color>[
      Color(0xFFFFF1E6),
      Color(0xFFF5DCC6),
      Color(0xFFD7B49E),
      Color(0xFFB08968),
    ],
    sectionBackground: Color(0xFFFFF1E6),
    surfaceCard: Color(0xFFFFFFFF),
    surfaceMuted: Color(0xFFF7F8FA),
    glassFill: Color(0x26FFFFFF),
    glassBorder: Color(0x40FFFFFF),
    glassHighlightStrong: Color(0x33FFFFFF),
    glassHighlightSoft: Color(0x0DFFFFFF),
    textStrong: Color(0xFF5C4033),
    textSecondary: Color(0xFF6B4F3A),
    onAccent: Color(0xFFFFFFFF),
    primaryAccent: Color(0xFFBFA181),
    secondaryAccent: Color(0xFFE6A4A4),
    accentGradient: <Color>[
      Color(0xFFBFA181),
      Color(0xFFE6A4A4),
    ],
    nameGradient: <Color>[
      Color(0xFF5C4033),
      Color(0xFFE6A4A4),
    ],
    shadowColor: Color(0xFF000000),
  );

  static const HomePalette dark = HomePalette(
    heroGradient: <Color>[
      Color(0xFF1A1410),
      Color(0xFF231A12),
      Color(0xFF2E2118),
      Color(0xFF3A2A1C),
    ],
    sectionBackground: Color(0xFF1A1410),
    surfaceCard: Color(0xFF241C16),
    surfaceMuted: Color(0xFF2C231C),
    glassFill: Color(0x14FFFFFF),
    glassBorder: Color(0x1FFFFFFF),
    glassHighlightStrong: Color(0x0FFFFFFF),
    glassHighlightSoft: Color(0x05FFFFFF),
    textStrong: Color(0xFFF2E4D1),
    textSecondary: Color(0xFFB8A896),
    onAccent: Color(0xFFFFFFFF),
    primaryAccent: Color(0xFFD4B896),
    secondaryAccent: Color(0xFFE6A4A4),
    accentGradient: <Color>[
      Color(0xFFD4B896),
      Color(0xFFE6A4A4),
    ],
    nameGradient: <Color>[
      Color(0xFFF2E4D1),
      Color(0xFFE6A4A4),
    ],
    shadowColor: Color(0xFF000000),
  );

  @override
  HomePalette copyWith({
    List<Color>? heroGradient,
    Color? sectionBackground,
    Color? surfaceCard,
    Color? surfaceMuted,
    Color? glassFill,
    Color? glassBorder,
    Color? glassHighlightStrong,
    Color? glassHighlightSoft,
    Color? textStrong,
    Color? textSecondary,
    Color? onAccent,
    Color? primaryAccent,
    Color? secondaryAccent,
    List<Color>? accentGradient,
    List<Color>? nameGradient,
    Color? shadowColor,
  }) {
    return HomePalette(
      heroGradient: heroGradient ?? this.heroGradient,
      sectionBackground: sectionBackground ?? this.sectionBackground,
      surfaceCard: surfaceCard ?? this.surfaceCard,
      surfaceMuted: surfaceMuted ?? this.surfaceMuted,
      glassFill: glassFill ?? this.glassFill,
      glassBorder: glassBorder ?? this.glassBorder,
      glassHighlightStrong: glassHighlightStrong ?? this.glassHighlightStrong,
      glassHighlightSoft: glassHighlightSoft ?? this.glassHighlightSoft,
      textStrong: textStrong ?? this.textStrong,
      textSecondary: textSecondary ?? this.textSecondary,
      onAccent: onAccent ?? this.onAccent,
      primaryAccent: primaryAccent ?? this.primaryAccent,
      secondaryAccent: secondaryAccent ?? this.secondaryAccent,
      accentGradient: accentGradient ?? this.accentGradient,
      nameGradient: nameGradient ?? this.nameGradient,
      shadowColor: shadowColor ?? this.shadowColor,
    );
  }

  @override
  HomePalette lerp(ThemeExtension<HomePalette>? other, double t) {
    if (other is! HomePalette) return this;
    return HomePalette(
      heroGradient: _lerpColorList(heroGradient, other.heroGradient, t),
      sectionBackground:
          Color.lerp(sectionBackground, other.sectionBackground, t)!,
      surfaceCard: Color.lerp(surfaceCard, other.surfaceCard, t)!,
      surfaceMuted: Color.lerp(surfaceMuted, other.surfaceMuted, t)!,
      glassFill: Color.lerp(glassFill, other.glassFill, t)!,
      glassBorder: Color.lerp(glassBorder, other.glassBorder, t)!,
      glassHighlightStrong:
          Color.lerp(glassHighlightStrong, other.glassHighlightStrong, t)!,
      glassHighlightSoft:
          Color.lerp(glassHighlightSoft, other.glassHighlightSoft, t)!,
      textStrong: Color.lerp(textStrong, other.textStrong, t)!,
      textSecondary: Color.lerp(textSecondary, other.textSecondary, t)!,
      onAccent: Color.lerp(onAccent, other.onAccent, t)!,
      primaryAccent: Color.lerp(primaryAccent, other.primaryAccent, t)!,
      secondaryAccent: Color.lerp(secondaryAccent, other.secondaryAccent, t)!,
      accentGradient: _lerpColorList(accentGradient, other.accentGradient, t),
      nameGradient: _lerpColorList(nameGradient, other.nameGradient, t),
      shadowColor: Color.lerp(shadowColor, other.shadowColor, t)!,
    );
  }

  static List<Color> _lerpColorList(
    List<Color> a,
    List<Color> b,
    double t,
  ) {
    final length = a.length < b.length ? a.length : b.length;
    return <Color>[
      for (var i = 0; i < length; i++) Color.lerp(a[i], b[i], t)!,
    ];
  }
}

extension HomePaletteX on ThemeData {
  HomePalette get homePalette =>
      extension<HomePalette>() ?? HomePalette.light;
}
