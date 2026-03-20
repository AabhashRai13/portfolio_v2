import 'package:go_router/go_router.dart';
import 'package:my_portfolio/app/router/app_routes.dart';
import 'package:my_portfolio/core/services/app_launch_service.dart';
import 'package:my_portfolio/features/contact/domain/usecases/submit_contact_message_use_case.dart';
import 'package:my_portfolio/features/contact/presentation/view_models/contact_view_model.dart';
import 'package:my_portfolio/features/content/domain/repositories/content_repository.dart';
import 'package:my_portfolio/features/content/presentation/views/content_placeholder_page.dart';
import 'package:my_portfolio/features/home/presentation/view_models/home_view_model.dart';
import 'package:my_portfolio/features/home/presentation/views/home_main_page.dart';
import 'package:provider/provider.dart';

class AppRouter {
  static final GoRouter router = GoRouter(
    routes: [
      GoRoute(
        path: AppRoutes.home,
        builder: (context, state) => MultiProvider(
          providers: [
            ChangeNotifierProvider<HomeViewModel>(
              create: (context) => HomeViewModel(
                launchService: context.read<AppLaunchService>(),
                contentRepository: context.read<ContentRepository>(),
              ),
            ),
            ChangeNotifierProvider<ContactViewModel>(
              create: (context) => ContactViewModel(
                submitContactMessage:
                    context.read<SubmitContactMessageUseCase>(),
                launchService: context.read<AppLaunchService>(),
              ),
            ),
          ],
          child: const HomeMainPage(),
        ),
      ),
      GoRoute(
        path: AppRoutes.content,
        builder: (context, state) => const ContentPlaceholderPage(),
      ),
    ],
  );
}
