class BlogCommentEntity {
  const BlogCommentEntity({
    required this.id,
    required this.authorName,
    required this.message,
    required this.createdAt,
  });

  final String id;
  final String authorName;
  final String message;
  final DateTime createdAt;
}
