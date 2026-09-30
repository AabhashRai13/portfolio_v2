import 'package:go_router/go_router.dart';
import 'package:my_portfolio/app/di/service_locator.dart';
import 'package:my_portfolio/app/router/app_routes.dart';
import 'package:my_portfolio/core/presentation/widgets/app_theme_scope.dart';
import 'package:my_portfolio/features/about/presentation/views/about_page.dart';
import 'package:my_portfolio/features/blog_detail/presentation/controllers/blog_post_detail_controller.dart';
import 'package:my_portfolio/features/blog_detail/presentation/views/blog_post_detail_page.dart';
import 'package:my_portfolio/features/blog_list/presentation/controllers/blog_list_controller.dart';
import 'package:my_portfolio/features/blog_list/presentation/views/blog_list_page.dart';
import 'package:my_portfolio/features/landing/presentation/views/landing_page.dart';
import 'package:my_portfolio/features/newsletter/presentation/controllers/newsletter_controller.dart';
import 'package:my_portfolio/features/newsletter/presentation/views/newsletter_page.dart';
import 'package:my_portfolio/features/projects/presentation/controllers/work_controller.dart';
import 'package:my_portfolio/features/projects/presentation/views/work_page.dart';

class AppRouter {
  static final GoRouter router = createRouter();

  static GoRouter createRouter({String initialLocation = AppRoutes.home}) {
    return GoRouter(
      initialLocation: initialLocation,
      routes: [
        GoRoute(
          path: AppRoutes.home,
          builder: (context, state) =>
              const AppThemeScope(child: LandingPage()),
        ),
        GoRoute(
          path: AppRoutes.work,
          builder: (context, state) => AppThemeScope(
            child: WorkPage(controller: getIt.get<WorkController>()),
          ),
        ),
        GoRoute(
          path: AppRoutes.about,
          builder: (context, state) => const AppThemeScope(child: AboutPage()),
        ),
        GoRoute(
          path: AppRoutes.contact,
          builder: (context, state) => const AppThemeScope(
            child: LandingPage(openContactOnStart: true),
          ),
        ),
        GoRoute(
          path: AppRoutes.blog,
          builder: (context, state) => AppThemeScope(
            child: BlogListPage(
              blogListController: getIt.get<BlogListController>(),
            ),
          ),
          routes: [
            GoRoute(
              path: AppRoutes.blogDetailSegment,
              builder: (context, state) => AppThemeScope(
                child: BlogPostDetailPage(
                  slug: state.pathParameters['slug']!,
                  blogPostDetailController: getIt
                      .get<BlogPostDetailController>(),
                  newsletterController: getIt.get<NewsletterController>(),
                ),
              ),
            ),
          ],
        ),
        GoRoute(
          path: AppRoutes.newsletter,
          builder: (context, state) => AppThemeScope(
            child: NewsletterPage(
              newsletterController: getIt.get<NewsletterController>(),
            ),
          ),
        ),
        GoRoute(
          path: AppRoutes.content,
          redirect: (context, state) => AppRoutes.home,
        ),
      ],
    );
  }
}
