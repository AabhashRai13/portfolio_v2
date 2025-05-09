import 'package:url_launcher/url_launcher.dart';

class UrlLauncherServices {
// URL Launcher
  void openURL(String url) => launchUrl(
        Uri.parse(url),
      );

// Tools & Tech
  final kTools = ["Flutter", "Dart", "Firebase", "Node", "Express"];
}
