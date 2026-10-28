import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:my_portfolio/core/services/site_analytics_service.dart';

/// Logs a GA4 screen_view on each route change. Flutter web SPAs don't fire
/// page_view on navigation, so without this GA4 only ever sees the first page.
class AnalyticsRouteObserver extends NavigatorObserver {
  AnalyticsRouteObserver(this._analytics);

  final SiteAnalyticsService _analytics;

  @override
  void didPush(Route<dynamic> route, Route<dynamic>? previousRoute) {
    super.didPush(route, previousRoute);
    _log(route);
  }

  @override
  void didReplace({Route<dynamic>? newRoute, Route<dynamic>? oldRoute}) {
    super.didReplace(newRoute: newRoute, oldRoute: oldRoute);
    if (newRoute != null) _log(newRoute);
  }

  void _log(Route<dynamic> route) {
    final name = route.settings.name;
    if (name != null && name.isNotEmpty) {
      unawaited(_analytics.logScreenView(name));
    }
  }
}
