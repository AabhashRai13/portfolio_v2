import 'package:flutter/material.dart';
import 'package:flutter_markdown_plus/flutter_markdown_plus.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:my_portfolio/constants/colors.dart';

class BlogPostMarkdownCard extends StatelessWidget {
  const BlogPostMarkdownCard({
    required this.contentMarkdown,
    required this.onOpenLink,
    super.key,
  });

  final String contentMarkdown;
  final Future<void> Function(String url) onOpenLink;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;
    final codeTextStyle = GoogleFonts.jetBrainsMono(
      fontSize: 13.5,
      height: 1.7,
      color: const Color(0xFF4F3A30),
      fontWeight: FontWeight.w500,
    );

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(28),
        boxShadow: <BoxShadow>[
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 18,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: MarkdownBody(
        data: contentMarkdown,
        selectable: true,
        onTapLink: (text, href, title) async {
          if (href == null || href.isEmpty) {
            return;
          }
          try {
            await onOpenLink(href);
          } on Exception {
            if (!context.mounted) {
              return;
            }
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Unable to open that link.'),
              ),
            );
          }
        },
        styleSheet:
            MarkdownStyleSheet.fromTheme(
              theme,
            ).copyWith(
              p: textTheme.bodyLarge?.copyWith(
                color: CustomColor.textPrimary,
                height: 1.8,
              ),
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
              blockquote: textTheme.bodyLarge?.copyWith(
                color: CustomColor.textSecondary,
                height: 1.7,
                fontStyle: FontStyle.italic,
              ),
              listBullet: textTheme.bodyLarge?.copyWith(
                color: CustomColor.secondary,
                fontWeight: FontWeight.w700,
              ),
              code: codeTextStyle.copyWith(
                fontSize: 13,
                height: 1.5,
                color: const Color(0xFF7A4D3A),
                backgroundColor: Colors.transparent,
              ),
              codeblockDecoration: BoxDecoration(
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
              ),
              codeblockPadding: const EdgeInsets.fromLTRB(22, 20, 22, 22),
              codeblockAlign: WrapAlignment.start,
            ),
      ),
    );
  }
}
