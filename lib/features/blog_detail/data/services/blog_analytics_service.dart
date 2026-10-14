import 'package:firebase_analytics/firebase_analytics.dart';

class BlogAnalyticsService {
  const BlogAnalyticsService({
    required FirebaseAnalytics Function() analytics,
  }) : _analytics = analytics;

  // Resolved per call: Firebase may not be up when this is created.
  final FirebaseAnalytics Function() _analytics;

  Future<void> logBlogPostViewed(String slug) async {
    await _safeLog(
      'blog_post_viewed',
      <String, Object>{'slug': slug},
    );
  }

  Future<void> logBlogPostLiked(String slug) async {
    await _safeLog(
      'blog_post_liked',
      <String, Object>{'slug': slug},
    );
  }

  Future<void> logBlogCommentSubmitted(String slug) async {
    await _safeLog(
      'blog_comment_submitted',
      <String, Object>{'slug': slug},
    );
  }

  Future<void> _safeLog(String name, Map<String, Object> parameters) async {
    try {
      await _analytics().logEvent(
        name: name,
        parameters: parameters,
      );
    } on Exception {
      // Analytics should never block the content path.
    }
  }
}
