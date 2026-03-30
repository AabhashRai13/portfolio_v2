import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:get_it/get_it.dart';
import 'package:my_portfolio/core/services/app_launch_service.dart';
import 'package:my_portfolio/core/services/firestore_request_handler.dart';
import 'package:my_portfolio/features/blog_detail/data/datasources/blog_detail_remote_data_source.dart';
import 'package:my_portfolio/features/blog_detail/data/repositories/firestore_blog_detail_repository.dart';
import 'package:my_portfolio/features/blog_detail/data/services/blog_analytics_service.dart';
import 'package:my_portfolio/features/blog_detail/data/services/blog_engagement_local_store.dart';
import 'package:my_portfolio/features/blog_detail/domain/repositories/blog_detail_repository.dart';
import 'package:my_portfolio/features/blog_detail/presentation/controllers/blog_post_detail_controller.dart';
import 'package:my_portfolio/features/blog_list/data/datasources/blog_list_remote_data_source.dart';
import 'package:my_portfolio/features/blog_list/data/repositories/firestore_blog_list_repository.dart';
import 'package:my_portfolio/features/blog_list/domain/repositories/blog_list_repository.dart';
import 'package:my_portfolio/features/blog_list/presentation/controllers/blog_list_controller.dart';
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
    ..registerLazySingleton<FirebaseFirestore>(
      () => FirebaseFirestore.instance,
    )
    ..registerLazySingleton<FirebaseAnalytics>(
      () => FirebaseAnalytics.instance,
    )
    ..registerLazySingleton<FirestoreRequestHandler>(
      FirestoreRequestHandler.new,
    )
    ..registerLazySingleton<AppLaunchService>(
      () => const UrlLauncherAppLaunchService(),
    )
    ..registerLazySingleton<BlogListRemoteDataSource>(
      () => BlogListRemoteDataSource(
        firestore: getIt.get<FirebaseFirestore>(),
      ),
    )
    ..registerLazySingleton<BlogDetailRemoteDataSource>(
      () => BlogDetailRemoteDataSource(
        firestore: getIt.get<FirebaseFirestore>(),
      ),
    )
    ..registerLazySingleton<BlogEngagementLocalStore>(
      BlogEngagementLocalStore.new,
    )
    ..registerLazySingleton<BlogAnalyticsService>(
      () => BlogAnalyticsService(
        analytics: getIt.get<FirebaseAnalytics>(),
      ),
    )
    ..registerLazySingleton<ContactRepository>(
      EmailJsContactRepository.new,
    )
    ..registerLazySingleton<BlogListRepository>(
      () => FirestoreBlogListRepositoryImpl(
        remoteDataSource: getIt.get<BlogListRemoteDataSource>(),
        requestHandler: getIt.get<FirestoreRequestHandler>(),
      ),
    )
    ..registerLazySingleton<BlogDetailRepository>(
      () => FirestoreBlogDetailRepositoryImpl(
        remoteDataSource: getIt.get<BlogDetailRemoteDataSource>(),
        requestHandler: getIt.get<FirestoreRequestHandler>(),
        analyticsService: getIt.get<BlogAnalyticsService>(),
        engagementLocalStore: getIt.get<BlogEngagementLocalStore>(),
      ),
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
        blogListRepository: getIt.get<BlogListRepository>(),
      ),
    )
    ..registerFactory(
      () => BlogPostDetailController(
        blogDetailRepository: getIt.get<BlogDetailRepository>(),
        launchService: getIt.get<AppLaunchService>(),
      ),
    );
}
