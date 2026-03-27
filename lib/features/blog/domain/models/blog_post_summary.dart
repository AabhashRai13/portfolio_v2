class BlogPostSummary {
  const BlogPostSummary({
    required this.slug,
    required this.title,
    required this.summary,
    required this.publishedAt,
    required this.readTime,
    required this.tags,
  });

  final String slug;
  final String title;
  final String summary;
  final String publishedAt;
  final String readTime;
  final List<String> tags;
}
