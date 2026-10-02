import 'package:flutter/gestures.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:my_portfolio/features/landing/presentation/controllers/landing_phone_motion_controller.dart';

void main() {
  testWidgets('lock holds the hover pose and ignores drag and hover exit', (
    tester,
  ) async {
    final motion = LandingPhoneMotionController(vsync: const TestVSync());
    addTearDown(motion.dispose);

    motion.setLocked(isLocked: true);
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 600));
    expect(motion.locked, isTrue);
    expect(motion.emphasis.value, 1);

    motion
      ..onPanStart(DragStartDetails())
      ..onPanUpdate(
        DragUpdateDetails(
          globalPosition: const Offset(40, 10),
          delta: const Offset(40, 10),
        ),
      );
    expect(motion.offset, Offset.zero);

    motion.setHovered(isHovered: false);
    await tester.pump(const Duration(milliseconds: 600));
    expect(motion.emphasis.value, 1);

    motion.setLocked(isLocked: false);
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 600));
    expect(motion.locked, isFalse);
    expect(motion.emphasis.value, 0);

    // Stop the idle float so no ticker outlives the test.
    motion.setEnabled(isEnabled: false);
  });

  testWidgets('lock keeps the phone facing forward while motion is off', (
    tester,
  ) async {
    final motion = LandingPhoneMotionController(vsync: const TestVSync());
    addTearDown(motion.dispose);

    motion.setLocked(isLocked: true);
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 600));

    // A theme menu or another page covers the landing route, then leaves.
    motion.setEnabled(isEnabled: false);
    expect(motion.emphasis.value, 1);
    motion.setEnabled(isEnabled: true);
    await tester.pump(const Duration(seconds: 2));
    expect(motion.emphasis.value, 1);
    expect(motion.offset, Offset.zero);

    // Leaving desktop unlocks while motion is off: the pose still resets.
    motion
      ..setEnabled(isEnabled: false)
      ..setLocked(isLocked: false);
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 600));
    expect(motion.emphasis.value, 0);

    // Reduced motion: opening the form still faces the phone forward.
    motion.setLocked(isLocked: true);
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 600));
    expect(motion.emphasis.value, 1);
  });
}
