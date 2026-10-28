import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:my_portfolio/features/about/presentation/widgets/scroll_highlight_text.dart';

const String _line = 'one two three four five six seven eight nine ten';
const Color _ink = Color(0xFF000000);

/// A 600 px tall scroll view with [gap] of empty space above the text.
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
                const ScrollHighlightText(
                  _line,
                  style: TextStyle(fontSize: 20, color: _ink),
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

/// How many words are drawn at full ink.
int _lit(WidgetTester tester) {
  final line = tester.widget<Text>(find.byType(Text)).textSpan! as TextSpan;
  final words = line.children!.cast<TextSpan>();
  return words.where((word) => word.style!.color == _ink).length;
}

void main() {
  testWidgets('reads as the plain line', (tester) async {
    await _pump(tester, gap: 1000);
    expect(find.text(_line), findsOneWidget);
  });

  testWidgets('starts dim below the reading band', (tester) async {
    await _pump(tester, gap: 1000);
    expect(_lit(tester), 0);
  });

  testWidgets('lights word by word as it scrolls up, and dims going back', (
    tester,
  ) async {
    final controller = await _pump(tester, gap: 1000);

    // Centre at about 1012 - 600 = 412 of 600: partway through the band.
    controller.jumpTo(600);
    await tester.pump();
    final partway = _lit(tester);
    expect(partway, inExclusiveRange(0, 10));

    controller.jumpTo(800);
    await tester.pump();
    expect(_lit(tester), 10);

    controller.jumpTo(600);
    await tester.pump();
    expect(_lit(tester), partway);
  });

  testWidgets('is fully lit when the platform asks for less motion', (
    tester,
  ) async {
    await _pump(tester, gap: 1000, reduceMotion: true);
    expect(_lit(tester), 10);
  });
}
