import 'package:markdown/markdown.dart' as md;
import 'package:my_portfolio/features/blog_detail/domain/entities/toc_heading.dart';

List<TocHeading> parseMarkdownHeadings(String markdown) {
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
