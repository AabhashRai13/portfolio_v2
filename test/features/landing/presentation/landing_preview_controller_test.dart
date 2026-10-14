import 'package:flutter_test/flutter_test.dart';
import 'package:my_portfolio/features/landing/presentation/controllers/landing_preview_controller.dart';

void main() {
  const loop = Duration(seconds: 4);

  testWidgets('plays twice, then rests on its final frame', (tester) async {
    final preview = LandingPreviewController(
      vsync: const TestVSync(),
      duration: loop,
    );
    addTearDown(preview.dispose);

    preview.sync(tickerEnabled: true, reduceMotion: false);
    await tester.pump();
    await tester.pump(loop * 1.5);
    expect(preview.animation.isAnimating, isTrue);

    await tester.pump(loop);
    expect(preview.animation.isAnimating, isFalse);
    expect(preview.animation.value, 1);
  });

  testWidgets('plays again when the landing comes back', (tester) async {
    final preview = LandingPreviewController(
      vsync: const TestVSync(),
      duration: loop,
    );
    addTearDown(preview.dispose);

    preview.sync(tickerEnabled: true, reduceMotion: false);
    await tester.pump();
    await tester.pump(loop * 3);

    preview
      ..sync(tickerEnabled: false, reduceMotion: false)
      ..sync(tickerEnabled: true, reduceMotion: false);
    await tester.pump();
    await tester.pump(loop * 0.5);
    expect(preview.animation.isAnimating, isTrue);

    preview.sync(tickerEnabled: false, reduceMotion: false);
  });
}
