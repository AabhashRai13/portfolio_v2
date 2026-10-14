import 'package:cloud_firestore/cloud_firestore.dart';

class BlogListRemoteDataSource {
  BlogListRemoteDataSource({
    required FirebaseFirestore Function() firestore,
  }) : _firestore = firestore;

  // Resolved per call: Firebase may not be up when this is created.
  final FirebaseFirestore Function() _firestore;

  CollectionReference<Map<String, dynamic>> get _posts =>
      _firestore().collection('posts');

  Future<QuerySnapshot<Map<String, dynamic>>> fetchPublishedPosts() {
    return _posts
        .where('isPublished', isEqualTo: true)
        .orderBy('publishedAt', descending: true)
        .get();
  }
}
