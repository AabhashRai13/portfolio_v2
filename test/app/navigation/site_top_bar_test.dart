import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
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

    for (final label in ['WORK', 'ABOUT', 'WRITING', 'CONTACT', 'RÉSUMÉ']) {
      expect(find.text(label), findsOneWidget);
    }
    await tester.tap(find.text('ABOUT'));
    await tester.pumpAndSettle();
    expect(find.text('page /about'), findsOneWidget);
  });

  testWidgets('résumé opens the hosted PDF', (tester) async {
    setViewSize(tester, const Size(1440, 900));
    await pumpRouted(tester, bar);

    await tester.tap(find.text('RÉSUMÉ'));
    expect(launch.opened, ['/resume.pdf']);
  });

  testWidgets('contact opens the panel, not a route', (tester) async {
    setViewSize(tester, const Size(1440, 900));
    await pumpRouted(tester, bar);

    await tester.tap(find.text('CONTACT'));
    await tester.pumpAndSettle();
    expect(find.text('Send message'), findsOneWidget);
  });

  testWidgets('mobile moves links into a menu sheet', (tester) async {
    setViewSize(tester, const Size(390, 844));
    await pumpRouted(tester, bar);

    expect(find.text('WORK'), findsNothing);
    await tester.tap(find.byTooltip('Menu'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('WORK'));
    await tester.pumpAndSettle();
    expect(find.text('page /work'), findsOneWidget);
  });
}
