import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:my_portfolio/constants/sns_links.dart';
import 'package:my_portfolio/core/services/analytics_app_launch_service.dart';
import 'package:my_portfolio/core/services/app_launch_service.dart';
import 'package:my_portfolio/core/services/site_analytics_service.dart';

void main() {
  late _RecordingInner inner;
  late _RecordingAnalytics analytics;
  late AnalyticsAppLaunchService service;

  setUp(() {
    inner = _RecordingInner();
    analytics = _RecordingAnalytics();
    service = AnalyticsAppLaunchService(inner: inner, analytics: analytics);
  });

  test('always opens the url through the wrapped launcher', () async {
    await service.openExternalUrl(SnsLinks.github);

    expect(inner.opened, <String>[SnsLinks.github]);
  });

  test('logs a named outbound click for known social links', () async {
    await service.openExternalUrl(SnsLinks.linkedIn);

    expect(analytics.outbound, <String>['linkedin']);
    expect(analytics.cvOpened, 0);
  });

  test('falls back to the host for unknown outbound links', () async {
    await service.openExternalUrl('https://news.ycombinator.com/item?id=1');

    expect(analytics.outbound, <String>['news.ycombinator.com']);
  });

  test('logs the resume as a distinct cv_opened event', () async {
    await service.openExternalUrl(SnsLinks.resume);

    expect(analytics.cvOpened, 1);
    expect(analytics.outbound, isEmpty);
    expect(inner.opened, <String>[SnsLinks.resume]);
  });
}

class _RecordingInner implements AppLaunchService {
  final List<String> opened = <String>[];

  @override
  Future<void> openExternalUrl(String url) async => opened.add(url);
}

class _RecordingAnalytics extends SiteAnalyticsService {
  _RecordingAnalytics()
    : super(
        analytics: () =>
            throw FirebaseException(plugin: 'core', code: 'no-app'),
      );

  final List<String> outbound = <String>[];
  int cvOpened = 0;

  @override
  Future<void> logOutboundClick(String destination) async =>
      outbound.add(destination);

  @override
  Future<void> logCvOpened() async => cvOpened++;
}
