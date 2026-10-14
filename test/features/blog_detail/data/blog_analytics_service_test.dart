import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:my_portfolio/features/blog_detail/data/services/blog_analytics_service.dart';

void main() {
  test('logging before Firebase is up is a quiet no-op', () async {
    var resolved = false;
    final analytics = BlogAnalyticsService(
      analytics: () {
        resolved = true;
        throw FirebaseException(plugin: 'core', code: 'no-app');
      },
    );
    expect(resolved, isFalse);

    await analytics.logBlogPostViewed('hello-world');

    expect(resolved, isTrue);
  });
}
