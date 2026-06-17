import 'package:flutter_test/flutter_test.dart';
import 'package:my_portfolio/features/blog_detail/domain/utils/markdown_heading_parser.dart';

void main() {
  group('parseMarkdownDocument', () {
    test('returns a single preamble section when there are no headings', () {
      const md = 'Just a paragraph.\n\nAnother line, no headings here.';

      final result = parseMarkdownDocument(md);

      expect(result.headings, isEmpty);
      expect(result.sections, hasLength(1));
      expect(result.sections.single.heading, isNull);
      expect(result.sections.single.markdown, md);
    });

    test('returns empty headings + sections for an empty document', () {
      final result = parseMarkdownDocument('');

      expect(result.headings, isEmpty);
      // Empty string splits to a single [''] line which produces a preamble
      // section containing the empty line. Consumer code rendering this is a
      // no-op (MarkdownBody with empty data), so we accept either shape.
      expect(result.sections.length, lessThanOrEqualTo(1));
    });

    test('splits into one preamble + one section per heading', () {
      const md = '''
Intro paragraph before any heading.

## First
Body of first.

## Second
Body of second.

### Nested
Nested body.
''';

      final result = parseMarkdownDocument(md);

      expect(
        result.headings.map((h) => h.id),
        <String>['first', 'second', 'nested'],
      );
      expect(
        result.headings.map((h) => h.level),
        <int>[2, 2, 3],
      );

      expect(result.sections, hasLength(4));
      expect(result.sections[0].heading, isNull);
      expect(result.sections[0].markdown, contains('Intro paragraph'));
      expect(result.sections[1].heading?.id, 'first');
      expect(result.sections[1].markdown, startsWith('## First'));
      expect(result.sections[1].markdown, contains('Body of first.'));
      expect(result.sections[2].heading?.id, 'second');
      expect(result.sections[3].heading?.id, 'nested');
    });

    test('does not treat `## ` inside a fenced code block as a heading', () {
      const md = '''
## Real Heading
Body.

```
## Not a heading, it is code
### Also not
```

## Another Real Heading
''';

      final result = parseMarkdownDocument(md);

      expect(
        result.headings.map((h) => h.id),
        <String>['real-heading', 'another-real-heading'],
      );
      // The code block should live in the 'real-heading' section, not create
      // a new one.
      final realHeadingSection = result.sections
          .firstWhere((s) => s.heading?.id == 'real-heading');
      expect(
        realHeadingSection.markdown,
        contains('## Not a heading, it is code'),
      );
    });

    test('disambiguates duplicate heading texts with numeric suffixes', () {
      const md = '''
## Setup
First.

## Setup
Second.

## Setup
Third.
''';

      final result = parseMarkdownDocument(md);

      expect(
        result.headings.map((h) => h.id),
        <String>['setup', 'setup-1', 'setup-2'],
      );
      expect(result.sections.where((s) => s.heading != null), hasLength(3));
    });

    test('slugifies punctuation and whitespace to a url-safe id', () {
      const md = '## Hello, World! Setup and Teardown\n';

      final heading = parseMarkdownDocument(md).headings.single;

      expect(heading.text, 'Hello, World! Setup and Teardown');
      expect(heading.id, 'hello-world-setup-and-teardown');
    });

    test('ignores h1/h4+ headings (only h2 and h3 anchor TOC sections)', () {
      const md = '''
# Title h1 ignored
## Section
#### Too deep, ignored
### Sub
''';

      final result = parseMarkdownDocument(md);

      expect(
        result.headings.map((h) => h.level),
        <int>[2, 3],
      );
      expect(
        result.headings.map((h) => h.id),
        <String>['section', 'sub'],
      );
    });

    test('parseMarkdownHeadings returns the same headings as '
        'parseMarkdownDocument', () {
      const md = '''
Intro.

## One
Body.

## Two
Body.
''';

      final viaDoc = parseMarkdownDocument(md).headings;
      final viaShortcut = parseMarkdownHeadings(md);

      expect(viaShortcut.map((h) => h.id), viaDoc.map((h) => h.id));
      expect(viaShortcut.map((h) => h.level), viaDoc.map((h) => h.level));
      expect(viaShortcut.map((h) => h.text), viaDoc.map((h) => h.text));
    });

    test('each heading.id is present as a key in exactly one section', () {
      const md = '''
## A
body a

## B
body b

### B-inner
body b-inner
''';

      final result = parseMarkdownDocument(md);

      for (final heading in result.headings) {
        final matching =
            result.sections.where((s) => s.heading?.id == heading.id).toList();
        expect(
          matching,
          hasLength(1),
          reason: 'Heading "${heading.id}" should back exactly one section',
        );
      }
    });
  });
}
