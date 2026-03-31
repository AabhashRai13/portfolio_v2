import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:my_portfolio/features/blog_detail/domain/entities/blog_post_entity.dart';

class BlogPostDocument {
  const BlogPostDocument({
    required this.id,
    required this.slug,
    required this.title,
    required this.summary,
    required this.contentMarkdown,
    required this.publishedAt,
    required this.updatedAt,
    required this.tags,
    this.coverImageUrl,
  });

  factory BlogPostDocument.fromDocumentSnapshot(
    DocumentSnapshot<Map<String, dynamic>> snapshot,
  ) {
    final data = snapshot.data() ?? <String, dynamic>{};
    final slug = (data['slug'] as String?)?.trim();

    return BlogPostDocument(
      id: snapshot.id,
      slug: slug?.isNotEmpty ?? false ? slug! : snapshot.id,
      title: (data['title'] as String?)?.trim() ?? 'Untitled Post',
      summary: (data['summary'] as String?)?.trim() ?? '',
      contentMarkdown: (data['contentMarkdown'] as String?)?.trim() ?? '',
      publishedAt: _parseDate(data['publishedAt']),
      updatedAt: _parseDate(
        data['updatedAt'] ?? data['publishedAt'],
      ),
      tags: _parseTags(data['tags']),
      coverImageUrl: (data['coverImageUrl'] as String?)?.trim(),
    );
  }

  factory BlogPostDocument.fromFirestore(
    QueryDocumentSnapshot<Map<String, dynamic>> snapshot,
  ) {
    final data = snapshot.data();
    final slug = (data['slug'] as String?)?.trim();

    return BlogPostDocument(
      id: snapshot.id,
      slug: slug?.isNotEmpty ?? false ? slug! : snapshot.id,
      title: (data['title'] as String?)?.trim() ?? 'Untitled Post',
      summary: (data['summary'] as String?)?.trim() ?? '',
      contentMarkdown: (data['contentMarkdown'] as String?)?.trim() ?? '',
      publishedAt: _parseDate(data['publishedAt']),
      updatedAt: _parseDate(
        data['updatedAt'] ?? data['publishedAt'],
      ),
      tags: _parseTags(data['tags']),
      coverImageUrl: (data['coverImageUrl'] as String?)?.trim(),
    );
  }

  final String id;
  final String slug;
  final String title;
  final String summary;
  final String contentMarkdown;
  final DateTime publishedAt;
  final DateTime updatedAt;
  final List<String> tags;
  final String? coverImageUrl;

  BlogPostEntity toEntity({
    required int likeCount,
    required int commentCount,
    required int viewCount,
    required bool isLikedByCurrentBrowser,
  }) {
    return BlogPostEntity(
      id: id,
      slug: slug,
      title: title,
      summary: summary,
      contentMarkdown: contentMarkdown,
      publishedAt: publishedAt,
      updatedAt: updatedAt,
      readTimeMinutes: _estimateReadTime(
        contentMarkdown.isEmpty ? summary : contentMarkdown,
      ),
      tags: tags,
      likeCount: likeCount,
      commentCount: commentCount,
      viewCount: viewCount,
      isLikedByCurrentBrowser: isLikedByCurrentBrowser,
      coverImageUrl: coverImageUrl,
    );
  }

  static DateTime _parseDate(Object? rawValue) {
    if (rawValue is Timestamp) {
      return rawValue.toDate();
    }

    if (rawValue is DateTime) {
      return rawValue;
    }

    if (rawValue is String) {
      return DateTime.tryParse(rawValue) ?? DateTime.now();
    }

    return DateTime.now();
  }

  static List<String> _parseTags(Object? rawValue) {
    if (rawValue is Iterable) {
      return rawValue.whereType<String>().toList(growable: false);
    }

    return const <String>[];
  }

  static int _estimateReadTime(String markdown) {
    final normalizedText = markdown
        .replaceAll(RegExp(r'[#*_`>\-\[\]\(\)]'), ' ')
        .replaceAll(RegExp(r'\s+'), ' ')
        .trim();

    if (normalizedText.isEmpty) {
      return 1;
    }

    final wordCount = normalizedText.split(' ').length;
    final minutes = (wordCount / 200).ceil();
    return minutes < 1 ? 1 : minutes;
  }
}
