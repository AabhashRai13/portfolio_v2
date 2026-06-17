import 'package:my_portfolio/features/blog_detail/domain/entities/toc_heading.dart';

/// A contiguous chunk of the article scoped to one heading.
///
/// The first section may have `heading == null` (the preamble before the
/// first `##`). Every subsequent section starts at a heading and contains
/// everything up to the next heading.
class BlogPostSection {
  const BlogPostSection({
    required this.markdown,
    this.heading,
  });

  final TocHeading? heading;
  final String markdown;
}
