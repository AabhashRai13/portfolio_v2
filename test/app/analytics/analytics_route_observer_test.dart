import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:my_portfolio/app/analytics/analytics_route_observer.dart';
import 'package:my_portfolio/core/services/site_analytics_service.dart';

void main() {
  late _RecordingAnalytics analytics;
  late AnalyticsRouteObserver observer;

  setUp(() {
    analytics = _RecordingAnalytics();
    observer = AnalyticsRouteObserver(analytics);
  });

  test('logs a screen view for the pushed route name', () {
    observer.didPush(_route('/about'), null);

    expect(analytics.screens, <String>['/about']);
  });

  test('logs a screen view for the replacing route name', () {
    observer.didReplace(newRoute: _route('/work'), oldRoute: _route('/'));

    expect(analytics.screens, <String>['/work']);
  });

  test('ignores routes without a name', () {
    observer.didPush(_route(null), null);

    expect(analytics.screens, isEmpty);
  });
}

Route<void> _route(String? name) => MaterialPageRoute<void>(
  settings: RouteSettings(name: name),
  builder: (_) => const SizedBox.shrink(),
);

class _RecordingAnalytics extends SiteAnalyticsService {
  _RecordingAnalytics()
    : super(
        analytics: () =>
            throw FirebaseException(plugin: 'core', code: 'no-app'),
      );

  final List<String> screens = <String>[];

  @override
  Future<void> logScreenView(String screenName) async =>
      screens.add(screenName);
}
