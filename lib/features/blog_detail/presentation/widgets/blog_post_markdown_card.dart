import 'package:flutter/material.dart';
import 'package:flutter_markdown_plus/flutter_markdown_plus.dart';
import 'package:my_portfolio/features/blog_detail/domain/entities/toc_heading.dart';
import 'package:my_portfolio/features/blog_detail/presentation/styles/blog_markdown_style.dart';
import 'package:my_portfolio/features/blog_detail/presentation/widgets/heading_builder.dart';

class BlogPostMarkdownCard extends StatelessWidget {
  const BlogPostMarkdownCard({
    required this.contentMarkdown,
    required this.onOpenLink,
    this.headings = const <TocHeading>[],
    this.headingKeys = const <String, GlobalKey>{},
    super.key,
  });

  final String contentMarkdown;
  final Future<void> Function(String url) onOpenLink;
  final List<TocHeading> headings;
  final Map<String, GlobalKey> headingKeys;

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
        builders: headings.isEmpty
            ? const <String, MarkdownElementBuilder>{}
            : <String, MarkdownElementBuilder>{
                'h2': TocHeadingBuilder(
                  headings: headings,
                  headingKeys: headingKeys,
                ),
                'h3': TocHeadingBuilder(
                  headings: headings,
                  headingKeys: headingKeys,
                ),
              },
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
        styleSheet: BlogMarkdownStyle.of(Theme.of(context)),
      ),
    );
  }
}
