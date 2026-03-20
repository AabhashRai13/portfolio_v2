import 'package:url_launcher/url_launcher.dart';

// This abstraction is intentional so app features depend on an injectable
// launcher contract instead of a concrete plugin.
// ignore: one_member_abstracts
abstract class AppLaunchService {
  Future<void> openExternalUrl(String url);
}

class UrlLauncherAppLaunchService implements AppLaunchService {
  const UrlLauncherAppLaunchService();

  @override
  Future<void> openExternalUrl(String url) async {
    final uri = Uri.parse(url);
    final launched = await launchUrl(
      uri,
      webOnlyWindowName: '_blank',
    );

    if (!launched) {
      throw Exception('Unable to open $url');
    }
  }
}
