class BlogPostSummaryEntity {
  const BlogPostSummaryEntity({
    required this.id,
    required this.slug,
    required this.title,
    required this.summary,
    required this.publishedAt,
    required this.readTimeMinutes,
    required this.tags,
    this.coverImageUrl,
  });

  final String id;
  final String slug;
  final String title;
  final String summary;
  final DateTime publishedAt;
  final int readTimeMinutes;
  final List<String> tags;
  final String? coverImageUrl;
}
