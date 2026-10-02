import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:my_portfolio/app/di/service_locator.dart';
import 'package:my_portfolio/app/navigation/site_page.dart';
import 'package:my_portfolio/features/projects/data/static_project_summaries.dart';
import 'package:my_portfolio/features/projects/presentation/controllers/work_controller.dart';
import 'package:my_portfolio/features/projects/presentation/views/all_projects_page.dart';

import '../../../helpers/site_test_harness.dart';

void main() {
  late FakeLaunchService launch;
  setUp(() async => launch = await registerSiteFakes());

  Widget page() => AllProjectsPage(controller: getIt<WorkController>());

  for (final size in const [Size(375, 812), Size(1440, 900)]) {
    testWidgets('lists every project at $size', (tester) async {
      setViewSize(tester, size);
      await pumpRouted(tester, page());

      expect(find.byKey(SitePage.titleKey), findsNothing);
      for (final project in staticProjectSummaries) {
        expect(find.text(project.title), findsOneWidget);
      }
    });
  }

  testWidgets('tapping a project opens its store link', (tester) async {
    setViewSize(tester, const Size(1440, 900));
    await pumpRouted(tester, page());

    final title = find.text(staticProjectSummaries.first.title);
    await tester.ensureVisible(title);
    await tester.pumpAndSettle();
    await tester.tap(title);
    expect(launch.opened, [staticProjectSummaries.first.link]);
  });
}
