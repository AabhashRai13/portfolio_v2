import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:my_portfolio/app/navigation/site_page.dart';
import 'package:my_portfolio/features/about/data/about_content.dart';
import 'package:my_portfolio/features/about/presentation/views/about_page.dart';

import '../../../helpers/site_test_harness.dart';

void main() {
  late FakeLaunchService launch;
  setUp(() async => launch = await registerSiteFakes());

  for (final size in const [
    Size(375, 812),
    Size(390, 844),
    Size(768, 1024),
    Size(1440, 900),
  ]) {
    testWidgets('renders video, statement, fit, process and skills at $size', (
      tester,
    ) async {
      setViewSize(tester, size);
      await pumpRouted(tester, const AboutPage());

      expect(tester.widget<Text>(find.byKey(SitePage.titleKey)).data, 'ABOUT');
      expect(find.byTooltip('Play intro video'), findsOneWidget);
      expect(find.text('PLAY INTRO · 1:02'), findsOneWidget);
      expect(find.text('WATCH ON YOUTUBE ↗'), findsOneWidget);
      for (final line in aboutStatement) {
        expect(find.text(line), findsOneWidget);
      }
      expect(find.textContaining('SYDNEY ·'), findsOneWidget);
      expect(find.text("YOU'LL BE A GOOD FIT IF YOU…"), findsOneWidget);
      for (final item in goodFit) {
        expect(find.text(item), findsOneWidget);
      }
      expect(find.text('HOW I WORK'), findsOneWidget);
      for (final skill in skills) {
        expect(find.text(skill.label), findsOneWidget);
      }
      expect(find.text(AboutPage.ctaLabel), findsOneWidget);
      expect(find.text('EXPERIENCE'), findsNothing);
    });
  }

  testWidgets('the big button opens the contact form', (tester) async {
    setViewSize(tester, const Size(1440, 900));
    await pumpRouted(tester, const AboutPage());

    final cta = find.text(AboutPage.ctaLabel);
    await tester.ensureVisible(cta);
    await tester.pumpAndSettle();
    await tester.tap(cta);
    await tester.pumpAndSettle();
    expect(find.text('Send message'), findsOneWidget);
  });

  testWidgets('résumé link opens the PDF', (tester) async {
    setViewSize(tester, const Size(390, 844));
    await pumpRouted(tester, const AboutPage());

    final link = find.text('OR GRAB MY RÉSUMÉ (PDF) ↓');
    await tester.ensureVisible(link);
    await tester.pumpAndSettle();
    await tester.tap(link);
    expect(launch.opened, ['/resume.pdf']);
  });
}
