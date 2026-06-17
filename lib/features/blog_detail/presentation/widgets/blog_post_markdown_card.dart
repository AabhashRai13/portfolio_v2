import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_markdown_plus/flutter_markdown_plus.dart';
import 'package:my_portfolio/core/resources/styles/blog_palette.dart';
import 'package:my_portfolio/features/blog_detail/domain/entities/blog_post_section.dart';
import 'package:my_portfolio/features/blog_detail/presentation/styles/blog_markdown_style.dart';

const double _sectionBottomPadding = 12;
const double _markdownImageMaxHeight = 600;

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
          for (var index = 0; index < sections.length; index++)
            Padding(
              padding: EdgeInsets.only(
                bottom: index == sections.length - 1 && !kDebugMode
                    ? 0
                    : _sectionBottomPadding,
              ),
              child: _Section(
                key: sections[index].heading == null
                    ? null
                    : sectionKeys[sections[index].heading!.id],
                markdown: sections[index].markdown,
                styleSheet: styleSheet,
                imageMaxHeight: _markdownImageMaxHeight,
                onOpenLink: onOpenLink,
              ),
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
    required this.imageMaxHeight,
    required this.onOpenLink,
    super.key,
  });

  final String markdown;
  final MarkdownStyleSheet styleSheet;
  final double imageMaxHeight;
  final Future<void> Function(String url) onOpenLink;

  @override
  Widget build(BuildContext context) {
    return MarkdownBody(
      data: markdown,
      selectable: true,
      styleSheet: styleSheet,
      imageBuilder: (uri, title, alt) => _MarkdownImage(
        uri: uri,
        title: title,
        alt: alt,
        maxHeight: imageMaxHeight,
      ),
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

class _MarkdownImage extends StatelessWidget {
  const _MarkdownImage({
    required this.uri,
    required this.maxHeight,
    this.title,
    this.alt,
  });

  final Uri uri;
  final String? title;
  final String? alt;
  final double maxHeight;

  @override
  Widget build(BuildContext context) {
    final palette = Theme.of(context).blogPalette;

    return ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: ColoredBox(
        color: palette.surfaceSubtle,
        child: LayoutBuilder(
          builder: (context, constraints) {
            return ConstrainedBox(
              constraints: BoxConstraints(
                maxWidth: constraints.maxWidth,
                maxHeight: maxHeight,
              ),
              child: _buildImage(),
            );
          },
        ),
      ),
    );
  }

  Widget _buildImage() {
    final semanticLabel = alt?.isNotEmpty ?? false ? alt : title;

    if (uri.scheme == 'http' || uri.scheme == 'https') {
      return Image.network(
        uri.toString(),
        width: double.infinity,
        fit: BoxFit.contain,
        semanticLabel: semanticLabel,
        errorBuilder: _buildImageError,
      );
    }

    if (uri.scheme == 'resource') {
      return Image.asset(
        uri.path,
        width: double.infinity,
        fit: BoxFit.contain,
        semanticLabel: semanticLabel,
        errorBuilder: _buildImageError,
      );
    }

    if (uri.scheme == 'data') {
      UriData data;
      try {
        data = UriData.parse(uri.toString());
      } on FormatException {
        return const SizedBox.shrink();
      }

      return Image.memory(
        data.contentAsBytes(),
        width: double.infinity,
        fit: BoxFit.contain,
        semanticLabel: semanticLabel,
        errorBuilder: _buildImageError,
      );
    }

    return Image.asset(
      uri.toString(),
      width: double.infinity,
      fit: BoxFit.contain,
      semanticLabel: semanticLabel,
      errorBuilder: _buildImageError,
    );
  }

  Widget _buildImageError(
    BuildContext context,
    Object error,
    StackTrace? stackTrace,
  ) {
    debugPrint('Markdown image failed to load: $uri');
    debugPrint('Markdown image error: $error');
    if (stackTrace != null) {
      debugPrintStack(
        stackTrace: stackTrace,
        label: 'Markdown image stack trace for $uri',
      );
    }

    final palette = Theme.of(context).blogPalette;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: palette.surfaceElevated,
        border: Border.all(color: palette.borderSoft),
        borderRadius: BorderRadius.circular(16),
      ),
      child: SelectableText(
        'Image failed to load\n$uri\n$error',
        style: Theme.of(context).textTheme.bodySmall?.copyWith(
          color: palette.textSecondary,
        ),
      ),
    );
  }
}
