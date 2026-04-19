import 'package:flutter/material.dart';

@immutable
class BlogPalette extends ThemeExtension<BlogPalette> {
  const BlogPalette({
    required this.pageGradient,
    required this.surfaceElevated,
    required this.surfaceSubtle,
    required this.borderSoft,
    required this.dividerSoft,
    required this.textStrong,
    required this.textSecondary,
    required this.textMuted,
    required this.metaAccent,
    required this.tagChipBackground,
    required this.tagChipForeground,
    required this.tagChipBorder,
    required this.headerGradient,
    required this.engagementGradient,
    required this.codeBlockGradient,
    required this.codeBlockBorder,
    required this.codeInlineColor,
    required this.serifBodyColor,
    required this.serifMutedColor,
    required this.shadowColor,
  });

  final List<Color> pageGradient;
  final Color surfaceElevated;
  final Color surfaceSubtle;
  final Color borderSoft;
  final Color dividerSoft;
  final Color textStrong;
  final Color textSecondary;
  final Color textMuted;
  final Color metaAccent;
  final Color tagChipBackground;
  final Color tagChipForeground;
  final Color tagChipBorder;
  final List<Color> headerGradient;
  final List<Color> engagementGradient;
  final List<Color> codeBlockGradient;
  final Color codeBlockBorder;
  final Color codeInlineColor;
  final Color serifBodyColor;
  final Color serifMutedColor;
  final Color shadowColor;

  static const BlogPalette light = BlogPalette(
    pageGradient: <Color>[
      Color(0xFFFFFBF7),
      Color(0xFFFFF4EA),
      Color(0xFFFFFFFF),
    ],
    surfaceElevated: Color(0xFFFFFFFF),
    surfaceSubtle: Color(0xFFFFF8F1),
    borderSoft: Color(0xFFF1E2D3),
    dividerSoft: Color(0xFFF0E5DA),
    textStrong: Color(0xFF2D241E),
    textSecondary: Color(0xFF7A6757),
    textMuted: Color(0xFF9A8C80),
    metaAccent: Color(0xFFBFA181),
    tagChipBackground: Color(0xFFF4EEEA),
    tagChipForeground: Color(0xFF8B7D72),
    tagChipBorder: Color(0x29BFA181),
    headerGradient: <Color>[
      Color(0xFFFFFCF8),
      Color(0xFFFFF5EB),
    ],
    engagementGradient: <Color>[
      Color(0xFFFFFFFF),
      Color(0xFFFFFAF4),
    ],
    codeBlockGradient: <Color>[
      Color(0xFFFFFCF8),
      Color(0xFFF8EEE4),
    ],
    codeBlockBorder: Color(0xFFDEC7B2),
    codeInlineColor: Color(0xFF7A4D3A),
    serifBodyColor: Color(0xFF2D241E),
    serifMutedColor: Color(0xFF7A6757),
    shadowColor: Color(0x14000000),
  );

  static const BlogPalette dark = BlogPalette(
    pageGradient: <Color>[
      Color(0xFF1A1410),
      Color(0xFF221A14),
      Color(0xFF160F0B),
    ],
    surfaceElevated: Color(0xFF241C16),
    surfaceSubtle: Color(0xFF2C231C),
    borderSoft: Color(0xFF3D2F24),
    dividerSoft: Color(0xFF3A2E24),
    textStrong: Color(0xFFF2E4D1),
    textSecondary: Color(0xFFC4B3A0),
    textMuted: Color(0xFF8A7868),
    metaAccent: Color(0xFFD4B896),
    tagChipBackground: Color(0xFF332820),
    tagChipForeground: Color(0xFFC4B3A0),
    tagChipBorder: Color(0x3DD4B896),
    headerGradient: <Color>[
      Color(0xFF2A2118),
      Color(0xFF1F1811),
    ],
    engagementGradient: <Color>[
      Color(0xFF2A2118),
      Color(0xFF1F1811),
    ],
    codeBlockGradient: <Color>[
      Color(0xFF1F1811),
      Color(0xFF160F0B),
    ],
    codeBlockBorder: Color(0xFF4A3A2C),
    codeInlineColor: Color(0xFFE6B894),
    serifBodyColor: Color(0xFFE8DAC5),
    serifMutedColor: Color(0xFFB8A896),
    shadowColor: Color(0x66000000),
  );

  @override
  BlogPalette copyWith({
    List<Color>? pageGradient,
    Color? surfaceElevated,
    Color? surfaceSubtle,
    Color? borderSoft,
    Color? dividerSoft,
    Color? textStrong,
    Color? textSecondary,
    Color? textMuted,
    Color? metaAccent,
    Color? tagChipBackground,
    Color? tagChipForeground,
    Color? tagChipBorder,
    List<Color>? headerGradient,
    List<Color>? engagementGradient,
    List<Color>? codeBlockGradient,
    Color? codeBlockBorder,
    Color? codeInlineColor,
    Color? serifBodyColor,
    Color? serifMutedColor,
    Color? shadowColor,
  }) {
    return BlogPalette(
      pageGradient: pageGradient ?? this.pageGradient,
      surfaceElevated: surfaceElevated ?? this.surfaceElevated,
      surfaceSubtle: surfaceSubtle ?? this.surfaceSubtle,
      borderSoft: borderSoft ?? this.borderSoft,
      dividerSoft: dividerSoft ?? this.dividerSoft,
      textStrong: textStrong ?? this.textStrong,
      textSecondary: textSecondary ?? this.textSecondary,
      textMuted: textMuted ?? this.textMuted,
      metaAccent: metaAccent ?? this.metaAccent,
      tagChipBackground: tagChipBackground ?? this.tagChipBackground,
      tagChipForeground: tagChipForeground ?? this.tagChipForeground,
      tagChipBorder: tagChipBorder ?? this.tagChipBorder,
      headerGradient: headerGradient ?? this.headerGradient,
      engagementGradient: engagementGradient ?? this.engagementGradient,
      codeBlockGradient: codeBlockGradient ?? this.codeBlockGradient,
      codeBlockBorder: codeBlockBorder ?? this.codeBlockBorder,
      codeInlineColor: codeInlineColor ?? this.codeInlineColor,
      serifBodyColor: serifBodyColor ?? this.serifBodyColor,
      serifMutedColor: serifMutedColor ?? this.serifMutedColor,
      shadowColor: shadowColor ?? this.shadowColor,
    );
  }

  @override
  BlogPalette lerp(ThemeExtension<BlogPalette>? other, double t) {
    if (other is! BlogPalette) return this;
    return BlogPalette(
      pageGradient: _lerpColorList(pageGradient, other.pageGradient, t),
      surfaceElevated:
          Color.lerp(surfaceElevated, other.surfaceElevated, t)!,
      surfaceSubtle: Color.lerp(surfaceSubtle, other.surfaceSubtle, t)!,
      borderSoft: Color.lerp(borderSoft, other.borderSoft, t)!,
      dividerSoft: Color.lerp(dividerSoft, other.dividerSoft, t)!,
      textStrong: Color.lerp(textStrong, other.textStrong, t)!,
      textSecondary: Color.lerp(textSecondary, other.textSecondary, t)!,
      textMuted: Color.lerp(textMuted, other.textMuted, t)!,
      metaAccent: Color.lerp(metaAccent, other.metaAccent, t)!,
      tagChipBackground:
          Color.lerp(tagChipBackground, other.tagChipBackground, t)!,
      tagChipForeground:
          Color.lerp(tagChipForeground, other.tagChipForeground, t)!,
      tagChipBorder: Color.lerp(tagChipBorder, other.tagChipBorder, t)!,
      headerGradient:
          _lerpColorList(headerGradient, other.headerGradient, t),
      engagementGradient:
          _lerpColorList(engagementGradient, other.engagementGradient, t),
      codeBlockGradient:
          _lerpColorList(codeBlockGradient, other.codeBlockGradient, t),
      codeBlockBorder: Color.lerp(codeBlockBorder, other.codeBlockBorder, t)!,
      codeInlineColor: Color.lerp(codeInlineColor, other.codeInlineColor, t)!,
      serifBodyColor: Color.lerp(serifBodyColor, other.serifBodyColor, t)!,
      serifMutedColor: Color.lerp(serifMutedColor, other.serifMutedColor, t)!,
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

extension BlogPaletteX on ThemeData {
  BlogPalette get blogPalette =>
      extension<BlogPalette>() ?? BlogPalette.light;
}
