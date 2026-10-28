import 'package:my_portfolio/constants/sns_links.dart';
import 'package:my_portfolio/core/services/app_launch_service.dart';
import 'package:my_portfolio/core/services/site_analytics_service.dart';

/// Wraps a launcher so every outbound link is recorded before it opens.
/// The resume is the one link worth its own event — it's the clearest
/// recruiter-intent signal.
class AnalyticsAppLaunchService implements AppLaunchService {
  const AnalyticsAppLaunchService({
    required AppLaunchService inner,
    required SiteAnalyticsService analytics,
  }) : _inner = inner,
       _analytics = analytics;

  final AppLaunchService _inner;
  final SiteAnalyticsService _analytics;

  @override
  Future<void> openExternalUrl(String url) async {
    await _log(url);
    await _inner.openExternalUrl(url);
  }

  Future<void> _log(String url) {
    if (url == SnsLinks.resume) {
      return _analytics.logCvOpened();
    }
    return _analytics.logOutboundClick(_destinationFor(url));
  }
}

/// A low-cardinality label for GA4: a known network name, else the host.
String _destinationFor(String url) {
  final host = Uri.tryParse(url)?.host.replaceFirst('www.', '') ?? '';
  const known = <String, String>{
    'github.com': 'github',
    'linkedin.com': 'linkedin',
    'instagram.com': 'instagram',
    'youtube.com': 'youtube',
    'youtu.be': 'youtube',
  };
  return known[host] ?? (host.isEmpty ? url : host);
}
