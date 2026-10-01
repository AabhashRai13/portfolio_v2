import 'package:flutter/gestures.dart' show PointerDeviceKind;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show LogicalKeyboardKey;
import 'package:flutter_test/flutter_test.dart';
import 'package:my_portfolio/app/navigation/site_navigation.dart';
import 'package:my_portfolio/constants/size.dart';
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

  for (final size in const [
    Size(375, 812),
    Size(768, 1024),
    Size(1024, 768),
    Size(1440, 900),
  ]) {
    testWidgets('shows name, tagline and every link at $size', (tester) async {
      setViewSize(tester, size);
      await pumpRouted(tester, const LandingPage(), settle: false);

      expect(find.bySemanticsLabel('AABHASH RAI'), findsOneWidget);
      expect(find.bySemanticsLabel(tagline), findsOneWidget);
      expect(find.byType(LandingWidgetGrid), findsOneWidget);
      expect(tester.takeException(), isNull);
      final resume = find.text('RÉSUMÉ');
      if (size.width >= kSiteDesktopBreakpoint) {
        await tester.ensureVisible(resume);
        await tester.pump();
      }
      expect(
        tester.getBottomRight(resume).dy,
        lessThanOrEqualTo(size.height),
      );
      for (final label in ['WORK', 'ABOUT', 'WRITING', 'CONTACT', 'RÉSUMÉ']) {
        expect(find.text(label), findsWidgets);
      }
    });
  }

  // The phone keeps its size, so the name and tagline shrink on shorter
  // desktop viewports to keep the whole tagline on the first screen.
  for (final size in const [
    Size(1920, 1080),
    Size(1835, 1058),
    Size(1728, 994),
    Size(1536, 940),
  ]) {
    testWidgets('tagline is fully visible on first load at $size', (
      tester,
    ) async {
      setViewSize(tester, size);
      await pumpRouted(tester, const LandingPage(), settle: false);
      await tester.pump(const Duration(seconds: 2));

      expect(
        tester.getBottomLeft(find.text('APPS')).dy,
        lessThanOrEqualTo(size.height),
      );
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

  for (final section in SiteSection.values) {
    testWidgets('enlarged desktop ${section.label} tile remains tappable', (
      tester,
    ) async {
      setViewSize(tester, const Size(1440, 1080));
      await pumpRouted(tester, const LandingPage(), settle: false);
      await tester.pump(const Duration(seconds: 2));

      final tile = find.byKey(LandingWidgetGrid.keyFor(section));
      final mouse = await tester.createGesture(kind: PointerDeviceKind.mouse);
      await mouse.addPointer(location: Offset.zero);
      await mouse.moveTo(tester.getCenter(tile));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 500));
      await tester.tap(tile);
      if (section == SiteSection.contact) {
        await tester.pump(const Duration(milliseconds: 500));
        expect(find.text('Send message'), findsOneWidget);
      } else {
        await tester.pumpAndSettle();
        expect(find.text('page ${section.route}'), findsOneWidget);
      }
      await mouse.removePointer();
    });
  }

  testWidgets(
    'phone hover straightens and grows hardware while emphasizing one tile',
    (
      tester,
    ) async {
      setViewSize(tester, const Size(1440, 1080));
      await pumpRouted(tester, const LandingPage(), settle: false);
      await tester.pump(const Duration(seconds: 2));

      Rect visibleBounds(Finder finder) {
        final box = tester.renderObject<RenderBox>(finder);
        return MatrixUtils.transformRect(
          box.getTransformTo(null),
          Offset.zero & box.size,
        );
      }

      final frame = find
          .descendant(
            of: find.byType(LandingPhone),
            matching: find.byType(SizedBox),
          )
          .first;
      final work = find.byKey(LandingWidgetGrid.keyFor(SiteSection.work));
      final writing = find.byKey(LandingWidgetGrid.keyFor(SiteSection.writing));
      final name = find.text('AABHASH');
      final beforePhone = visibleBounds(frame);
      final frameBox = tester.renderObject<RenderBox>(frame);
      final beforeTopLeft = frameBox.localToGlobal(Offset.zero);
      final beforeTopRight = frameBox.localToGlobal(
        Offset(frameBox.size.width, 0),
      );
      expect((beforeTopLeft.dy - beforeTopRight.dy).abs(), greaterThan(10));
      final beforeName = visibleBounds(name);
      final beforeTileRatio =
          visibleBounds(work).width / visibleBounds(writing).width;

      final mouse = await tester.createGesture(kind: PointerDeviceKind.mouse);
      await mouse.addPointer(location: Offset.zero);
      await mouse.moveTo(tester.getCenter(work));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 600));

      final topLeft = frameBox.localToGlobal(Offset.zero);
      final topRight = frameBox.localToGlobal(Offset(frameBox.size.width, 0));
      final bottomLeft = frameBox.localToGlobal(
        Offset(0, frameBox.size.height),
      );
      final bottomRight = frameBox.localToGlobal(
        frameBox.size.bottomRight(Offset.zero),
      );
      expect(topLeft.dy, closeTo(topRight.dy, 0.1));
      expect(bottomLeft.dy, closeTo(bottomRight.dy, 0.1));
      expect(topLeft.dx, closeTo(bottomLeft.dx, 0.1));
      expect(topRight.dx, closeTo(bottomRight.dx, 0.1));
      expect(
        (topRight - topLeft).distance,
        greaterThan((beforeTopRight - beforeTopLeft).distance * 1.15),
      );
      expect(visibleBounds(name).width, lessThan(beforeName.width * 0.9));
      expect(
        visibleBounds(work).width / visibleBounds(writing).width,
        greaterThan(beforeTileRatio * 1.08),
      );
      expect(find.text('OPEN →'), findsOneWidget);

      await mouse.moveTo(Offset.zero);
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 600));
      expect(visibleBounds(frame).width, closeTo(beforePhone.width, 0.1));
      expect(visibleBounds(name).width, closeTo(beforeName.width, 0.1));
      expect(find.text('OPEN →'), findsNothing);

      // Unmounting a hovered MouseRegion does not dispatch onExit.
      await mouse.moveTo(tester.getCenter(work));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 600));
      tester.view.physicalSize = const Size(390, 844);
      await tester.pump();
      expect(find.byType(LandingPhone), findsNothing);
      await mouse.moveTo(Offset.zero);
      tester.view.physicalSize = const Size(1440, 1080);
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 600));
      expect(visibleBounds(frame).width, closeTo(beforePhone.width, 0.1));
      expect(visibleBounds(name).width, closeTo(beforeName.width, 0.1));
      await mouse.removePointer();
    },
  );

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

  group('desktop contact inside the phone', () {
    Finder inPhone(Finder finder) =>
        find.descendant(of: find.byType(LandingPhone), matching: finder);

    // Starts the cross-fade, runs it to the end, then lets AnimatedSwitcher
    // drop the outgoing child on the following frame.
    Future<void> settleSwitch(WidgetTester tester) async {
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 600));
      await tester.pump();
    }

    Future<void> openPhoneContact(
      WidgetTester tester, {
      Size size = const Size(1440, 900),
    }) async {
      setViewSize(tester, size);
      await pumpRouted(tester, const LandingPage(), settle: false);
      await tester.pump(const Duration(seconds: 2));
      final tile = find.byKey(LandingWidgetGrid.keyFor(SiteSection.contact));
      await tester.ensureVisible(tile);
      await tester.pump();
      await tester.tap(tile);
      await settleSwitch(tester);
    }

    testWidgets('contact tile swaps the grid for the form in the phone', (
      tester,
    ) async {
      await openPhoneContact(tester);

      expect(inPhone(find.text('Send message')), findsOneWidget);
      expect(find.byType(LandingWidgetGrid), findsNothing);
      expect(find.byType(BottomSheet), findsNothing);
      expect(find.text('page /contact'), findsNothing);
      expect(find.bySemanticsLabel(tagline), findsOneWidget);
    });

    testWidgets('back restores the grid without leaving the landing', (
      tester,
    ) async {
      await openPhoneContact(tester);

      await tester.tap(find.byTooltip('Back to widgets'));
      await settleSwitch(tester);
      expect(find.byType(LandingWidgetGrid), findsOneWidget);
      expect(find.text('Send message'), findsNothing);
    });

    testWidgets('escape restores the grid', (tester) async {
      await openPhoneContact(tester);

      await tester.sendKeyEvent(LogicalKeyboardKey.escape);
      await settleSwitch(tester);
      expect(find.byType(LandingWidgetGrid), findsOneWidget);
      expect(find.text('Send message'), findsNothing);
    });

    testWidgets('phone ignores drag while the form is open', (tester) async {
      await openPhoneContact(tester);

      final phone = find.byKey(LandingPhone.motionKey);
      final gesture = await tester.startGesture(
        tester.getTopLeft(phone) + const Offset(150, 12),
      );
      for (var i = 0; i < 3; i++) {
        await gesture.moveBy(const Offset(24, 0));
        await tester.pump();
      }
      await gesture.up();
      await tester.pump();
      expect(
        tester.widget<Transform>(phone).transform.getTranslation().x.abs(),
        lessThan(1),
      );
    });

    testWidgets('send button is reachable inside the phone', (tester) async {
      await openPhoneContact(tester);

      final send = find.text('Send message');
      await tester.ensureVisible(send);
      await tester.pump(const Duration(milliseconds: 300));
      expect(send.hitTestable(), findsOneWidget);
    });

    testWidgets('on-screen keyboard at tablet width does not overflow', (
      tester,
    ) async {
      await openPhoneContact(tester, size: const Size(1024, 1366));

      tester.view.viewInsets = const FakeViewPadding(bottom: 320);
      addTearDown(tester.view.resetViewInsets);
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 300));
      expect(tester.takeException(), isNull);
      expect(inPhone(find.text('Send message')), findsOneWidget);
    });

    testWidgets('resizing to mobile while open releases the phone', (
      tester,
    ) async {
      await openPhoneContact(tester);

      tester.view.physicalSize = const Size(390, 844);
      await tester.pump();
      expect(tester.takeException(), isNull);
      tester.view.physicalSize = const Size(1440, 900);
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 600));
      expect(find.byType(LandingWidgetGrid), findsOneWidget);
      expect(tester.takeException(), isNull);
    });

    testWidgets('desktop contact text link still opens the panel', (
      tester,
    ) async {
      setViewSize(tester, const Size(1440, 900));
      await pumpRouted(tester, const LandingPage(), settle: false);
      await tester.pump(const Duration(seconds: 2));

      final link = find.text('CONTACT').last;
      await tester.ensureVisible(link);
      await tester.pump();
      await tester.tap(link);
      await tester.pump(const Duration(milliseconds: 600));
      expect(find.text('Send message'), findsOneWidget);
      expect(inPhone(find.text('Send message')), findsNothing);
      expect(find.byType(LandingWidgetGrid), findsOneWidget);
    });
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
    expect(find.text('Send message'), findsOneWidget);
  });

  testWidgets('reduced motion renders every preview at rest', (tester) async {
    setViewSize(tester, const Size(1440, 900));
    await pumpRouted(
      tester,
      const MediaQuery(
        data: MediaQueryData(
          size: Size(1440, 900),
          disableAnimations: true,
        ),
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

    expect(find.text('Send message'), findsOneWidget);
    expect(find.bySemanticsLabel(tagline), findsOneWidget);
  });
}
