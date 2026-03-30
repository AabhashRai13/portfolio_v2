import 'package:flutter_test/flutter_test.dart';
import 'package:my_portfolio/features/home/presentation/services/home_wheel_scroll_coordinator.dart';

void main() {
  group('HomeWheelScrollCoordinator', () {
    test('clamps target offset within scroll extents', () {
      final coordinator = HomeWheelScrollCoordinator(
        clock: _clockFrom(<DateTime>[
          DateTime(2026, 3, 27, 12),
        ]),
      );

      final target = coordinator.updateTargetOffset(
        currentOffset: 900,
        minOffset: 0,
        maxOffset: 1000,
        scrollDelta: 200,
      );

      expect(target, 1000);
    });

    test('accumulates rapid wheel bursts from prior target', () {
      final coordinator = HomeWheelScrollCoordinator(
        clock: _clockFrom(<DateTime>[
          DateTime(2026, 3, 27, 12),
          DateTime(2026, 3, 27, 12).add(const Duration(milliseconds: 80)),
        ]),
      );

      final firstTarget = coordinator.updateTargetOffset(
        currentOffset: 100,
        minOffset: 0,
        maxOffset: 1000,
        scrollDelta: 100,
      );
      final secondTarget = coordinator.updateTargetOffset(
        currentOffset: 140,
        minOffset: 0,
        maxOffset: 1000,
        scrollDelta: 100,
      );

      expect(firstTarget, closeTo(215, 0.001));
      expect(secondTarget, closeTo(330, 0.001));
    });

    test('resets accumulation after burst window expires', () {
      final coordinator = HomeWheelScrollCoordinator(
        clock: _clockFrom(<DateTime>[
          DateTime(2026, 3, 27, 12),
          DateTime(2026, 3, 27, 12).add(const Duration(milliseconds: 400)),
        ]),
      );

      final initialTarget = coordinator.updateTargetOffset(
        currentOffset: 100,
        minOffset: 0,
        maxOffset: 1000,
        scrollDelta: 100,
      );
      final nextTarget = coordinator.updateTargetOffset(
        currentOffset: 500,
        minOffset: 0,
        maxOffset: 1000,
        scrollDelta: 100,
      );

      expect(initialTarget, closeTo(215, 0.001));
      expect(nextTarget, closeTo(615, 0.001));
    });

    test('ignores tiny wheel deltas below threshold', () {
      final coordinator = HomeWheelScrollCoordinator(
        minimumDeltaThreshold: 8,
        clock: _clockFrom(<DateTime>[
          DateTime(2026, 3, 27, 12),
        ]),
      );

      final target = coordinator.updateTargetOffset(
        currentOffset: 240,
        minOffset: 0,
        maxOffset: 1000,
        scrollDelta: 5,
      );

      expect(target, 240);
    });

    test('derives longer durations for larger distances', () {
      final coordinator = HomeWheelScrollCoordinator();

      final shortDuration = coordinator.animationDurationFor(
        currentOffset: 100,
        targetOffset: 160,
      );
      final longDuration = coordinator.animationDurationFor(
        currentOffset: 100,
        targetOffset: 580,
      );

      expect(longDuration, greaterThan(shortDuration));
    });
  });
}

DateTime Function() _clockFrom(List<DateTime> values) {
  var index = 0;

  return () {
    final safeIndex = index < values.length ? index : values.length - 1;
    final value = values[safeIndex];
    index++;
    return value;
  };
}
