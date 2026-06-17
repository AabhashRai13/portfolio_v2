import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:my_portfolio/core/services/smooth_wheel_scroll_controller.dart';
import 'package:my_portfolio/features/blog_detail/domain/entities/toc_heading.dart';
import 'package:my_portfolio/features/blog_detail/presentation/controllers/toc_view_model.dart';

// Heading y-offsets in the pumped tree (see `_buildFixture` below):
//   intro → 0..100
//   body  → 600..700
//   end   → 1200..1300
// With the default `topPadding = 100`, the boundaries are at scroll
// values 500 (body becomes active) and 1100 (end becomes active).
const _bodyBoundary = 500.0;
const _endBoundary = 1100.0;

void main() {
  group('TocViewModel', () {
    testWidgets('initial activeIndex is 0', (tester) async {
      final ctrl = SmoothWheelScrollController();
      addTearDown(ctrl.dispose);
      final fixture = await _buildFixture(tester, ctrl);

      expect(fixture.vm.activeIndex, 0);
    });

    testWidgets(
      'activeIndex advances as the user scrolls past each heading',
      (tester) async {
        final ctrl = SmoothWheelScrollController();
        addTearDown(ctrl.dispose);
        final fixture = await _buildFixture(tester, ctrl);

        ctrl.jumpTo(_bodyBoundary);
        await tester.pump();
        expect(fixture.vm.activeIndex, 1);

        ctrl.jumpTo(_endBoundary);
        await tester.pump();
        expect(fixture.vm.activeIndex, 2);
      },
    );

    testWidgets(
      'does not notify when the active heading is unchanged',
      (tester) async {
        final ctrl = SmoothWheelScrollController();
        addTearDown(ctrl.dispose);
        final fixture = await _buildFixture(tester, ctrl);

        ctrl.jumpTo(_bodyBoundary);
        await tester.pump();

        var notifications = 0;
        fixture.vm.addListener(() => notifications++);

        // Small jump that stays within the "body" active range.
        ctrl.jumpTo(_bodyBoundary + 50);
        await tester.pump();

        expect(notifications, 0);
        expect(fixture.vm.activeIndex, 1);
      },
    );

    testWidgets('scrollToHeading navigates and updates activeIndex', (
      tester,
    ) async {
      final ctrl = SmoothWheelScrollController();
      addTearDown(ctrl.dispose);
      final fixture = await _buildFixture(tester, ctrl);

      final scrollFuture = fixture.vm.scrollToHeading(2);
      await tester.pump();
      await tester.pumpAndSettle();
      await scrollFuture;

      expect(fixture.vm.activeIndex, 2);
      expect(ctrl.position.pixels, greaterThan(_endBoundary - 1));
    });

    testWidgets('scrollToHeadingById resolves the id to the correct heading', (
      tester,
    ) async {
      final ctrl = SmoothWheelScrollController();
      addTearDown(ctrl.dispose);
      final fixture = await _buildFixture(tester, ctrl);

      final scrollFuture = fixture.vm.scrollToHeadingById('body');
      await tester.pump();
      await tester.pumpAndSettle();
      await scrollFuture;

      expect(fixture.vm.activeIndex, 1);
    });

    testWidgets('scrollToHeading with an out-of-range index is a no-op', (
      tester,
    ) async {
      final ctrl = SmoothWheelScrollController();
      addTearDown(ctrl.dispose);
      final fixture = await _buildFixture(tester, ctrl);

      final before = ctrl.position.pixels;
      await fixture.vm.scrollToHeading(99);
      await fixture.vm.scrollToHeading(-1);
      await tester.pumpAndSettle();

      expect(ctrl.position.pixels, before);
    });

    testWidgets('scrollToHeadingById with an unknown id is a no-op', (
      tester,
    ) async {
      final ctrl = SmoothWheelScrollController();
      addTearDown(ctrl.dispose);
      final fixture = await _buildFixture(tester, ctrl);

      final before = ctrl.position.pixels;
      await fixture.vm.scrollToHeadingById('does-not-exist');
      await tester.pumpAndSettle();

      expect(ctrl.position.pixels, before);
    });

    testWidgets('dispose stops reacting to scroll events', (tester) async {
      final ctrl = SmoothWheelScrollController();
      addTearDown(ctrl.dispose);
      final fixture = await _buildFixture(
        tester,
        ctrl,
        registerDispose: false,
      );

      fixture.vm.dispose();

      ctrl.jumpTo(_endBoundary);
      await tester.pump();

      expect(fixture.vm.activeIndex, 0);
    });
  });
}

class _Fixture {
  _Fixture({required this.vm, required this.keys});

  final TocViewModel vm;
  final Map<String, GlobalKey> keys;
}

Future<_Fixture> _buildFixture(
  WidgetTester tester,
  SmoothWheelScrollController ctrl, {
  bool registerDispose = true,
}) async {
  const headings = <TocHeading>[
    TocHeading(text: 'Intro', level: 2, id: 'intro'),
    TocHeading(text: 'Body', level: 2, id: 'body'),
    TocHeading(text: 'End', level: 2, id: 'end'),
  ];
  final keys = <String, GlobalKey>{
    for (final h in headings) h.id: GlobalKey(),
  };

  final vm = TocViewModel(
    scrollController: ctrl,
    headings: headings,
    headingKeys: keys,
  );
  if (registerDispose) {
    addTearDown(vm.dispose);
  }

  await tester.pumpWidget(
    MaterialApp(
      home: Scaffold(
        body: SingleChildScrollView(
          controller: ctrl,
          child: Column(
            children: <Widget>[
              SizedBox(height: 100, key: keys['intro']),
              const SizedBox(height: 500),
              SizedBox(height: 100, key: keys['body']),
              const SizedBox(height: 500),
              SizedBox(height: 100, key: keys['end']),
              const SizedBox(height: 800),
            ],
          ),
        ),
      ),
    ),
  );

  return _Fixture(vm: vm, keys: keys);
}
