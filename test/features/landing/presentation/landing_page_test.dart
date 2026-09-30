import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:my_portfolio/features/landing/presentation/views/landing_page.dart';

import '../../../helpers/site_test_harness.dart';

void main() {
  setUp(registerSiteFakes);

  const tagline = 'I HELP FOUNDERS & TECH TEAMS BUILD MOBILE APPS';

  for (final size in const [Size(375, 812), Size(768, 1024), Size(1440, 900)]) {
    testWidgets('shows name, tagline and every link at $size', (tester) async {
      setViewSize(tester, size);
      await pumpRouted(tester, const LandingPage());

      expect(find.text('AABHASH RAI'), findsOneWidget);
      expect(find.text(tagline), findsOneWidget);
      for (final label in ['WORK', 'ABOUT', 'WRITING', 'CONTACT', 'RÉSUMÉ']) {
        expect(find.text(label), findsOneWidget);
      }
    });
  }

  testWidgets('work link navigates to /work', (tester) async {
    setViewSize(tester, const Size(1440, 900));
    await pumpRouted(tester, const LandingPage());

    await tester.tap(find.text('WORK'));
    await tester.pumpAndSettle();
    expect(find.text('page /work'), findsOneWidget);
  });

  testWidgets('contact link opens the panel', (tester) async {
    setViewSize(tester, const Size(390, 844));
    await pumpRouted(tester, const LandingPage());

    await tester.tap(find.text('CONTACT'));
    await tester.pumpAndSettle();
    expect(find.text('Send Message'), findsOneWidget);
  });

  testWidgets('openContactOnStart opens the panel on load', (tester) async {
    setViewSize(tester, const Size(1440, 900));
    await pumpRouted(tester, const LandingPage(openContactOnStart: true));

    expect(find.text('Send Message'), findsOneWidget);
    expect(find.text(tagline), findsOneWidget);
  });
}
