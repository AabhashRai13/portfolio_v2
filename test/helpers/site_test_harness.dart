import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:my_portfolio/app/di/service_locator.dart';
import 'package:my_portfolio/core/controllers/app_theme_controller.dart';
import 'package:my_portfolio/core/resources/styles/theme.dart';
import 'package:my_portfolio/core/services/app_launch_service.dart';
import 'package:my_portfolio/core/services/theme_preference_store.dart';
import 'package:my_portfolio/features/contact/domain/models/contact_message.dart';
import 'package:my_portfolio/features/contact/domain/repositories/contact_repository.dart';
import 'package:my_portfolio/features/contact/presentation/controllers/contact_controller.dart';
import 'package:my_portfolio/features/projects/data/repositories/static_projects_repository.dart';
import 'package:my_portfolio/features/projects/domain/repositories/projects_repository.dart';

class FakeLaunchService implements AppLaunchService {
  final List<String> opened = <String>[];

  @override
  Future<void> openExternalUrl(String url) async => opened.add(url);
}

/// Keeps theme mode in memory instead of browser localStorage.
class MemoryThemeStore extends ThemePreferenceStore {
  ThemeMode _mode = ThemeMode.light;

  @override
  ThemeMode read() => _mode;

  @override
  void write(ThemeMode mode) => _mode = mode;
}

class _NoopContactRepository implements ContactRepository {
  @override
  Future<void> submitContactMessage(ContactMessage message) async {}
}

/// Registers the minimum getIt dependencies site widgets resolve.
Future<FakeLaunchService> registerSiteFakes() async {
  await getIt.reset();
  final launch = FakeLaunchService();
  getIt
    ..registerSingleton<AppLaunchService>(launch)
    ..registerSingleton<AppThemeController>(
      AppThemeController(store: MemoryThemeStore()),
    )
    ..registerSingleton<ProjectsRepository>(StaticProjectsRepository())
    ..registerFactory<ContactController>(
      () => ContactController(
        contactRepository: _NoopContactRepository(),
        launchService: launch,
      ),
    );
  return launch;
}

void setViewSize(WidgetTester tester, Size size) {
  tester.view.physicalSize = size;
  tester.view.devicePixelRatio = 1;
  addTearDown(tester.view.reset);
}

/// Pumps [home] at `/` with stub pages for every other site route.
Future<void> pumpRouted(WidgetTester tester, Widget home) async {
  final router = GoRouter(
    routes: <RouteBase>[
      GoRoute(path: '/', builder: (_, _) => home),
      for (final path in const ['/work', '/about', '/blog', '/contact'])
        GoRoute(
          path: path,
          builder: (_, _) => Scaffold(body: Text('page $path')),
        ),
    ],
  );
  addTearDown(router.dispose);
  await tester.pumpWidget(
    MaterialApp.router(theme: kLightTheme, routerConfig: router),
  );
  await tester.pumpAndSettle();
}
