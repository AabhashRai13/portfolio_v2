import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:my_portfolio/app/di/service_locator.dart';
import 'package:my_portfolio/app/navigation/site_page.dart';
import 'package:my_portfolio/app/navigation/site_text_link.dart';
import 'package:my_portfolio/features/projects/data/static_project_summaries.dart';
import 'package:my_portfolio/features/projects/presentation/controllers/work_controller.dart';
import 'package:my_portfolio/features/projects/presentation/views/work_page.dart';
import 'package:my_portfolio/features/projects/presentation/widgets/project_carousel.dart';

import '../../../helpers/site_test_harness.dart';

void main() {
  late FakeLaunchService launch;
  setUp(() async => launch = await registerSiteFakes());

  final flagships = staticProjectSummaries.where((p) => p.flagship).toList();

  Widget page() => WorkPage(controller: getIt<WorkController>());

  /// The middle card is the only one labelled "Open …".
  Finder current(int i) => find.bySemanticsLabel('Open ${flagships[i].title}');

  for (final size in const [Size(375, 812), Size(1440, 900)]) {
    testWidgets('shows only the flagship posters at $size', (tester) async {
      setViewSize(tester, size);
      await pumpRouted(tester, page());

      expect(find.byKey(SitePage.titleKey), findsNothing);
      expect(flagships, hasLength(3));
      expect(find.byType(ProjectPoster), findsNWidgets(3));
      expect(current(0), findsOneWidget);
      // No project text on the carousel itself.
      for (final project in staticProjectSummaries) {
        expect(find.text(project.title), findsNothing);
        expect(find.text(project.title.toUpperCase()), findsNothing);
      }
    });
  }

  testWidgets('the top bar marks Work as the current page', (tester) async {
    setViewSize(tester, const Size(1440, 900));
    await pumpRouted(tester, page());

    final selected = tester
        .widgetList<SiteTextLink>(find.byType(SiteTextLink))
        .where((link) => link.selected)
        .map((link) => link.label);
    expect(selected, ['Work']);
  });

  testWidgets('arrows and keys step through and wrap around', (tester) async {
    setViewSize(tester, const Size(1440, 900));
    await pumpRouted(tester, page());

    await tester.tap(find.byKey(ProjectCarousel.nextKey));
    await tester.pumpAndSettle();
    expect(current(1), findsOneWidget);

    await tester.sendKeyEvent(LogicalKeyboardKey.arrowRight);
    await tester.pumpAndSettle();
    expect(current(2), findsOneWidget);

    await tester.tap(find.byKey(ProjectCarousel.nextKey));
    await tester.pumpAndSettle();
    expect(current(0), findsOneWidget);

    await tester.tap(find.byKey(ProjectCarousel.previousKey));
    await tester.pumpAndSettle();
    expect(current(2), findsOneWidget);
  });

  testWidgets('tapping an arrow gives a light haptic tick', (tester) async {
    setViewSize(tester, const Size(1440, 900));
    await pumpRouted(tester, page());

    final calls = <MethodCall>[];
    final messenger = tester.binding.defaultBinaryMessenger
      ..setMockMethodCallHandler(SystemChannels.platform, (call) async {
        calls.add(call);
        return null;
      });
    addTearDown(
      () => messenger.setMockMethodCallHandler(SystemChannels.platform, null),
    );

    await tester.tap(find.byKey(ProjectCarousel.nextKey));
    await tester.pumpAndSettle();
    expect(
      calls
          .where((call) => call.method == 'HapticFeedback.vibrate')
          .map((call) => call.arguments),
      ['HapticFeedbackType.selectionClick'],
    );
  });

  testWidgets('a pill jumps to its project', (tester) async {
    setViewSize(tester, const Size(1440, 900));
    await pumpRouted(tester, page());

    await tester.tap(find.bySemanticsLabel('Show ${flagships[2].title}').last);
    await tester.pumpAndSettle();
    expect(current(2), findsOneWidget);
  });

  testWidgets('rotates on its own and pauses while hovered', (tester) async {
    setViewSize(tester, const Size(1440, 900));
    await pumpRouted(tester, page());

    await tester.pump(ProjectCarousel.autoplayInterval);
    await tester.pumpAndSettle();
    expect(current(1), findsOneWidget);

    final mouse = await tester.createGesture(kind: PointerDeviceKind.mouse);
    addTearDown(mouse.removePointer);
    await mouse.addPointer(location: tester.getCenter(current(1)));
    await tester.pump(ProjectCarousel.autoplayInterval * 2);
    await tester.pumpAndSettle();
    expect(current(1), findsOneWidget);
  });

  testWidgets('a horizontal trackpad swipe turns one page', (tester) async {
    setViewSize(tester, const Size(1440, 900));
    await pumpRouted(tester, page());

    // Web delivers trackpad swipes as wheel events: many small deltas.
    final pointer = TestPointer(1, PointerDeviceKind.mouse)
      ..hover(tester.getCenter(current(0)));
    for (var i = 0; i < 10; i++) {
      await tester.sendEventToBinding(pointer.scroll(const Offset(15, 0)));
      await tester.pump(const Duration(milliseconds: 16));
    }
    await tester.pumpAndSettle();
    expect(current(1), findsOneWidget);
  });

  testWidgets('tapping the middle card opens its details', (tester) async {
    setViewSize(tester, const Size(1440, 900));
    await pumpRouted(tester, page());

    await tester.tap(current(0));
    await tester.pumpAndSettle();
    final sadaqa = flagships.first;
    expect(find.text(sadaqa.title.toUpperCase()), findsOneWidget);
    expect(find.text(sadaqa.summary), findsOneWidget);

    await tester.tap(find.text('VIEW ON THE APP STORE ↗'));
    expect(launch.opened, [sadaqa.link]);

    await tester.tap(find.byTooltip('Close'));
    await tester.pumpAndSettle();
    expect(find.text(sadaqa.summary), findsNothing);
    expect(current(0), findsOneWidget);
  });

  testWidgets('Esc closes the details on a phone', (tester) async {
    setViewSize(tester, const Size(375, 812));
    await pumpRouted(tester, page());

    await tester.tap(current(0));
    await tester.pumpAndSettle();
    expect(find.text(flagships.first.summary), findsOneWidget);

    await tester.sendKeyEvent(LogicalKeyboardKey.escape);
    await tester.pumpAndSettle();
    expect(find.text(flagships.first.summary), findsNothing);
  });

  testWidgets('see all projects opens /work/all', (tester) async {
    setViewSize(tester, const Size(1440, 900));
    await pumpRouted(tester, page());

    final seeAll = find.text('All projects ↗');
    await tester.ensureVisible(seeAll);
    await tester.pumpAndSettle();
    await tester.tap(seeAll);
    await tester.pumpAndSettle();
    expect(find.text('page /work/all'), findsOneWidget);
  });
}
