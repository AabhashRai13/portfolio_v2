import 'package:flutter/material.dart';
import 'package:my_portfolio/constants/colors.dart';
import 'package:my_portfolio/constants/size.dart';
import 'package:my_portfolio/features/contact/presentation/views/contact_section_view.dart';
import 'package:my_portfolio/features/game/presentation/widgets/game_preview.dart';
import 'package:my_portfolio/features/home/presentation/models/home_section.dart';
import 'package:my_portfolio/features/home/presentation/services/mouse_pointer_animation_service.dart';
import 'package:my_portfolio/features/home/presentation/view_models/home_view_model.dart';
import 'package:my_portfolio/features/home/presentation/widgets/custom_text_heading.dart';
import 'package:my_portfolio/features/home/presentation/widgets/drawer_mobile.dart';
import 'package:my_portfolio/features/home/presentation/widgets/footer.dart';
import 'package:my_portfolio/features/home/presentation/widgets/header_desktop.dart';
import 'package:my_portfolio/features/home/presentation/widgets/header_mobile.dart';
import 'package:my_portfolio/features/home/presentation/widgets/main_desktop.dart';
import 'package:my_portfolio/features/home/presentation/widgets/main_mobile.dart';
import 'package:my_portfolio/features/home/presentation/widgets/skills_desktop.dart';
import 'package:my_portfolio/features/home/presentation/widgets/skills_mobile.dart';
import 'package:my_portfolio/features/home/presentation/widgets/youtube_player.dart';
import 'package:my_portfolio/features/portfolio/presentation/widgets/portfolio_section.dart';
import 'package:my_portfolio/resources/asset_manager.dart';
import 'package:my_portfolio/resources/configs/app.dart';
import 'package:provider/provider.dart';

class HomeMainPage extends StatefulWidget {
  const HomeMainPage({super.key});

  @override
  State<HomeMainPage> createState() => _HomeMainPageState();
}

class _HomeMainPageState extends State<HomeMainPage> {
  final MousePointerAnimation _mousePointerAnimation = MousePointerAnimation();
  final scaffoldKey = GlobalKey<ScaffoldState>();
  final scrollController = ScrollController();
  final Map<HomeSection, GlobalKey> _sectionKeys = <HomeSection, GlobalKey>{
    HomeSection.hero: GlobalKey(),
    HomeSection.skills: GlobalKey(),
    HomeSection.introVideo: GlobalKey(),
    HomeSection.portfolio: GlobalKey(),
    HomeSection.contact: GlobalKey(),
  };
  Offset? _mousePosition;

  @override
  void dispose() {
    scrollController.dispose();
    _mousePointerAnimation.dispose();
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

  @override
  Widget build(BuildContext context) {
    final homeViewModel = context.read<HomeViewModel>();
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
                  onNavItemTap: (int navIndex) {
                    scaffoldKey.currentState?.closeEndDrawer();
                    homeViewModel.handleNavigationSelection(
                      navIndex,
                      scrollToSection: _scrollToSection,
                    );
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
                      onNavMenuTap: (int navIndex) {
                        homeViewModel.handleNavigationSelection(
                          navIndex,
                          scrollToSection: _scrollToSection,
                        );
                      },
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
                        homeViewModel.scrollToContact(
                          scrollToSection: _scrollToSection,
                        );
                      },
                      gameChild: const GamePreview(),
                    )
                  else
                    MainMobile(
                      scrollToSection: () {
                        homeViewModel.scrollToContact(
                          scrollToSection: _scrollToSection,
                        );
                      },
                    ),
                  MouseRegion(
                    onHover: (event) =>
                        _mousePointerAnimation.handleMouseMove(event, context),
                    onExit: _mousePointerAnimation.handleMouseExit,
                    child: Container(
                      key: _sectionKeys[HomeSection.skills],
                      width: screenWidth,
                      padding: const EdgeInsets.fromLTRB(25, 20, 25, 0),
                      color: CustomColor.bgLight1,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const CustomSectionHeading(
                            text: 'What I Can Do',
                            icon: Icons.computer,
                            subText: 'My Mastery Arsenal.',
                          ),
                          const SizedBox(height: 50),
                          if (constraints.maxWidth >= kMedDesktopWidth)
                            SkillsDesktop(
                              mousePosition: _mousePosition,
                            )
                          else
                            const SkillsMobile(),
                          const SizedBox(height: 10),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(
                    key: _sectionKeys[HomeSection.introVideo],
                    height:
                        constraints.maxWidth >= kMinDesktopWidth ? 700 : 500,
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
                    projects: homeViewModel.featuredProjects,
                    onOpenMore: homeViewModel.openPortfolioSource,
                    onOpenProject: homeViewModel.openProject,
                  ),
                  const SizedBox(height: 30),
                  ContactSection(
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
