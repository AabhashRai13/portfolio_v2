import 'package:firebase_analytics/firebase_analytics.dart';

class BlogAnalyticsService {
  const BlogAnalyticsService({
    required FirebaseAnalytics analytics,
  }) : _analytics = analytics;

  final FirebaseAnalytics _analytics;

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
      await _analytics.logEvent(
        name: name,
        parameters: parameters,
      );
    } on Exception {
      // Analytics should never block the content path.
    }
  }
}
