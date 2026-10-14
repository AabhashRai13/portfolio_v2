import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:my_portfolio/app/navigation/site_navigation.dart';
import 'package:my_portfolio/app/navigation/site_page.dart';
import 'package:my_portfolio/app/router/app_router.dart';
import 'package:my_portfolio/core/resources/styles/theme.dart';
import 'package:my_portfolio/features/landing/presentation/controllers/landing_grid_view_model.dart';
import 'package:my_portfolio/features/landing/presentation/widgets/landing_widget_grid.dart';
import 'package:my_portfolio/features/projects/presentation/views/all_projects_page.dart';
import 'package:my_portfolio/features/projects/presentation/views/work_page.dart';
import 'package:my_portfolio/features/projects/presentation/widgets/project_carousel.dart';

import '../../helpers/site_test_harness.dart';

void main() {
  setUp(registerSiteFakes);

  Future<GoRouter> pumpAt(WidgetTester tester, String location) async {
    setViewSize(tester, const Size(1440, 900));
    final router = AppRouter.createRouter(initialLocation: location);
    addTearDown(router.dispose);
    await tester.pumpWidget(
      MaterialApp.router(theme: kLightTheme, routerConfig: router),
    );
    // The landing previews intentionally loop, so route tests use a fixed
    // pump instead of waiting for the animation tree to become idle.
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 600));
    return router;
  }

  String? pageTitle(WidgetTester tester) =>
      tester.widget<Text>(find.byKey(SitePage.titleKey)).data;

  testWidgets('/ shows the landing', (tester) async {
    await pumpAt(tester, '/');
    expect(find.bySemanticsLabel('AABHASH RAI'), findsOneWidget);
    expect(find.byKey(SitePage.titleKey), findsNothing);
  });

  testWidgets('/work shows the work page', (tester) async {
    await pumpAt(tester, '/work');
    expect(find.byType(WorkPage), findsOneWidget);
  });

  testWidgets('/work/all shows every project', (tester) async {
    await pumpAt(tester, '/work/all');
    expect(find.byType(AllProjectsPage), findsOneWidget);

    // The Work page sits unbuilt beneath it; its carousel must not try to
    // rotate a PageView that does not exist yet.
    await tester.pump(ProjectCarousel.autoplayInterval * 2);
    expect(tester.takeException(), isNull);
  });

  testWidgets('/about shows the about page', (tester) async {
    await pumpAt(tester, '/about');
    expect(pageTitle(tester), 'ABOUT');
  });

  testWidgets('/contact opens the panel over the landing', (tester) async {
    await pumpAt(tester, '/contact');
    expect(find.text('Send message'), findsOneWidget);
    expect(
      find.bySemanticsLabel('I HELP FOUNDERS & TECH TEAMS BUILD MOBILE APPS'),
      findsOneWidget,
    );
  });

  testWidgets('widget navigation and back have no page transition', (
    tester,
  ) async {
    final router = await pumpAt(tester, '/');
    await tester.pump(const Duration(seconds: 2));

    final tile = find.byKey(LandingWidgetGrid.keyFor(SiteSection.work));
    await tester.tap(tile);
    // The tile's beat before its page, then the page is shown in one frame.
    await tester.pump(LandingGridViewModel.openDelay);
    await tester.pump();
    final route = ModalRoute.of(tester.element(find.byType(WorkPage)))!;
    expect(route.settings, isA<NoTransitionPage<void>>());
    expect(route.transitionDuration, Duration.zero);
    expect(route.reverseTransitionDuration, Duration.zero);
    expect(route.animation!.isCompleted, isTrue);

    router.pop();
    await tester.pump();
    expect(find.bySemanticsLabel('AABHASH RAI'), findsOneWidget);
    expect(find.byKey(SitePage.titleKey), findsNothing);
  });

  // The URL the browser shows, as the router reports it.
  String reportedPath(GoRouter router) =>
      router.routeInformationProvider.value.uri.path;

  testWidgets('a tile puts its page in the address bar; back restores it', (
    tester,
  ) async {
    final router = await pumpAt(tester, '/');
    await tester.pump(const Duration(seconds: 2));

    await tester.tap(find.byKey(LandingWidgetGrid.keyFor(SiteSection.work)));
    await tester.pump(LandingGridViewModel.openDelay);
    await tester.pump();
    expect(reportedPath(router), '/work');

    router.pop();
    await tester.pump();
    expect(reportedPath(router), '/');
  });

  testWidgets('"Explore all projects" puts /work/all in the address bar', (
    tester,
  ) async {
    final router = await pumpAt(tester, '/work');
    await tester.pump(const Duration(seconds: 2));

    final link = find.text('Explore all projects');
    await tester.ensureVisible(link);
    await tester.pump();
    await tester.tap(link);
    await tester.pump();
    expect(find.byType(AllProjectsPage), findsOneWidget);
    expect(reportedPath(router), '/work/all');
  });

  testWidgets('top bar link opens without a transition', (tester) async {
    await pumpAt(tester, '/about');
    await tester.pump(const Duration(seconds: 2));

    final link = find.text('Work').last;
    await tester.ensureVisible(link);
    await tester.pump();
    await tester.tap(link);
    await tester.pump();
    final route = ModalRoute.of(tester.element(find.byType(WorkPage)))!;
    expect(route.transitionDuration, Duration.zero);
    expect(route.animation!.isCompleted, isTrue);
  });
}
