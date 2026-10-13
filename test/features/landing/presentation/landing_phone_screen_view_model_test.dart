import 'package:flutter_test/flutter_test.dart';
import 'package:my_portfolio/app/navigation/site_navigation.dart';
import 'package:my_portfolio/features/landing/presentation/controllers/landing_phone_motion_controller.dart';
import 'package:my_portfolio/features/landing/presentation/controllers/landing_phone_screen_view_model.dart';

void main() {
  late LandingPhoneMotionController motion;

  setUp(() {
    motion = LandingPhoneMotionController(vsync: const TestVSync());
    addTearDown(motion.dispose);
  });

  /// Lets lock and unlock animations finish, then stops the idle float so
  /// no ticker outlives the test.
  Future<void> settle(WidgetTester tester) async {
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 600));
    motion.setEnabled(isEnabled: false);
  }

  testWidgets('opening contact holds the phone still', (tester) async {
    final screen = LandingPhoneScreenViewModel(motion: motion);
    addTearDown(screen.dispose);
    var notified = 0;
    screen
      ..addListener(() => notified++)
      ..openContact()
      ..openContact();

    expect(screen.contactOpen, isTrue);
    expect(motion.locked, isTrue);
    expect(notified, 1);
    await settle(tester);
  });

  testWidgets('closing contact frees the phone again', (tester) async {
    final screen = LandingPhoneScreenViewModel(motion: motion);
    addTearDown(screen.dispose);
    screen
      ..openContact()
      ..closeContact();

    expect(screen.contactOpen, isFalse);
    expect(motion.locked, isFalse);
    await settle(tester);
  });

  testWidgets('Contact opens in the phone; other tiles go to their page', (
    tester,
  ) async {
    final screen = LandingPhoneScreenViewModel(motion: motion);
    addTearDown(screen.dispose);
    final navigated = <SiteSection>[];

    for (final section in SiteSection.values) {
      screen.open(section, navigate: navigated.add);
    }
    expect(navigated, [
      SiteSection.work,
      SiteSection.about,
      SiteSection.writing,
    ]);
    expect(screen.contactOpen, isTrue);
    await settle(tester);
  });

  testWidgets('going away with contact open frees the phone', (tester) async {
    // The motion controller outlives the screen, e.g. resizing to mobile.
    LandingPhoneScreenViewModel(motion: motion)
      ..openContact()
      ..dispose();
    expect(motion.locked, isFalse);
    await settle(tester);
  });

  testWidgets('going away with contact closed leaves the phone alone', (
    tester,
  ) async {
    motion.setLocked(isLocked: true);
    LandingPhoneScreenViewModel(motion: motion).dispose();
    expect(motion.locked, isTrue);
    await settle(tester);
  });
}
