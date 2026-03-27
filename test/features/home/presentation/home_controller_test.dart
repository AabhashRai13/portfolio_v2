import 'package:flutter_test/flutter_test.dart';
import 'package:my_portfolio/app/router/app_routes.dart';
import 'package:my_portfolio/core/services/app_launch_service.dart';
import 'package:my_portfolio/features/home/presentation/controllers/home_controller.dart';
import 'package:my_portfolio/features/home/presentation/models/home_navigation_item.dart';
import 'package:my_portfolio/features/home/presentation/models/home_navigation_target.dart';
import 'package:my_portfolio/features/home/presentation/models/home_section.dart';
import 'package:my_portfolio/features/projects/domain/models/project_summary.dart';
import 'package:my_portfolio/features/projects/domain/repositories/projects_repository.dart';

void main() {
  group('HomeController', () {
    HomeController buildController() {
      return HomeController(
        launchService: _RecordingLaunchService(),
        projectsRepository: const _FakeProjectsRepository(),
      );
    }

    test('loads featured projects from projects repository', () {
      final controller = buildController();

      expect(controller.featuredProjects, hasLength(1));
      expect(controller.featuredProjects.first.title, 'Demo Project');
    });

    test('navigation selection scrolls to mapped section', () {
      final controller = buildController();

      final target = controller.handleNavigationSelection(
        HomeController.navigationItems[4],
      );

      expect(target.section, HomeSection.contact);
    });

    test('blog navigation returns the blog route target', () {
      final controller = buildController();

      final target = controller.handleNavigationSelection(
        HomeController.navigationItems[5],
      );

      expect(target, isA<HomeNavigationTarget>());
      expect(target.route, AppRoutes.blog);
    });

    test('navigation items remain typed and ordered', () {
      expect(HomeController.navigationItems, isA<List<HomeNavigationItem>>());
      expect(HomeController.navigationItems.last.title, 'Resume');
    });
  });
}

class _RecordingLaunchService implements AppLaunchService {
  final List<String> openedUrls = <String>[];

  @override
  Future<void> openExternalUrl(String url) async {
    openedUrls.add(url);
  }
}

class _FakeProjectsRepository implements ProjectsRepository {
  const _FakeProjectsRepository();

  @override
  List<ProjectSummary> getFeaturedProjects() {
    return const <ProjectSummary>[
      ProjectSummary(
        title: 'Demo Project',
        link: 'https://example.com',
      ),
    ];
  }
}
