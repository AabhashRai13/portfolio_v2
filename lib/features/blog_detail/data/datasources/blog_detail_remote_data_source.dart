import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:my_portfolio/core/resources/typedef.dart';

class BlogDetailRemoteDataSource {
  BlogDetailRemoteDataSource({
    required FirebaseFirestore firestore,
  }) : _firestore = firestore;

  final FirebaseFirestore _firestore;

  CollectionReference<Map<String, dynamic>> get _posts =>
      _firestore.collection('posts');

  CollectionReference<Map<String, dynamic>> comments(String postId) =>
      _posts.doc(postId).collection('comments');

  CollectionReference<Map<String, dynamic>> likes(String postId) =>
      _posts.doc(postId).collection('likes');

  CollectionReference<Map<String, dynamic>> views(String postId) =>
      _posts.doc(postId).collection('views');

  Future<DocumentSnapshot<Map<String, dynamic>>> fetchPostById(String id) {
    return _posts.doc(id).get();
  }

  Future<QuerySnapshot<Map<String, dynamic>>> fetchPostBySlug(String slug) {
    return _posts.where('slug', isEqualTo: slug).limit(1).get();
  }

  Future<int> fetchLikeCount(String postId) async {
    final snapshot = await likes(postId).count().get();
    return snapshot.count ?? 0;
  }

  Future<int> fetchCommentCount(String postId) async {
    final snapshot = await comments(postId).count().get();
    return snapshot.count ?? 0;
  }

  Future<int> fetchViewCount(String postId) async {
    final snapshot = await views(postId).count().get();
    return snapshot.count ?? 0;
  }

  Future<QuerySnapshot<Map<String, dynamic>>> fetchComments(String postId) {
    return comments(postId).orderBy('createdAt', descending: true).get();
  }

  Future<void> createView(String postId, String sessionId) {
    return views(postId).doc(sessionId).set(<String, dynamic>{
      'sessionId': sessionId,
      'createdAt': FieldValue.serverTimestamp(),
    });
  }

  Future<void> createLike(String postId, String browserId) {
    return likes(postId).doc(browserId).set(<String, dynamic>{
      'clientId': browserId,
      'createdAt': FieldValue.serverTimestamp(),
    });
  }

  Future<void> createComment({
    required String postId,
    required String authorName,
    required String message,
  }) {
    return comments(postId).add(<String, dynamic>{
      'authorName': authorName.trim(),
      'message': message.trim(),
      'createdAt': FieldValue.serverTimestamp(),
    });
  }

  Future<DataMap?> fetchPostData(String postId) async {
    final snapshot = await _posts.doc(postId).get();
    return snapshot.data();
  }
}
