import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:my_portfolio/core/services/app_launch_service.dart';
import 'package:my_portfolio/features/contact/domain/models/contact_message.dart';
import 'package:my_portfolio/features/contact/domain/repositories/contact_repository.dart';
import 'package:my_portfolio/features/contact/presentation/controllers/contact_controller.dart';
import 'package:my_portfolio/features/contact/presentation/views/contact_section_view.dart';

void main() {
  testWidgets('renders contact section smoke test', (
    WidgetTester tester,
  ) async {
    final controller = ContactController(
      contactRepository: _WidgetFakeContactRepository(),
      launchService: const _WidgetFakeLaunchService(),
    );
    addTearDown(controller.dispose);

    tester.view.physicalSize = const Size(1600, 2000);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.reset);

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: ContactSection(controller: controller),
        ),
      ),
    );

    expect(find.text('Send Message'), findsOneWidget);
    expect(find.text('Get In Touch'), findsOneWidget);
  });
}

class _WidgetFakeContactRepository implements ContactRepository {
  @override
  Future<void> submitContactMessage(ContactMessage message) async {}
}

class _WidgetFakeLaunchService implements AppLaunchService {
  const _WidgetFakeLaunchService();

  @override
  Future<void> openExternalUrl(String url) async {}
}
