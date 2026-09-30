import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:my_portfolio/app/navigation/site_page.dart';
import 'package:my_portfolio/app/router/app_router.dart';
import 'package:my_portfolio/core/resources/styles/theme.dart';

import '../../helpers/site_test_harness.dart';

void main() {
  setUp(registerSiteFakes);

  Future<void> pumpAt(WidgetTester tester, String location) async {
    setViewSize(tester, const Size(1440, 900));
    final router = AppRouter.createRouter(initialLocation: location);
    addTearDown(router.dispose);
    await tester.pumpWidget(
      MaterialApp.router(theme: kLightTheme, routerConfig: router),
    );
    await tester.pumpAndSettle();
  }

  String? pageTitle(WidgetTester tester) =>
      tester.widget<Text>(find.byKey(SitePage.titleKey)).data;

  testWidgets('/ shows the landing', (tester) async {
    await pumpAt(tester, '/');
    expect(find.text('AABHASH RAI'), findsOneWidget);
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
      find.text('I HELP FOUNDERS & TECH TEAMS BUILD MOBILE APPS'),
      findsOneWidget,
    );
  });
}
