import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:my_portfolio/features/blog_detail/presentation/controllers/reading_progress_view_model.dart';

void main() {
  group('ReadingProgressViewModel', () {
    testWidgets('starts at 0 before any scroll', (tester) async {
      final ctrl = ScrollController();
      addTearDown(ctrl.dispose);
      final vm = ReadingProgressViewModel(scrollController: ctrl);
      addTearDown(vm.dispose);

      await _pumpScrollable(tester, ctrl);

      expect(vm.progress, 0);
    });

    testWidgets('midpoint scroll yields ~0.5 progress', (tester) async {
      final ctrl = ScrollController();
      addTearDown(ctrl.dispose);
      final vm = ReadingProgressViewModel(scrollController: ctrl);
      addTearDown(vm.dispose);

      await _pumpScrollable(tester, ctrl,);
      final half = ctrl.position.maxScrollExtent / 2;

      ctrl.jumpTo(half);
      await tester.pump();

      expect(vm.progress, closeTo(0.5, 0.01));
    });

    testWidgets('fully scrolled yields 1.0 progress', (tester) async {
      final ctrl = ScrollController();
      addTearDown(ctrl.dispose);
      final vm = ReadingProgressViewModel(scrollController: ctrl);
      addTearDown(vm.dispose);

      await _pumpScrollable(tester, ctrl);

      ctrl.jumpTo(ctrl.position.maxScrollExtent);
      await tester.pump();

      expect(vm.progress, 1);
    });

    testWidgets(
      'stays at 0 when content fits in the viewport (no scroll range)',
      (tester) async {
        final ctrl = ScrollController();
        addTearDown(ctrl.dispose);
        final vm = ReadingProgressViewModel(scrollController: ctrl);
        addTearDown(vm.dispose);

        await _pumpScrollable(tester, ctrl, contentHeight: 200);

        expect(ctrl.position.maxScrollExtent, 0);
        expect(vm.progress, 0);
      },
    );

    testWidgets('does not notify for sub-threshold deltas', (tester) async {
      final ctrl = ScrollController();
      addTearDown(ctrl.dispose);
      final vm = ReadingProgressViewModel(scrollController: ctrl);
      addTearDown(vm.dispose);

      // Big content so 1 pixel is a tiny fraction of the scroll range.
      await _pumpScrollable(tester, ctrl, contentHeight: 100600);

      ctrl.jumpTo(500);
      await tester.pump();
      final baseline = vm.progress;

      var notifications = 0;
      vm.addListener(() => notifications++);

      // 1 px / 100000 px range = 0.00001 change, well below the 0.002 gate.
      ctrl.jumpTo(501);
      await tester.pump();

      expect(notifications, 0);
      expect(vm.progress, baseline);
    });

    testWidgets('always notifies when snapping back to 0', (tester) async {
      final ctrl = ScrollController();
      addTearDown(ctrl.dispose);
      final vm = ReadingProgressViewModel(scrollController: ctrl);
      addTearDown(vm.dispose);

      await _pumpScrollable(tester, ctrl, contentHeight: 100600);

      // Tiny jump that crosses the delta gate so progress becomes > 0.
      ctrl.jumpTo(400);
      await tester.pump();
      expect(vm.progress, greaterThan(0));

      var notifications = 0;
      vm.addListener(() => notifications++);

      ctrl.jumpTo(0);
      await tester.pump();

      expect(vm.progress, 0);
      expect(notifications, 1);
    });

    testWidgets('dispose stops receiving scroll updates', (tester) async {
      final ctrl = ScrollController();
      addTearDown(ctrl.dispose);
      final vm = ReadingProgressViewModel(scrollController: ctrl);

      await _pumpScrollable(tester, ctrl);

      vm.dispose();

      ctrl.jumpTo(ctrl.position.maxScrollExtent);
      await tester.pump();

      expect(vm.progress, 0);
    });
  });
}

Future<void> _pumpScrollable(
  WidgetTester tester,
  ScrollController ctrl, {
  double contentHeight = 1600,
}) async {
  await tester.pumpWidget(
    MaterialApp(
      home: Scaffold(
        body: SingleChildScrollView(
          controller: ctrl,
          child: SizedBox(height: contentHeight, width: 100),
        ),
      ),
    ),
  );
}
