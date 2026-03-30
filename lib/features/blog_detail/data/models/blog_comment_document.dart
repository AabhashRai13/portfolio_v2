import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:my_portfolio/features/blog_detail/domain/entities/blog_comment_entity.dart';

class BlogCommentDocument {
  const BlogCommentDocument({
    required this.id,
    required this.authorName,
    required this.message,
    required this.createdAt,
  });

  factory BlogCommentDocument.fromFirestore(
    QueryDocumentSnapshot<Map<String, dynamic>> snapshot,
  ) {
    final data = snapshot.data();
    final createdAt = data['createdAt'];

    return BlogCommentDocument(
      id: snapshot.id,
      authorName: (data['authorName'] as String?)?.trim() ?? 'Anonymous',
      message: (data['message'] as String?)?.trim() ?? '',
      createdAt: createdAt is Timestamp
          ? createdAt.toDate()
          : createdAt is DateTime
          ? createdAt
          : DateTime.now(),
    );
  }

  final String id;
  final String authorName;
  final String message;
  final DateTime createdAt;

  BlogCommentEntity toEntity() {
    return BlogCommentEntity(
      id: id,
      authorName: authorName,
      message: message,
      createdAt: createdAt,
    );
  }
}
