import 'package:flutter/material.dart';
import 'package:flutter_markdown_plus/flutter_markdown_plus.dart';
import 'package:my_portfolio/core/resources/styles/blog_palette.dart';
import 'package:my_portfolio/features/blog_detail/domain/entities/blog_post_section.dart';
import 'package:my_portfolio/features/blog_detail/presentation/styles/blog_markdown_style.dart';

// The article is rendered as one MarkdownBody per section instead of a single
// MarkdownBody for the whole post so TOC GlobalKeys can live on widgets we
// own (the outer `_Section`). A previous design injected keys into the
// markdown tree via a custom MarkdownElementBuilder; those keys got detached
// whenever MarkdownBody rebuilt (e.g. theme toggle → new stylesheet → full
// re-render), leaving `key.currentContext == null` and silently breaking
// `Scrollable.ensureVisible`. Keys on widgets we own are preserved by normal
// Flutter reconciliation.
class BlogPostMarkdownCard extends StatelessWidget {
  const BlogPostMarkdownCard({
    required this.sections,
    required this.onOpenLink,
    this.sectionKeys = const <String, GlobalKey>{},
    super.key,
  });

  final List<BlogPostSection> sections;
  final Map<String, GlobalKey> sectionKeys;
  final Future<void> Function(String url) onOpenLink;

  @override
  Widget build(BuildContext context) {
    final palette = Theme.of(context).blogPalette;
    final styleSheet = BlogMarkdownStyle.of(Theme.of(context));

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: palette.surfaceElevated,
        borderRadius: BorderRadius.circular(28),
        boxShadow: <BoxShadow>[
          BoxShadow(
            color: palette.shadowColor,
            blurRadius: 18,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          for (final section in sections)
            _Section(
              key: section.heading == null
                  ? null
                  : sectionKeys[section.heading!.id],
              markdown: section.markdown,
              styleSheet: styleSheet,
              onOpenLink: onOpenLink,
            ),
        ],
      ),
    );
  }
}

class _Section extends StatelessWidget {
  const _Section({
    required this.markdown,
    required this.styleSheet,
    required this.onOpenLink,
    super.key,
  });

  final String markdown;
  final MarkdownStyleSheet styleSheet;
  final Future<void> Function(String url) onOpenLink;

  @override
  Widget build(BuildContext context) {
    return MarkdownBody(
      data: markdown,
      selectable: true,
      styleSheet: styleSheet,
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
    );
  }
}
