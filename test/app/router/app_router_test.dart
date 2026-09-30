import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:my_portfolio/app/navigation/site_navigation.dart';
import 'package:my_portfolio/app/navigation/site_page.dart';
import 'package:my_portfolio/app/router/app_router.dart';
import 'package:my_portfolio/app/router/site_transition_page.dart';
import 'package:my_portfolio/core/resources/styles/theme.dart';
import 'package:my_portfolio/features/landing/presentation/widgets/landing_widget_grid.dart';

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
    expect(pageTitle(tester), 'WORK');
  });

  testWidgets('/about shows the about page', (tester) async {
    await pumpAt(tester, '/about');
    expect(pageTitle(tester), 'ABOUT');
  });

  testWidgets('/contact opens the panel over the landing', (tester) async {
    await pumpAt(tester, '/contact');
    expect(find.text('Send Message'), findsOneWidget);
    expect(
      find.bySemanticsLabel('I HELP FOUNDERS & TECH TEAMS BUILD MOBILE APPS'),
      findsOneWidget,
    );
  });

  testWidgets('widget route grows from its origin and reverses on back', (
    tester,
  ) async {
    final router = await pumpAt(tester, '/');
    await tester.pump(const Duration(seconds: 2));

    await tester.tap(
      find.byKey(LandingWidgetGrid.keyFor(SiteSection.work)),
    );
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 1));
    expect(find.byKey(SiteRouteTransition.expandKey), findsOneWidget);

    await tester.pump(const Duration(milliseconds: 500));
    expect(pageTitle(tester), 'WORK');

    router.pop();
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 500));
    expect(find.bySemanticsLabel('AABHASH RAI'), findsOneWidget);
  });

  testWidgets('ordinary landing link uses the fallback transition', (
    tester,
  ) async {
    await pumpAt(tester, '/');
    await tester.pump(const Duration(seconds: 2));

    final link = find.text('WORK').last;
    await tester.ensureVisible(link);
    await tester.pump();
    await tester.tap(link);
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 1));

    expect(find.byKey(SiteRouteTransition.fallbackKey), findsOneWidget);
  });
}
