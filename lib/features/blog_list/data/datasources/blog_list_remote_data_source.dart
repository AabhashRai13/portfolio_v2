import 'package:cloud_firestore/cloud_firestore.dart';

class BlogListRemoteDataSource {
  BlogListRemoteDataSource({
    required FirebaseFirestore firestore,
  }) : _firestore = firestore;

  final FirebaseFirestore _firestore;

  CollectionReference<Map<String, dynamic>> get _posts =>
      _firestore.collection('posts');

  Future<QuerySnapshot<Map<String, dynamic>>> fetchPublishedPosts() {
    return _posts
        .where('isPublished', isEqualTo: true)
        .orderBy('publishedAt', descending: true)
        .get();
  }
}
