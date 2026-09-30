import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:my_portfolio/app/navigation/site_navigation.dart';
import 'package:my_portfolio/features/landing/presentation/views/contact_landing_page.dart';
import 'package:my_portfolio/features/landing/presentation/views/landing_page.dart';
import 'package:my_portfolio/features/landing/presentation/widgets/landing_phone.dart';
import 'package:my_portfolio/features/landing/presentation/widgets/landing_widget_grid.dart';

import '../../../helpers/site_test_harness.dart';

void main() {
  setUp(registerSiteFakes);

  const tagline = 'I HELP FOUNDERS & TECH TEAMS BUILD MOBILE APPS';

  test('landing page is a stateless composition boundary', () {
    expect(const LandingPage(), isA<StatelessWidget>());
  });

  for (final size in const [Size(375, 812), Size(768, 1024), Size(1440, 900)]) {
    testWidgets('shows name, tagline and every link at $size', (tester) async {
      setViewSize(tester, size);
      await pumpRouted(tester, const LandingPage(), settle: false);

      expect(find.bySemanticsLabel('AABHASH RAI'), findsOneWidget);
      expect(find.bySemanticsLabel(tagline), findsOneWidget);
      expect(find.byType(LandingWidgetGrid), findsOneWidget);
      expect(tester.takeException(), isNull);
      expect(
        tester.getBottomRight(find.text('RÉSUMÉ')).dy,
        lessThanOrEqualTo(size.height),
      );
      for (final label in ['WORK', 'ABOUT', 'WRITING', 'CONTACT', 'RÉSUMÉ']) {
        expect(find.text(label), findsWidgets);
      }
    });
  }

  testWidgets('work link navigates to /work', (tester) async {
    setViewSize(tester, const Size(1440, 900));
    await pumpRouted(tester, const LandingPage(), settle: false);
    await tester.pump(const Duration(seconds: 2));

    final link = find.text('WORK').last;
    await tester.ensureVisible(link);
    await tester.pump();
    await tester.tap(link);
    await tester.pumpAndSettle();
    expect(find.text('page /work'), findsOneWidget);
  });

  testWidgets('desktop frames the grid in a draggable phone', (tester) async {
    setViewSize(tester, const Size(1440, 900));
    await pumpRouted(tester, const LandingPage(), settle: false);

    expect(find.byType(LandingPhone), findsOneWidget);
    expect(find.text('EXPLORE THE TILES'), findsOneWidget);
  });

  testWidgets('desktop phone follows a drag and springs home', (tester) async {
    setViewSize(tester, const Size(1440, 900));
    await pumpRouted(tester, const LandingPage(), settle: false);
    await tester.pump(const Duration(seconds: 2));

    final phone = find.byKey(LandingPhone.motionKey);
    final gesture = await tester.startGesture(tester.getCenter(phone));
    // The first move wins the pan gesture arena; the second carries the drag.
    await gesture.moveBy(const Offset(24, 6));
    await tester.pump();
    await gesture.moveBy(const Offset(24, 6));
    await tester.pump();
    expect(
      tester.widget<Transform>(phone).transform.getTranslation().x,
      greaterThan(15),
    );

    await gesture.up();
    await tester.pump();
    await tester.pump(const Duration(seconds: 2));
    expect(
      tester.widget<Transform>(phone).transform.getTranslation().x,
      closeTo(0, 2),
    );
  });

  testWidgets('mobile uses the full grid without the phone', (tester) async {
    setViewSize(tester, const Size(390, 844));
    await pumpRouted(tester, const LandingPage(), settle: false);

    expect(find.byType(LandingPhone), findsNothing);
    expect(find.text('EXPLORE THE TILES'), findsOneWidget);
  });

  for (final section in SiteSection.values.where(
    (section) => section != SiteSection.contact,
  )) {
    testWidgets('${section.label} widget opens ${section.route}', (
      tester,
    ) async {
      setViewSize(tester, const Size(390, 844));
      await pumpRouted(tester, const LandingPage(), settle: false);
      await tester.pump(const Duration(seconds: 2));

      final tile = find.byKey(LandingWidgetGrid.keyFor(section));
      await tester.ensureVisible(tile);
      await tester.pump();
      await tester.tap(tile);
      await tester.pumpAndSettle();
      expect(find.text('page ${section.route}'), findsOneWidget);
    });
  }

  testWidgets('contact link opens the panel', (tester) async {
    setViewSize(tester, const Size(390, 844));
    await pumpRouted(tester, const LandingPage(), settle: false);
    await tester.pump(const Duration(seconds: 2));

    final tile = find.byKey(
      LandingWidgetGrid.keyFor(SiteSection.contact),
    );
    await tester.ensureVisible(tile);
    await tester.pump();
    await tester.tap(tile);
    await tester.pump(const Duration(milliseconds: 500));
    expect(find.text('Send Message'), findsOneWidget);
  });

  testWidgets('reduced motion renders every preview at rest', (tester) async {
    setViewSize(tester, const Size(1440, 900));
    await pumpRouted(
      tester,
      const MediaQuery(
        data: MediaQueryData(disableAnimations: true),
        child: LandingPage(),
      ),
    );

    for (final section in SiteSection.values) {
      expect(find.byKey(LandingWidgetGrid.keyFor(section)), findsOneWidget);
    }
    expect(tester.takeException(), isNull);
  });

  testWidgets('contact route adapter opens the panel on load', (tester) async {
    setViewSize(tester, const Size(1440, 900));
    await pumpRouted(
      tester,
      const ContactLandingPage(),
      settle: false,
    );
    await tester.pump(const Duration(milliseconds: 500));

    expect(find.text('Send Message'), findsOneWidget);
    expect(find.bySemanticsLabel(tagline), findsOneWidget);
  });
}
