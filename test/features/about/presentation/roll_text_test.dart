import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:my_portfolio/features/about/presentation/widgets/roll_text.dart';

const _label = 'TELL ME';
final Finder _roll = find.byKey(RollText.rollKey);

Widget _page({required bool active, bool reduceMotion = false}) {
  return MaterialApp(
    builder: (context, child) => MediaQuery(
      data: MediaQuery.of(context).copyWith(disableAnimations: reduceMotion),
      child: child!,
    ),
    home: Center(
      child: RollText(
        _label,
        style: const TextStyle(fontSize: 40),
        active: active,
      ),
    ),
  );
}

/// How far each letter has rolled out of its slot, left to right.
List<double> _rolledOut(WidgetTester tester) => tester
    .widgetList<FractionalTranslation>(
      find.descendant(of: _roll, matching: find.byType(FractionalTranslation)),
    )
    .map((rise) => rise.translation.dy)
    .where((dy) => dy <= 0) // the outgoing letters; copies sit below at > 0
    .map((dy) => -dy)
    .toList();

void main() {
  testWidgets('rests as one plain line of text', (tester) async {
    await tester.pumpWidget(_page(active: false));
    expect(_roll, findsNothing);
    expect(find.text(_label), findsOneWidget);
  });

  testWidgets('rolls letter by letter when it turns active, then rests', (
    tester,
  ) async {
    await tester.pumpWidget(_page(active: false));
    await tester.pumpWidget(_page(active: true));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 150));

    expect(_roll, findsOneWidget);
    final rolled = _rolledOut(tester);
    // Seven characters, the space included.
    expect(rolled, hasLength(7));
    expect(rolled.first, greaterThan(rolled.last));

    await tester.pumpAndSettle();
    expect(_roll, findsNothing);
    expect(find.text(_label), findsOneWidget);
  });

  testWidgets('screen readers hear the label once while it rolls', (
    tester,
  ) async {
    final semantics = tester.ensureSemantics();
    await tester.pumpWidget(_page(active: false));
    await tester.pumpWidget(_page(active: true));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 150));

    expect(find.bySemanticsLabel(_label), findsOneWidget);
    await tester.pumpAndSettle();
    semantics.dispose();
  });

  testWidgets('never rolls when the platform asks for less motion', (
    tester,
  ) async {
    await tester.pumpWidget(_page(active: false, reduceMotion: true));
    await tester.pumpWidget(_page(active: true, reduceMotion: true));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 150));
    expect(_roll, findsNothing);
  });
}
