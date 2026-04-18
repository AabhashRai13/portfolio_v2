import 'package:flutter/widgets.dart';
import 'package:flutter_markdown_plus/flutter_markdown_plus.dart';
import 'package:markdown/markdown.dart' as md;
import 'package:my_portfolio/features/blog_detail/domain/entities/toc_heading.dart';

class TocHeadingBuilder extends MarkdownElementBuilder {
  TocHeadingBuilder({
    required this.headings,
    required this.headingKeys,
  });

  final List<TocHeading> headings;
  final Map<String, GlobalKey> headingKeys;
  final Set<String> _matched = {};

  @override
  bool isBlockElement() => true;

  @override
  Widget? visitElementAfterWithContext(
    BuildContext context,
    md.Element element,
    TextStyle? preferredStyle,
    TextStyle? parentStyle,
  ) {
    final text = element.textContent;
    final heading = _findHeading(text);
    if (heading == null) return null;

    final key = headingKeys[heading.id];
    if (key == null) return null;

    return Container(
      key: key,
      width: double.infinity,
      padding: const EdgeInsets.only(bottom: 4),
      child: Text(text, style: preferredStyle),
    );
  }

  TocHeading? _findHeading(String text) {
    for (final heading in headings) {
      if (heading.text == text && !_matched.contains(heading.id)) {
        _matched.add(heading.id);
        return heading;
      }
    }
    return null;
  }
}
