import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:my_portfolio/features/blog_list/domain/entities/blog_post_summary_entity.dart';

class BlogPostSummaryDocument {
  const BlogPostSummaryDocument({
    required this.id,
    required this.slug,
    required this.title,
    required this.summary,
    required this.publishedAt,
    required this.readTimeMinutes,
    required this.tags,
    this.coverImageUrl,
  });

  factory BlogPostSummaryDocument.fromFirestore(
    QueryDocumentSnapshot<Map<String, dynamic>> snapshot,
  ) {
    final data = snapshot.data();
    final slug = (data['slug'] as String?)?.trim();
    final contentMarkdown = (data['contentMarkdown'] as String?)?.trim() ?? '';
    final summary = (data['summary'] as String?)?.trim() ?? '';

    return BlogPostSummaryDocument(
      id: snapshot.id,
      slug: slug?.isNotEmpty ?? false ? slug! : snapshot.id,
      title: (data['title'] as String?)?.trim() ?? 'Untitled Post',
      summary: summary,
      publishedAt: _parseDate(data['publishedAt']),
      readTimeMinutes: _estimateReadTime(
        contentMarkdown.isEmpty ? summary : contentMarkdown,
      ),
      tags: _parseTags(data['tags']),
      coverImageUrl: (data['coverImageUrl'] as String?)?.trim(),
    );
  }

  final String id;
  final String slug;
  final String title;
  final String summary;
  final DateTime publishedAt;
  final int readTimeMinutes;
  final List<String> tags;
  final String? coverImageUrl;

  BlogPostSummaryEntity toEntity() {
    return BlogPostSummaryEntity(
      id: id,
      slug: slug,
      title: title,
      summary: summary,
      publishedAt: publishedAt,
      readTimeMinutes: readTimeMinutes,
      tags: tags,
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
