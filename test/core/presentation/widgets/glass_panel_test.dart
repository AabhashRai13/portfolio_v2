import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:my_portfolio/core/presentation/widgets/glass_panel.dart';
import 'package:my_portfolio/core/resources/styles/theme.dart';

void main() {
  Future<void> pump(WidgetTester tester, GlassPanel panel) => tester.pumpWidget(
    MaterialApp(
      theme: kLightTheme,
      home: Center(child: SizedBox.square(dimension: 200, child: panel)),
    ),
  );

  testWidgets('frames its child with the given corner radius', (tester) async {
    await pump(tester, const GlassPanel(radius: 36, child: Text('inside')));

    expect(find.text('inside'), findsOneWidget);
    final border = tester
        .widgetList<DecoratedBox>(find.byType(DecoratedBox))
        .map((box) => box.decoration)
        .whereType<BoxDecoration>()
        .firstWhere((decoration) => decoration.border != null);
    expect(border.borderRadius, BorderRadius.circular(36));
    expect(find.byType(ClipRRect), findsNothing);
  });

  testWidgets('clips its child to the corners when asked', (tester) async {
    await pump(tester, const GlassPanel(clip: true, child: Text('inside')));

    final clip = tester.widget<ClipRRect>(find.byType(ClipRRect));
    expect(clip.borderRadius, BorderRadius.circular(20));
  });
}
