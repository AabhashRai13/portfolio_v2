import 'package:firebase_analytics/firebase_analytics.dart';

/// Site-wide GA4 events. Blog-specific events live in BlogAnalyticsService.
class SiteAnalyticsService {
  const SiteAnalyticsService({
    required FirebaseAnalytics Function() analytics,
    Future<void> Function()? ready,
  }) : _analytics = analytics,
       _ready = ready;

  // Resolved per call: Firebase may not be up when this is created.
  final FirebaseAnalytics Function() _analytics;

  // Startup events (the first screen_view) can fire before Firebase warms up;
  // awaiting this lets them land instead of being dropped.
  final Future<void> Function()? _ready;

  Future<void> logScreenView(String screenName) async {
    await _safe(() => _analytics().logScreenView(screenName: screenName));
  }

  Future<void> logOutboundClick(String destination) async {
    await _safe(
      () => _analytics().logEvent(
        name: 'outbound_click',
        parameters: <String, Object>{'destination': destination},
      ),
    );
  }

  Future<void> logCvOpened() async {
    await _safe(() => _analytics().logEvent(name: 'cv_opened'));
  }

  Future<void> logContactSubmitted() async {
    await _safe(() => _analytics().logEvent(name: 'contact_submitted'));
  }

  Future<void> _safe(Future<void> Function() log) async {
    try {
      await _ready?.call();
      await log();
    } on Exception {
      // Analytics should never block or break a user action.
    }
  }
}
