import 'package:flutter_test/flutter_test.dart';
import 'package:my_portfolio/app/di/service_locator.dart';
import 'package:my_portfolio/features/blog_detail/presentation/controllers/blog_post_detail_controller.dart';
import 'package:my_portfolio/features/blog_list/presentation/controllers/blog_list_controller.dart';
import 'package:my_portfolio/features/newsletter/presentation/controllers/newsletter_controller.dart';

void main() {
  setUp(getIt.reset);
  tearDown(getIt.reset);

  test('Firebase-backed controllers build before Firebase is up', () {
    setupDependencies();

    expect(getIt.get<BlogListController>, returnsNormally);
    expect(getIt.get<BlogPostDetailController>, returnsNormally);
    expect(getIt.get<NewsletterController>, returnsNormally);
  });
}
