import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:my_portfolio/app/navigation/site_navigation.dart';
import 'package:my_portfolio/app/navigation/site_text_link.dart';
import 'package:my_portfolio/app/navigation/site_top_bar.dart';

import '../../helpers/site_test_harness.dart';

void main() {
  late FakeLaunchService launch;
  setUp(() async => launch = await registerSiteFakes());

  const bar = Scaffold(body: SiteTopBar());

  testWidgets('desktop shows every destination and navigates', (
    tester,
  ) async {
    setViewSize(tester, const Size(1440, 900));
    await pumpRouted(tester, bar);

    for (final label in ['Work', 'About', 'Writing', 'Contact', 'Résumé']) {
      expect(find.text(label), findsOneWidget);
    }
    await tester.tap(find.text('About'));
    await tester.pumpAndSettle();
    expect(find.text('page /about'), findsOneWidget);
  });

  testWidgets('marks only the current section as selected', (tester) async {
    setViewSize(tester, const Size(1440, 900));
    await pumpRouted(
      tester,
      const Scaffold(body: SiteTopBar(current: SiteSection.work)),
    );

    final selected = tester
        .widgetList<SiteTextLink>(find.byType(SiteTextLink))
        .where((link) => link.selected)
        .map((link) => link.label);
    expect(selected, ['Work']);
  });

  testWidgets('résumé opens the hosted PDF', (tester) async {
    setViewSize(tester, const Size(1440, 900));
    await pumpRouted(tester, bar);

    await tester.tap(find.text('Résumé'));
    expect(launch.opened, ['/resume.pdf']);
  });

  testWidgets('contact opens the panel, not a route', (tester) async {
    setViewSize(tester, const Size(1440, 900));
    await pumpRouted(tester, bar);

    await tester.tap(find.text('Contact'));
    await tester.pumpAndSettle();
    expect(find.text('Send message'), findsOneWidget);
  });

  testWidgets('mobile moves links into a menu sheet', (tester) async {
    setViewSize(tester, const Size(390, 844));
    await pumpRouted(tester, bar);

    expect(find.text('Work'), findsNothing);
    await tester.tap(find.byTooltip('Menu'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Work'));
    await tester.pumpAndSettle();
    expect(find.text('page /work'), findsOneWidget);
  });
}
