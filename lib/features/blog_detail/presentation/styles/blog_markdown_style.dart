import 'package:flutter/material.dart';
import 'package:flutter_markdown_plus/flutter_markdown_plus.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:my_portfolio/constants/colors.dart';

// The blog has its own styling because its theme differs slightly from the
// rest of the portfolio and should prioritize readability for long-form text.

class BlogMarkdownStyle {
  const BlogMarkdownStyle._();

  static MarkdownStyleSheet of(ThemeData theme) {
    final textTheme = theme.textTheme;

    return MarkdownStyleSheet.fromTheme(theme).copyWith(
      p: _serifBody,
      h1: textTheme.headlineMedium?.copyWith(
        fontSize: 30,
        fontWeight: FontWeight.w800,
        color: CustomColor.textPrimary,
      ),
      h2: textTheme.headlineSmall?.copyWith(
        fontSize: 24,
        fontWeight: FontWeight.w700,
        color: CustomColor.textPrimary,
      ),
      h3: textTheme.titleLarge?.copyWith(
        fontSize: 20,
        fontWeight: FontWeight.w700,
        color: CustomColor.textPrimary,
      ),
      blockquote: _serifBlockquote,
      listBullet: textTheme.bodyLarge?.copyWith(
        color: CustomColor.secondary,
        fontWeight: FontWeight.w700,
      ),
      code: _codeInline,
      codeblockDecoration: _codeblockDecoration,
      codeblockPadding: const EdgeInsets.fromLTRB(22, 20, 22, 22),
      codeblockAlign: WrapAlignment.start,
    );
  }

  static final TextStyle _serifBody = GoogleFonts.lora(
    fontSize: 17,
    height: 1.85,
    color: CustomColor.textPrimary,
  );

  static final TextStyle _serifBlockquote = GoogleFonts.lora(
    fontSize: 17,
    color: CustomColor.textSecondary,
    height: 1.75,
    fontStyle: FontStyle.italic,
  );

  static final TextStyle _codeInline = GoogleFonts.jetBrainsMono(
    fontSize: 13,
    height: 1.5,
    color: const Color(0xFF7A4D3A),
    fontWeight: FontWeight.w500,
    backgroundColor: Colors.transparent,
  );

  static final BoxDecoration _codeblockDecoration = BoxDecoration(
    gradient: const LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: <Color>[
        Color(0xFFFFFCF8),
        Color(0xFFF8EEE4),
      ],
    ),
    borderRadius: BorderRadius.circular(22),
    border: Border.all(
      color: const Color(0xFFDEC7B2),
      width: 1.2,
    ),
    boxShadow: <BoxShadow>[
      BoxShadow(
        color: const Color(0xFF5C4033).withValues(alpha: 0.07),
        blurRadius: 20,
        offset: const Offset(0, 12),
      ),
    ],
  );
}
