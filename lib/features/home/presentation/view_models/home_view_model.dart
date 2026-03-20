import 'package:flutter/foundation.dart';
import 'package:my_portfolio/constants/sns_links.dart';
import 'package:my_portfolio/core/services/app_launch_service.dart';
import 'package:my_portfolio/features/content/domain/repositories/content_repository.dart';
import 'package:my_portfolio/features/home/presentation/models/home_section.dart';
import 'package:my_portfolio/features/portfolio/domain/models/project_summary.dart';
import 'package:my_portfolio/utils/static_utils.dart';

class HomeViewModel extends ChangeNotifier {
  HomeViewModel({
    required AppLaunchService launchService,
    required ContentRepository contentRepository,
  })  : _launchService = launchService,
        featuredProjects = contentRepository.getFeaturedProjects();

  final AppLaunchService _launchService;
  final List<ProjectSummary> featuredProjects;

  Future<void> handleNavigationSelection(
    int navIndex, {
    required void Function(HomeSection section) scrollToSection,
  }) async {
    if (navIndex == 5) {
      await openResume();
      return;
    }

    final section = switch (navIndex) {
      0 => HomeSection.hero,
      1 => HomeSection.skills,
      2 => HomeSection.introVideo,
      3 => HomeSection.portfolio,
      _ => HomeSection.contact,
    };

    scrollToSection(section);
  }

  void scrollToContact({
    required void Function(HomeSection section) scrollToSection,
  }) {
    scrollToSection(HomeSection.contact);
  }

  Future<void> openProject(ProjectSummary project) {
    return _launchService.openExternalUrl(project.link);
  }

  Future<void> openPortfolioSource() {
    return _launchService.openExternalUrl(StaticUtils.gitHub);
  }

  Future<void> openSocialLink(String url) {
    return _launchService.openExternalUrl(url);
  }

  Future<void> openResume() {
    return _launchService.openExternalUrl(SnsLinks.resume);
  }
}
