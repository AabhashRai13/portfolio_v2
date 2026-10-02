import 'package:flutter_test/flutter_test.dart';
import 'package:my_portfolio/features/about/presentation/widgets/sydney_clock.dart';

void main() {
  test('switches to AEDT at 2am on the first Sunday of October', () {
    expect(
      sydneyClockLabel(DateTime.utc(2026, 10, 3, 15, 59)),
      '1:59:00 AM AEST',
    );
    expect(sydneyClockLabel(DateTime.utc(2026, 10, 3, 16)), '3:00:00 AM AEDT');
  });

  test('switches back to AEST at 3am on the first Sunday of April', () {
    expect(
      sydneyClockLabel(DateTime.utc(2026, 4, 4, 15, 59)),
      '2:59:00 AM AEDT',
    );
    expect(sydneyClockLabel(DateTime.utc(2026, 4, 4, 16)), '2:00:00 AM AEST');
  });

  test('shows seconds so visitors see it is live', () {
    expect(
      sydneyClockLabel(DateTime.utc(2026, 7, 1, 5, 42, 7)),
      '3:42:07 PM AEST',
    );
  });

  test('formats noon, midnight and summer across the new year', () {
    expect(
      sydneyClockLabel(DateTime.utc(2026, 7, 1, 2, 5)),
      '12:05:00 PM AEST',
    );
    expect(sydneyClockLabel(DateTime.utc(2026, 7, 1, 14)), '12:00:00 AM AEST');
    expect(
      sydneyClockLabel(DateTime.utc(2026, 12, 31, 13)),
      '12:00:00 AM AEDT',
    );
  });
}
