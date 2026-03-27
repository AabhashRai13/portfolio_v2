import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:my_portfolio/app/router/app_routes.dart';
import 'package:my_portfolio/constants/size.dart';
import 'package:my_portfolio/core/resources/asset_manager.dart';
import 'package:my_portfolio/core/resources/configs/app.dart';
import 'package:my_portfolio/features/contact/presentation/controllers/contact_controller.dart';
import 'package:my_portfolio/features/contact/presentation/views/contact_section_view.dart';
import 'package:my_portfolio/features/game/presentation/widgets/game_preview.dart';
import 'package:my_portfolio/features/home/presentation/controllers/home_controller.dart';
import 'package:my_portfolio/features/home/presentation/models/home_navigation_item.dart';
import 'package:my_portfolio/features/home/presentation/models/home_navigation_target.dart';
import 'package:my_portfolio/features/home/presentation/models/home_section.dart';
import 'package:my_portfolio/features/home/presentation/widgets/drawer_mobile.dart';
import 'package:my_portfolio/features/home/presentation/widgets/footer.dart';
import 'package:my_portfolio/features/home/presentation/widgets/header_desktop.dart';
import 'package:my_portfolio/features/home/presentation/widgets/header_mobile.dart';
import 'package:my_portfolio/features/home/presentation/widgets/main_desktop.dart';
import 'package:my_portfolio/features/home/presentation/widgets/main_mobile.dart';
import 'package:my_portfolio/features/home/presentation/widgets/youtube_player.dart';
import 'package:my_portfolio/features/projects/presentation/widgets/portfolio_section.dart';
import 'package:my_portfolio/features/skills/presentation/widgets/skills_section.dart';

class HomeMainPage extends StatefulWidget {
  const HomeMainPage({
    required this.homeController,
    required this.contactController,
    super.key,
  });

  final HomeController homeController;
  final ContactController contactController;

  @override
  State<HomeMainPage> createState() => _HomeMainPageState();
}

class _HomeMainPageState extends State<HomeMainPage> {
  late final HomeController _homeController;
  late final ContactController _contactController;
  final scaffoldKey = GlobalKey<ScaffoldState>();
  final scrollController = ScrollController();
  final Map<HomeSection, GlobalKey> _sectionKeys = <HomeSection, GlobalKey>{
    HomeSection.hero: GlobalKey(),
    HomeSection.skills: GlobalKey(),
    HomeSection.introVideo: GlobalKey(),
    HomeSection.portfolio: GlobalKey(),
    HomeSection.contact: GlobalKey(),
  };

  @override
  void initState() {
    super.initState();
    _homeController = widget.homeController;
    _contactController = widget.contactController;
  }

  @override
  void dispose() {
    scrollController.dispose();
    _contactController.dispose();
    super.dispose();
  }

  void _scrollToSection(HomeSection section) {
    final key = _sectionKeys[section];
    if (key?.currentContext == null) {
      return;
    }

    Scrollable.ensureVisible(
      key!.currentContext!,
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeInOut,
    );
  }

  void _handleNavigation(HomeNavigationTarget target) {
    if (target.externalUrl != null) {
      _homeController.openSocialLink(target.externalUrl!);
      return;
    }

    if (target.route != null) {
      context.push(target.route!);
      return;
    }

    if (target.section != null) {
      _scrollToSection(target.section!);
    }
  }

  void _handleNavigationItem(HomeNavigationItem item) {
    _handleNavigation(_homeController.handleNavigationSelection(item));
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final screenWidth = screenSize.width;
    App.init(context);

    return LayoutBuilder(
      builder: (context, constraints) {
        return Scaffold(
          key: scaffoldKey,
          endDrawer: constraints.maxWidth >= kMinDesktopWidth
              ? null
              : DrawerMobile(
                  navigationItems: HomeController.navigationItems,
                  onNavItemTap: (item) {
                    scaffoldKey.currentState?.closeEndDrawer();
                    _handleNavigationItem(item);
                  },
                ),
          body: Container(
            decoration: const BoxDecoration(
              gradient: RadialGradient(
                center: Alignment.topLeft,
                radius: 2,
                colors: [
                  Color(0xFFFFF1E6),
                  Color(0xFFF5DCC6),
                  Color(0xFFD7B49E),
                  Color(0xFFB08968),
                ],
                stops: [0.1, 0.4, 0.7, 1.0],
              ),
            ),
            child: SingleChildScrollView(
              controller: scrollController,
              child: Column(
                children: [
                  SizedBox(key: _sectionKeys[HomeSection.hero]),
                  if (constraints.maxWidth >= kMinDesktopWidth)
                    HeaderDesktop(
                      navigationItems: HomeController.navigationItems,
                      onNavMenuTap: _handleNavigationItem,
                    )
                  else
                    HeaderMobile(
                      onLogoTap: () {},
                      onMenuTap: () {
                        scaffoldKey.currentState?.openEndDrawer();
                      },
                    ),
                  if (constraints.maxWidth >= kMinDesktopWidth)
                    MainDesktop(
                      scrollToSection: () {
                        _handleNavigation(
                          _homeController.scrollToContact(),
                        );
                      },
                      openResume: _homeController.openResume,
                      openBlog: () => _handleNavigation(
                        const HomeNavigationTarget.route(AppRoutes.blog),
                      ),
                      gameChild: const GamePreview(),
                    )
                  else
                    MainMobile(
                      scrollToSection: () {
                        _handleNavigation(
                          _homeController.scrollToContact(),
                        );
                      },
                      openResume: _homeController.openResume,
                      openBlog: () => _handleNavigation(
                        const HomeNavigationTarget.route(AppRoutes.blog),
                      ),
                    ),
                  Container(
                    key: _sectionKeys[HomeSection.skills],
                    child: SkillsSection(
                      isDesktop: constraints.maxWidth >= kMedDesktopWidth,
                      width: screenWidth,
                    ),
                  ),
                  SizedBox(
                    key: _sectionKeys[HomeSection.introVideo],
                    height: constraints.maxWidth >= kMinDesktopWidth
                        ? 700
                        : 500,
                    width: double.infinity,
                    child: Stack(
                      fit: StackFit.expand,
                      children: [
                        Image.asset(
                          ImageAssets.creamCurtain,
                          fit: BoxFit.fill,
                        ),
                        YoutubePlayerScreen(
                          isMobile: constraints.maxWidth < kMinDesktopWidth,
                        ),
                      ],
                    ),
                  ),
                  Portfolio(
                    key: _sectionKeys[HomeSection.portfolio],
                    projects: _homeController.featuredProjects,
                    onOpenMore: _homeController.openPortfolioSource,
                    onOpenProject: _homeController.openProject,
                  ),
                  const SizedBox(height: 30),
                  ContactSection(
                    controller: _contactController,
                    key: _sectionKeys[HomeSection.contact],
                  ),
                  const Footer(),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
