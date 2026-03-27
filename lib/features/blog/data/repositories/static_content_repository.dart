import 'package:my_portfolio/features/blog/domain/models/blog_post_summary.dart';
import 'package:my_portfolio/features/blog/domain/repositories/blog_repository.dart';

class StaticBlogRepositoryImpl implements BlogRepository {
  @override
  Future<List<BlogPostSummary>> getBlogPosts() async {
    await Future<void>.delayed(const Duration(milliseconds: 100));

    return const <BlogPostSummary>[
      BlogPostSummary(
        slug: 'building-better-flutter-web-apps',
        title: 'Building Better Flutter Web Apps',
        summary:
            'A practical note on moving from a portfolio landing page '
            'to an app-ready Flutter web architecture.',
        publishedAt: 'March 21, 2026',
        readTime: '5 min read',
        tags: ['Flutter', 'Web', 'Architecture'],
      ),
      BlogPostSummary(
        slug: 'mvvm-with-provider-and-commands',
        title: 'MVVM with Provider and Commands',
        summary:
            'How a lightweight ViewModel + Command approach keeps Flutter '
            'widgets focused on rendering.',
        publishedAt: 'March 18, 2026',
        readTime: '4 min read',
        tags: ['MVVM', 'Provider', 'State'],
      ),
      BlogPostSummary(
        slug: 'mocking-content-before-your-cms-exists',
        title: 'Mocking Content Before Your CMS Exists',
        summary:
            'A useful pattern for product teams who want to build pages '
            'and UX before the backend is ready.',
        publishedAt: 'March 12, 2026',
        readTime: '3 min read',
        tags: ['Content', 'Product', 'Frontend'],
      ),
    ];
  }
}
