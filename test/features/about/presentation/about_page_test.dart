import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:my_portfolio/app/navigation/site_page.dart';
import 'package:my_portfolio/features/about/presentation/views/about_page.dart';

import '../../../helpers/site_test_harness.dart';

void main() {
  late FakeLaunchService launch;
  setUp(() async => launch = await registerSiteFakes());

  for (final size in const [Size(375, 812), Size(1440, 900)]) {
    testWidgets('renders video, bio, skills and experience at $size', (
      tester,
    ) async {
      setViewSize(tester, size);
      await pumpRouted(tester, const AboutPage());

      expect(tester.widget<Text>(find.byKey(SitePage.titleKey)).data, 'ABOUT');
      expect(find.byTooltip('Play intro video'), findsOneWidget);
      expect(find.text('WATCH ON YOUTUBE ↗'), findsOneWidget);
      expect(find.textContaining("I'm Aabhash"), findsOneWidget);
      expect(find.text('SKILLS'), findsOneWidget);
      expect(find.text('EXPERIENCE'), findsOneWidget);
      expect(find.text('Sadaqa Welfare Fund'), findsOneWidget);
    });
  }

  testWidgets('download résumé opens the PDF', (tester) async {
    setViewSize(tester, const Size(1440, 900));
    await pumpRouted(tester, const AboutPage());

    final link = find.text('DOWNLOAD RÉSUMÉ ↗');
    await tester.ensureVisible(link);
    await tester.pumpAndSettle();
    await tester.tap(link);
    expect(launch.opened, ['/resume.pdf']);
  });
}
