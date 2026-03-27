import 'package:flutter/material.dart';
import 'package:my_portfolio/app/router/app_routes.dart';
import 'package:my_portfolio/constants/sns_links.dart';
import 'package:my_portfolio/core/resources/utils/static_utils.dart';
import 'package:my_portfolio/core/services/app_launch_service.dart';
import 'package:my_portfolio/features/home/presentation/models/home_navigation_item.dart';
import 'package:my_portfolio/features/home/presentation/models/home_navigation_target.dart';
import 'package:my_portfolio/features/home/presentation/models/home_section.dart';
import 'package:my_portfolio/features/projects/domain/models/project_summary.dart';
import 'package:my_portfolio/features/projects/domain/repositories/projects_repository.dart';

class HomeController {
  HomeController({
    required AppLaunchService launchService,
    required ProjectsRepository projectsRepository,
  }) : _launchService = launchService,
       _projectsRepository = projectsRepository;

  final AppLaunchService _launchService;
  final ProjectsRepository _projectsRepository;

  static const navigationItems = <HomeNavigationItem>[
    HomeNavigationItem(
      title: 'Home',
      icon: Icons.home,
      target: HomeNavigationTarget.scroll(HomeSection.hero),
    ),
    HomeNavigationItem(
      title: 'Skills',
      icon: Icons.handyman_outlined,
      target: HomeNavigationTarget.scroll(HomeSection.skills),
    ),
    HomeNavigationItem(
      title: 'Video Intro',
      icon: Icons.video_call,
      target: HomeNavigationTarget.scroll(HomeSection.introVideo),
    ),
    HomeNavigationItem(
      title: 'Projects',
      icon: Icons.quick_contacts_mail,
      target: HomeNavigationTarget.scroll(HomeSection.portfolio),
    ),
    HomeNavigationItem(
      title: 'Contact',
      icon: Icons.web,
      target: HomeNavigationTarget.scroll(HomeSection.contact),
    ),
    HomeNavigationItem(
      title: 'Blog',
      icon: Icons.article_outlined,
      target: HomeNavigationTarget.route(AppRoutes.blog),
    ),
    HomeNavigationItem(
      title: 'Resume',
      icon: Icons.description_outlined,
      target: HomeNavigationTarget.external(SnsLinks.resume),
    ),
  ];

  late final List<ProjectSummary> featuredProjects = _projectsRepository
      .getFeaturedProjects();

  HomeNavigationTarget handleNavigationSelection(HomeNavigationItem item) {
    return item.target;
  }

  Future<void> openResume() {
    return _launchService.openExternalUrl(SnsLinks.resume);
  }

  HomeNavigationTarget scrollToContact() {
    return const HomeNavigationTarget.scroll(HomeSection.contact);
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
}
