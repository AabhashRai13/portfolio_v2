import 'package:my_portfolio/features/home/presentation/models/home_section.dart';

class HomeNavigationTarget {
  const HomeNavigationTarget._({
    this.section,
    this.route,
    this.externalUrl,
  });

  const HomeNavigationTarget.scroll(HomeSection section)
    : this._(section: section);

  const HomeNavigationTarget.route(String route) : this._(route: route);

  const HomeNavigationTarget.external(String externalUrl)
    : this._(externalUrl: externalUrl);

  final HomeSection? section;
  final String? route;
  final String? externalUrl;
}
