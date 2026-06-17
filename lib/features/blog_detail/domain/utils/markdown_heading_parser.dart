import 'package:markdown/markdown.dart' as md;
import 'package:my_portfolio/features/blog_detail/domain/entities/blog_post_section.dart';
import 'package:my_portfolio/features/blog_detail/domain/entities/toc_heading.dart';

typedef ParsedMarkdown = ({
  List<TocHeading> headings,
  List<BlogPostSection> sections,
});

/// Parses the article markdown into the canonical heading list *and* the
/// per-heading section list in a single pass so they stay consistent.
///
/// Sections are the unit the UI renders (each gets its own MarkdownBody +
/// GlobalKey for TOC scrolling). Using the same walk for both means we
/// never have a heading in the TOC that doesn't correspond to a section.
ParsedMarkdown parseMarkdownDocument(String markdown) {
  final canonicalHeadings = _parseCanonicalHeadings(markdown);

  final sections = <BlogPostSection>[];
  final headings = <TocHeading>[];
  var headingIndex = 0;

  final lines = markdown.split('\n');
  var inCodeBlock = false;
  TocHeading? currentHeading;
  var currentLines = <String>[];

  void flush() {
    if (currentLines.isEmpty && currentHeading == null) return;
    sections.add(
      BlogPostSection(
        heading: currentHeading,
        markdown: currentLines.join('\n'),
      ),
    );
  }

  for (final line in lines) {
    if (line.trimLeft().startsWith('```')) {
      inCodeBlock = !inCodeBlock;
    }

    final isHeading = !inCodeBlock &&
        RegExp(r'^\s{0,3}(#{2,3})\s+\S').hasMatch(line);

    if (isHeading && headingIndex < canonicalHeadings.length) {
      flush();
      currentHeading = canonicalHeadings[headingIndex++];
      headings.add(currentHeading);
      currentLines = <String>[line];
    } else {
      currentLines.add(line);
    }
  }
  flush();

  return (headings: headings, sections: sections);
}

List<TocHeading> parseMarkdownHeadings(String markdown) {
  return parseMarkdownDocument(markdown).headings;
}

List<TocHeading> _parseCanonicalHeadings(String markdown) {
  final document = md.Document(
    extensionSet: md.ExtensionSet.gitHubFlavored,
  );
  final nodes = document.parseLines(markdown.split('\n'));
  final headings = <TocHeading>[];
  final slugCounts = <String, int>{};

  for (final node in nodes) {
    if (node is! md.Element) continue;

    final level = switch (node.tag) {
      'h2' => 2,
      'h3' => 3,
      _ => null,
    };
    if (level == null) continue;

    final text = _extractText(node);
    if (text.isEmpty) continue;

    var slug = _slugify(text);
    final count = slugCounts[slug] ?? 0;
    slugCounts[slug] = count + 1;
    if (count > 0) {
      slug = '$slug-$count';
    }

    headings.add(TocHeading(text: text, level: level, id: slug));
  }

  return headings;
}

String _extractText(md.Node node) {
  if (node is md.Text) return node.textContent;
  if (node is md.Element) {
    return node.children?.map(_extractText).join() ?? '';
  }
  return '';
}

String _slugify(String text) {
  return text
      .toLowerCase()
      .replaceAll(RegExp(r'[^a-z0-9\s-]'), '')
      .replaceAll(RegExp(r'\s+'), '-')
      .replaceAll(RegExp('-+'), '-')
      .replaceAll(RegExp(r'^-|-$'), '');
}
