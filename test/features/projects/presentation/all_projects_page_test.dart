import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:my_portfolio/app/di/service_locator.dart';
import 'package:my_portfolio/features/projects/data/static_project_summaries.dart';
import 'package:my_portfolio/features/projects/presentation/controllers/work_controller.dart';
import 'package:my_portfolio/features/projects/presentation/views/all_projects_page.dart';

import '../../../helpers/site_test_harness.dart';

void main() {
  late FakeLaunchService launch;
  setUp(() async => launch = await registerSiteFakes());

  Widget page() => AllProjectsPage(controller: getIt<WorkController>());

  Finder tile(String title) => find.bySemanticsLabel('Open $title');

  for (final size in const [Size(375, 812), Size(1440, 900)]) {
    testWidgets('lists every project at $size', (tester) async {
      setViewSize(tester, size);
      await pumpRouted(tester, page());

      for (final project in [...featuredProjects, ...otherProjects]) {
        expect(tile(project.title), findsOneWidget);
        expect(find.text(project.about), findsOneWidget);
      }
    });
  }

  testWidgets('a team project opens its store', (tester) async {
    setViewSize(tester, const Size(1440, 900));
    await pumpRouted(tester, page());

    final project = otherProjects.first;
    await tester.ensureVisible(tile(project.title));
    await tester.pumpAndSettle();
    await tester.tap(tile(project.title));
    expect(launch.opened, [project.links.first]);
  });

  testWidgets('a featured project opens its project view', (tester) async {
    setViewSize(tester, const Size(1440, 900));
    await pumpRouted(tester, page());

    final project = featuredProjects.first;
    await tester.tap(tile(project.title));
    await tester.pumpAndSettle();
    expect(find.text(project.problem), findsOneWidget);
    expect(launch.opened, isEmpty);
  });
}
