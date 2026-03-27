import 'package:get_it/get_it.dart';
import 'package:my_portfolio/core/services/app_launch_service.dart';
import 'package:my_portfolio/features/blog/data/repositories/static_content_repository.dart';
import 'package:my_portfolio/features/blog/domain/repositories/blog_repository.dart';
import 'package:my_portfolio/features/blog/presentation/controllers/blog_list_controller.dart';
import 'package:my_portfolio/features/contact/data/repositories/email_js_contact_repository.dart';
import 'package:my_portfolio/features/contact/domain/repositories/contact_repository.dart';
import 'package:my_portfolio/features/contact/domain/usecases/submit_contact_message_use_case.dart';
import 'package:my_portfolio/features/contact/presentation/controllers/contact_controller.dart';
import 'package:my_portfolio/features/home/presentation/controllers/home_controller.dart';
import 'package:my_portfolio/features/projects/data/repositories/static_projects_repository.dart';
import 'package:my_portfolio/features/projects/domain/repositories/projects_repository.dart';

final GetIt getIt = GetIt.instance;

void setupDependencies() {
  if (getIt.isRegistered<AppLaunchService>()) {
    return;
  }

  getIt
    ..registerLazySingleton<AppLaunchService>(
      () => const UrlLauncherAppLaunchService(),
    )
    ..registerLazySingleton<ContactRepository>(
      EmailJsContactRepository.new,
    )
    ..registerLazySingleton<BlogRepository>(
      StaticBlogRepositoryImpl.new,
    )
    ..registerLazySingleton<ProjectsRepository>(
      StaticProjectsRepository.new,
    )
    ..registerLazySingleton<SubmitContactMessageUseCase>(
      () => SubmitContactMessageUseCase(
        getIt.get<ContactRepository>(),
      ),
    )
    ..registerFactory(
      () => ContactController(
        submitContactMessage: getIt.get<SubmitContactMessageUseCase>(),
        launchService: getIt.get<AppLaunchService>(),
      ),
    )
    ..registerFactory(
      () => HomeController(
        launchService: getIt.get<AppLaunchService>(),
        projectsRepository: getIt.get<ProjectsRepository>(),
      ),
    )
    ..registerFactory(
      () => BlogListController(
        blogRepository: getIt.get<BlogRepository>(),
      ),
    );
}
