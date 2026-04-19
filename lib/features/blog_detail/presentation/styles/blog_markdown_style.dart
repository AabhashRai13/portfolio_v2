import 'package:flutter/material.dart';
import 'package:flutter_markdown_plus/flutter_markdown_plus.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:my_portfolio/core/resources/styles/blog_palette.dart';

// The blog has its own styling because its theme differs slightly from the
// rest of the portfolio and should prioritize readability for long-form text.

class BlogMarkdownStyle {
  const BlogMarkdownStyle._();

  static MarkdownStyleSheet of(ThemeData theme) {
    final textTheme = theme.textTheme;
    final palette = theme.blogPalette;

    final serifBody = GoogleFonts.lora(
      fontSize: 17,
      height: 1.85,
      color: palette.serifBodyColor,
    );

    final serifBlockquote = GoogleFonts.lora(
      fontSize: 17,
      color: palette.serifMutedColor,
      height: 1.75,
      fontStyle: FontStyle.italic,
    );

    final codeInline = GoogleFonts.jetBrainsMono(
      fontSize: 13,
      height: 1.5,
      color: palette.codeInlineColor,
      fontWeight: FontWeight.w500,
      backgroundColor: Colors.transparent,
    );

    final codeblockDecoration = BoxDecoration(
      gradient: LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: palette.codeBlockGradient,
      ),
      borderRadius: BorderRadius.circular(22),
      border: Border.all(
        color: palette.codeBlockBorder,
        width: 1.2,
      ),
      boxShadow: <BoxShadow>[
        BoxShadow(
          color: palette.shadowColor,
          blurRadius: 20,
          offset: const Offset(0, 12),
        ),
      ],
    );

    return MarkdownStyleSheet.fromTheme(theme).copyWith(
      p: serifBody,
      h1: textTheme.headlineMedium?.copyWith(
        fontSize: 30,
        fontWeight: FontWeight.w800,
        color: palette.textStrong,
      ),
      h2: textTheme.headlineSmall?.copyWith(
        fontSize: 24,
        fontWeight: FontWeight.w700,
        color: palette.textStrong,
      ),
      h3: textTheme.titleLarge?.copyWith(
        fontSize: 20,
        fontWeight: FontWeight.w700,
        color: palette.textStrong,
      ),
      blockquote: serifBlockquote,
      listBullet: textTheme.bodyLarge?.copyWith(
        color: theme.colorScheme.secondary,
        fontWeight: FontWeight.w700,
      ),
      code: codeInline,
      codeblockDecoration: codeblockDecoration,
      codeblockPadding: const EdgeInsets.fromLTRB(22, 20, 22, 22),
      codeblockAlign: WrapAlignment.start,
    );
  }
}
