import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:my_portfolio/core/resources/styles/theme.dart';
import 'package:my_portfolio/features/contact/presentation/views/contact_panel.dart';

import '../../../helpers/site_test_harness.dart';

void main() {
  setUp(registerSiteFakes);

  Future<void> openPanel(WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        theme: kLightTheme,
        home: Scaffold(
          body: Builder(
            builder: (context) => TextButton(
              onPressed: () => unawaited(showContactPanel(context)),
              child: const Text('open'),
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

  testWidgets('mobile opens a bottom sheet with the form', (tester) async {
    setViewSize(tester, const Size(390, 844));
    await openPanel(tester);

    expect(find.byType(BottomSheet), findsOneWidget);
    expect(find.text('Send message'), findsOneWidget);
  });
}
