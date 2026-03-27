import 'package:go_router/go_router.dart';
import 'package:my_portfolio/app/di/service_locator.dart';
import 'package:my_portfolio/app/router/app_routes.dart';
import 'package:my_portfolio/features/blog/presentation/controllers/blog_list_controller.dart';
import 'package:my_portfolio/features/blog/presentation/views/blog_list_page.dart';
import 'package:my_portfolio/features/contact/presentation/controllers/contact_controller.dart';
import 'package:my_portfolio/features/home/presentation/controllers/home_controller.dart';
import 'package:my_portfolio/features/home/presentation/views/home_main_page.dart';

class AppRouter {
  static final GoRouter router = GoRouter(
    routes: [
      GoRoute(
        path: AppRoutes.home,
        builder: (context, state) => HomeMainPage(
          homeController: getIt.get<HomeController>(),
          contactController: getIt.get<ContactController>(),
        ),
      ),
      GoRoute(
        path: AppRoutes.blog,
        builder: (context, state) =>  BlogListPage(
          blogListController:   getIt.get<BlogListController>()
        ),
      ),
      GoRoute(
        path: AppRoutes.content,
        redirect: (context, state) => AppRoutes.home,
      ),
    ],
  );
}
