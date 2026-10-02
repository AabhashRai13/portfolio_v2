import 'dart:async';

import 'package:flutter/widgets.dart';

/// Sydney wall-clock time for [utc], e.g. `3:42:07 PM AEDT`. Daylight saving
/// (UTC+11) runs from 2am on the first Sunday of October to 3am on the first
/// Sunday of April; both switches fall at 16:00 UTC the Saturday before.
// ponytail: hard-coded NSW rule, add the timezone package if it ever changes.
String sydneyClockLabel(DateTime utc) {
  DateTime switchAt(int month) {
    final first = DateTime.utc(utc.year, month);
    final sunday = first.add(
      Duration(days: (DateTime.sunday - first.weekday) % 7),
    );
    return sunday.subtract(const Duration(hours: 8));
  }

  final dst = utc.isBefore(switchAt(4)) || !utc.isBefore(switchAt(10));
  final local = utc.add(Duration(hours: dst ? 11 : 10));
  final hour = local.hour % 12 == 0 ? 12 : local.hour % 12;
  String twoDigits(int value) => value.toString().padLeft(2, '0');
  final period = local.hour < 12 ? 'AM' : 'PM';
  return '$hour:${twoDigits(local.minute)}:${twoDigits(local.second)} '
      '$period ${dst ? 'AEDT' : 'AEST'}';
}

/// Live `SYDNEY · 3:42:07 PM AEDT` label. Ticks twice a second so the
/// seconds never visibly skip.
class SydneyClock extends StatefulWidget {
  const SydneyClock({required this.style, super.key});

  final TextStyle style;

  @override
  State<SydneyClock> createState() => _SydneyClockState();
}

class _SydneyClockState extends State<SydneyClock> {
  late final Timer _timer;

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(
      const Duration(milliseconds: 500),
      (_) => setState(() {}),
    );
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Text(
    'SYDNEY · ${sydneyClockLabel(DateTime.now().toUtc())}',
    style: widget.style,
  );
}
