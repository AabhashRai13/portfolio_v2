import 'package:my_portfolio/constants/sns_links.dart';
import 'package:my_portfolio/core/services/app_launch_service.dart';

/// Drives the interactive actions on the resume page: opening the email/phone
/// handlers, social links, and downloading the hosted PDF.
class ResumeController {
  ResumeController({required AppLaunchService launchService})
    : _launchService = launchService;

  final AppLaunchService _launchService;

  Future<void> openEmail() =>
      _launchService.openExternalUrl('mailto:${SnsLinks.email}');

  Future<void> openPhone() =>
      _launchService.openExternalUrl('tel:${SnsLinks.phone}');

  Future<void> openLink(String url) => _launchService.openExternalUrl(url);

  Future<void> downloadResume() =>
      _launchService.openExternalUrl(SnsLinks.resumePdf);
}
