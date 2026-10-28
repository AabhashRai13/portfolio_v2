import 'dart:async';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:my_portfolio/core/services/site_analytics_service.dart';

void main() {
  test('waits for Firebase readiness before touching analytics', () async {
    final events = <String>[];
    final gate = Completer<void>();
    final service = SiteAnalyticsService(
      analytics: () {
        events.add('resolved');
        throw FirebaseException(plugin: 'core', code: 'no-app');
      },
      ready: () async {
        events.add('ready');
        await gate.future;
      },
    );

    final logged = service.logScreenView('/');
    await Future<void>.delayed(Duration.zero);
    // Still parked on readiness: analytics must not be touched yet.
    expect(events, <String>['ready']);

    gate.complete();
    await logged;
    expect(events, <String>['ready', 'resolved']);
  });

  group('logs quietly before Firebase is up', () {
    final calls = <String, Future<void> Function(SiteAnalyticsService)>{
      'logScreenView': (a) => a.logScreenView('/about'),
      'logOutboundClick': (a) => a.logOutboundClick('github'),
      'logCvOpened': (a) => a.logCvOpened(),
      'logContactSubmitted': (a) => a.logContactSubmitted(),
    };
    for (final entry in calls.entries) {
      test(
        '${entry.key} resolves analytics lazily and swallows the throw',
        () async {
          var resolved = false;
          final analytics = SiteAnalyticsService(
            analytics: () {
              resolved = true;
              throw FirebaseException(plugin: 'core', code: 'no-app');
            },
          );
          expect(resolved, isFalse);

          await entry.value(analytics);

          expect(resolved, isTrue);
        },
      );
    }
  });
}
