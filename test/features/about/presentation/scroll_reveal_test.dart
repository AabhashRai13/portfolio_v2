import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:my_portfolio/features/about/presentation/widgets/scroll_reveal.dart';

/// A 600 px tall scroll view with [gap] of empty space above the reveal.
Future<ScrollController> _pump(
  WidgetTester tester, {
  required double gap,
  bool reduceMotion = false,
}) async {
  tester.view
    ..physicalSize = const Size(400, 600)
    ..devicePixelRatio = 1;
  addTearDown(tester.view.reset);
  final controller = ScrollController();
  addTearDown(controller.dispose);
  await tester.pumpWidget(
    MaterialApp(
      home: MediaQuery(
        data: MediaQueryData(
          size: const Size(400, 600),
          disableAnimations: reduceMotion,
        ),
        child: Scaffold(
          body: SingleChildScrollView(
            controller: controller,
            child: Column(
              children: [
                SizedBox(height: gap),
                ScrollReveal(
                  builder: (context, reveal) =>
                      FadeUp(reveal: reveal, child: const Text('hello')),
                ),
                const SizedBox(height: 2000),
              ],
            ),
          ),
        ),
      ),
    ),
  );
  await tester.pump();
  return controller;
}

double _opacity(WidgetTester tester) => tester
    .widget<FadeTransition>(
      find.descendant(
        of: find.byType(ScrollReveal),
        matching: find.byType(FadeTransition),
      ),
    )
    .opacity
    .value;

void main() {
  testWidgets('shows what is already on screen at load without animating', (
    tester,
  ) async {
    await _pump(tester, gap: 100);
    expect(_opacity(tester), 1);
  });

  testWidgets('stays hidden below the fold, then fades in when scrolled to', (
    tester,
  ) async {
    final controller = await _pump(tester, gap: 1000);
    expect(_opacity(tester), 0);

    controller.jumpTo(700);
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 100));
    expect(_opacity(tester), inExclusiveRange(0, 1));

    await tester.pumpAndSettle();
    expect(_opacity(tester), 1);
  });

  testWidgets('waits until it is clear of the bottom edge', (tester) async {
    // Top at 1000 - 450 = 550 of 600: on screen, but under the trigger line.
    final controller = await _pump(tester, gap: 1000);
    controller.jumpTo(450);
    await tester.pumpAndSettle();
    expect(_opacity(tester), 0);
  });

  testWidgets('plays once: scrolling back up leaves it shown', (tester) async {
    final controller = await _pump(tester, gap: 1000);
    controller.jumpTo(700);
    await tester.pumpAndSettle();

    controller.jumpTo(0);
    await tester.pumpAndSettle();
    expect(_opacity(tester), 1);
  });

  testWidgets('is shown still when the platform asks for less motion', (
    tester,
  ) async {
    await _pump(tester, gap: 1000, reduceMotion: true);
    expect(_opacity(tester), 1);
  });

  testWidgets('stays readable by screen readers while hidden', (
    tester,
  ) async {
    final semantics = tester.ensureSemantics();
    final controller = await _pump(tester, gap: 1000);
    controller.jumpTo(450);
    await tester.pumpAndSettle();

    expect(_opacity(tester), 0);
    expect(find.bySemanticsLabel('hello'), findsOneWidget);
    semantics.dispose();
  });

  test('staggered spreads children across the reveal in order', () {
    final reveal = AnimationController(vsync: const TestVSync())..value = 0.25;
    addTearDown(reveal.dispose);

    final first = staggered(reveal, index: 0, count: 3);
    final last = staggered(reveal, index: 2, count: 3);
    expect(first.value, greaterThan(0));
    expect(last.value, 0);

    reveal.value = 1;
    expect(first.value, 1);
    expect(last.value, 1);
  });
}
