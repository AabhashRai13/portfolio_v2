import 'package:flutter/material.dart';
import 'package:flutter_markdown_plus/flutter_markdown_plus.dart';
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
              Theme.of(context),
            ).copyWith(
              p: const TextStyle(
                fontSize: 16,
                height: 1.8,
                color: CustomColor.textPrimary,
              ),
              h1: const TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.w800,
                color: CustomColor.textPrimary,
              ),
              h2: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w700,
                color: CustomColor.textPrimary,
              ),
              codeblockDecoration: BoxDecoration(
                color: const Color(0xFFF7EFE7),
                borderRadius: BorderRadius.circular(16),
              ),
            ),
      ),
    );
  }
}
