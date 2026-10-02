import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:my_portfolio/core/resources/styles/dark_theme.dart';
import 'package:my_portfolio/core/resources/styles/theme.dart';
import 'package:my_portfolio/features/contact/presentation/views/contact_panel.dart';

import '../../../helpers/site_test_harness.dart';

void main() {
  setUp(registerSiteFakes);

  // Pages theme themselves below a light MaterialApp, so [pageTheme] mirrors
  // a dark-mode route.
  Future<void> openPanel(WidgetTester tester, {ThemeData? pageTheme}) async {
    await tester.pumpWidget(
      MaterialApp(
        theme: kLightTheme,
        home: Theme(
          data: pageTheme ?? kLightTheme,
          child: Scaffold(
            body: Builder(
              builder: (context) => TextButton(
                onPressed: () => unawaited(showContactPanel(context)),
                child: const Text('open'),
              ),
            ),
          ),
        ),
      ),
    );
    await tester.tap(find.text('open'));
    await tester.pumpAndSettle();
  }

  testWidgets('desktop opens a side panel with the form and closes it', (
    tester,
  ) async {
    setViewSize(tester, const Size(1440, 900));
    await openPanel(tester);

    expect(find.text('Aabhash Rai'), findsOneWidget);
    expect(find.text('Send message'), findsOneWidget);

    await tester.tap(find.byTooltip('Close'));
    await tester.pumpAndSettle();
    expect(find.text('Send message'), findsNothing);
  });

  testWidgets('desktop Esc closes the panel', (tester) async {
    setViewSize(tester, const Size(1440, 900));
    await openPanel(tester);
    expect(find.text('Send message'), findsOneWidget);

    await tester.sendKeyEvent(LogicalKeyboardKey.escape);
    await tester.pumpAndSettle();
    expect(find.text('Send message'), findsNothing);
  });

  testWidgets('desktop tapping outside the panel closes it', (tester) async {
    setViewSize(tester, const Size(1440, 900));
    await openPanel(tester);
    expect(find.text('Send message'), findsOneWidget);

    await tester.tapAt(const Offset(20, 450));
    await tester.pumpAndSettle();
    expect(find.text('Send message'), findsNothing);
  });

  for (final (label, size) in const [
    ('desktop', Size(1440, 900)),
    ('mobile', Size(390, 844)),
  ]) {
    testWidgets('$label panel follows the page theme', (tester) async {
      setViewSize(tester, size);
      await openPanel(tester, pageTheme: kDarkTheme);

      final panelTheme = Theme.of(tester.element(find.text('Send message')));
      expect(panelTheme.brightness, Brightness.dark);
    });
  }

  testWidgets('mobile opens a bottom sheet with the form', (tester) async {
    setViewSize(tester, const Size(390, 844));
    await openPanel(tester);

    expect(find.byType(BottomSheet), findsOneWidget);
    expect(find.text('Send message'), findsOneWidget);
  });
}
