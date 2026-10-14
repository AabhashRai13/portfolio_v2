import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:my_portfolio/core/resources/styles/theme.dart';
import 'package:my_portfolio/core/services/app_launch_service.dart';
import 'package:my_portfolio/features/contact/domain/models/contact_message.dart';
import 'package:my_portfolio/features/contact/domain/models/contact_topic.dart';
import 'package:my_portfolio/features/contact/domain/repositories/contact_repository.dart';
import 'package:my_portfolio/features/contact/presentation/controllers/contact_controller.dart';
import 'package:my_portfolio/features/contact/presentation/views/contact_section_view.dart';

void main() {
  late _RecordingRepository repository;

  Future<void> pumpForm(WidgetTester tester) async {
    repository = _RecordingRepository();
    final controller = ContactController(
      contactRepository: repository,
      launchService: const _NoopLaunchService(),
    );
    addTearDown(controller.dispose);
    tester.view.physicalSize = const Size(400, 1000);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);

    await tester.pumpWidget(
      MaterialApp(
        theme: kLightTheme,
        home: Scaffold(
          body: SingleChildScrollView(
            child: ContactSection(controller: controller),
          ),
        ),
      ),
    );
  }

  Future<void> tapSend(WidgetTester tester) async {
    final send = find.text('Send message');
    await tester.ensureVisible(send);
    await tester.tap(send);
    await tester.pumpAndSettle();
  }

  testWidgets('opens as a chat with topic chips and no phone field', (
    tester,
  ) async {
    await pumpForm(tester);

    expect(find.text('Hey! What are you building?'), findsOneWidget);
    for (final topic in ContactTopic.values) {
      expect(find.text(topic.label), findsOneWidget);
    }
    expect(find.text('WHERE CAN I REPLY?'), findsOneWidget);
    expect(find.text('Send message'), findsOneWidget);
    expect(
      find.textContaining(RegExp('phone', caseSensitive: false)),
      findsNothing,
    );
  });

  testWidgets('an empty send shows friendly errors and sends nothing', (
    tester,
  ) async {
    await pumpForm(tester);

    await tapSend(tester);
    expect(find.text('Tell me a little about it.'), findsOneWidget);
    expect(find.text('What should I call you?'), findsOneWidget);
    expect(find.text('I need this to reply.'), findsOneWidget);
    expect(repository.sent, isEmpty);
  });

  testWidgets('a mistyped email gets a friendly message', (tester) async {
    await pumpForm(tester);

    await tester.enterText(find.byKey(ContactSection.emailFieldKey), 'nope');
    await tapSend(tester);
    expect(find.text("That email doesn't look right."), findsOneWidget);
  });

  testWidgets('the chosen topic leads the message and success replaces '
      'the form until starting another', (tester) async {
    await pumpForm(tester);

    await tester.tap(find.text(ContactTopic.fixApp.label));
    await tester.pump();
    await tester.enterText(
      find.byKey(ContactSection.messageFieldKey),
      'It crashes on launch',
    );
    await tester.enterText(find.byKey(ContactSection.nameFieldKey), 'Sam');
    await tester.enterText(
      find.byKey(ContactSection.emailFieldKey),
      'sam@example.com',
    );
    await tapSend(tester);

    expect(
      repository.sent.single.message,
      'Topic: Fix my app\n\nIt crashes on launch',
    );
    expect(
      find.textContaining("I'll reply to sam@example.com"),
      findsOneWidget,
    );
    expect(find.text('Send message'), findsNothing);

    await tester.tap(find.text('SEND ANOTHER MESSAGE'));
    await tester.pumpAndSettle();
    expect(find.text('Send message'), findsOneWidget);
  });
}

class _RecordingRepository implements ContactRepository {
  final List<ContactMessage> sent = <ContactMessage>[];

  @override
  Future<void> submitContactMessage(ContactMessage message) async {
    sent.add(message);
  }
}

class _NoopLaunchService implements AppLaunchService {
  const _NoopLaunchService();

  @override
  Future<void> openExternalUrl(String url) async {}
}
