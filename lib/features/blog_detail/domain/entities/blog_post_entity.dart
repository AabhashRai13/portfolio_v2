import 'package:my_portfolio/features/blog_detail/domain/entities/toc_heading.dart';

class BlogPostEntity {
  const BlogPostEntity({
    required this.id,
    required this.slug,
    required this.title,
    required this.summary,
    required this.contentMarkdown,
    required this.publishedAt,
    required this.updatedAt,
    required this.readTimeMinutes,
    required this.tags,
    required this.likeCount,
    required this.commentCount,
    required this.viewCount,
    required this.isLikedByCurrentBrowser,
    this.coverImageUrl,
    this.headings = const <TocHeading>[],
  });

  final String id;
  final String slug;
  final String title;
  final String summary;
  final String contentMarkdown;
  final DateTime publishedAt;
  final DateTime updatedAt;
  final int readTimeMinutes;
  final List<String> tags;
  final int likeCount;
  final int commentCount;
  final int viewCount;
  final bool isLikedByCurrentBrowser;
  final String? coverImageUrl;
  final List<TocHeading> headings;

  BlogPostEntity copyWith({
    String? id,
    String? slug,
    String? title,
    String? summary,
    String? contentMarkdown,
    DateTime? publishedAt,
    DateTime? updatedAt,
    int? readTimeMinutes,
    List<String>? tags,
    int? likeCount,
    int? commentCount,
    int? viewCount,
    bool? isLikedByCurrentBrowser,
    String? coverImageUrl,
    List<TocHeading>? headings,
  }) {
    return BlogPostEntity(
      id: id ?? this.id,
      slug: slug ?? this.slug,
      title: title ?? this.title,
      summary: summary ?? this.summary,
      contentMarkdown: contentMarkdown ?? this.contentMarkdown,
      publishedAt: publishedAt ?? this.publishedAt,
      updatedAt: updatedAt ?? this.updatedAt,
      readTimeMinutes: readTimeMinutes ?? this.readTimeMinutes,
      tags: tags ?? this.tags,
      likeCount: likeCount ?? this.likeCount,
      commentCount: commentCount ?? this.commentCount,
      viewCount: viewCount ?? this.viewCount,
      isLikedByCurrentBrowser:
          isLikedByCurrentBrowser ?? this.isLikedByCurrentBrowser,
      coverImageUrl: coverImageUrl ?? this.coverImageUrl,
      headings: headings ?? this.headings,
    );
  }
}
