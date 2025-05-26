import 'package:flutter/material.dart';
import 'package:my_portfolio/constants/colors.dart';
import 'package:my_portfolio/constants/size.dart';
import 'package:my_portfolio/constants/sns_links.dart';
import 'package:my_portfolio/presentation/portfolio/portfolio.dart';
import 'package:my_portfolio/presentation/services/mouse_pointer_animation_service.dart';
import 'package:my_portfolio/presentation/widgets/contact_section.dart';
import 'package:my_portfolio/presentation/widgets/custom_text_heading.dart';
import 'package:my_portfolio/presentation/widgets/drawer_mobile.dart';
import 'package:my_portfolio/presentation/widgets/footer.dart';
import 'package:my_portfolio/presentation/widgets/header_desktop.dart';
import 'package:my_portfolio/presentation/widgets/header_mobile.dart';
import 'package:my_portfolio/presentation/widgets/main_desktop.dart';
import 'package:my_portfolio/presentation/widgets/main_mobile.dart';
import 'package:my_portfolio/presentation/widgets/skills_desktop.dart';
import 'package:my_portfolio/presentation/widgets/skills_mobile.dart';
import 'package:my_portfolio/presentation/youtube/youtube_player.dart';
import 'package:my_portfolio/resources/asset_manager.dart';
import 'package:my_portfolio/resources/configs/app.dart';
import 'package:my_portfolio/resources/size_config.dart';
import 'package:universal_html/html.dart' as html;

class HomeMainPage extends StatefulWidget {
  const HomeMainPage({super.key});

  @override
  State<HomeMainPage> createState() => _HomeMainPageState();
}

class _HomeMainPageState extends State<HomeMainPage> {
  final MousePointerAnimation _mousePointerAnimation = MousePointerAnimation();
  final scaffoldKey = GlobalKey<ScaffoldState>();
  final scrollController = ScrollController();
  final List<GlobalKey> navbarKeys = List.generate(5, (index) => GlobalKey());
  Offset? _mousePosition;

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final screenWidth = screenSize.width;
    App.init(context);
    return LayoutBuilder(builder: (context, constraints) {
      return Scaffold(
        key: scaffoldKey,
        endDrawer: constraints.maxWidth >= kMinDesktopWidth
            ? null
            : DrawerMobile(onNavItemTap: (int navIndex) {
                scaffoldKey.currentState?.closeEndDrawer();
                scrollToSection(navIndex: navIndex);
              },),
        body: Container(
          decoration: const BoxDecoration(
            gradient: RadialGradient(
              center: Alignment.topLeft,
              radius: 2,
              colors: [
                Color(0xFFFFF1E6), // Light cream
                Color(0xFFF5DCC6), // Beige-pink accent
                Color(0xFFD7B49E), // Soft tan
                Color(0xFFB08968), // Richer warm brown
              ],
              stops: [0.1, 0.4, 0.7, 1.0],
            ),
          ),
          child: SingleChildScrollView(
            controller: scrollController,
            child: Column(
              children: [
                SizedBox(key: navbarKeys.first),

                // MAIN
                if (constraints.maxWidth >= kMinDesktopWidth)
                  HeaderDesktop(onNavMenuTap: (int navIndex) {
                    scrollToSection(navIndex: navIndex);
                  },)
                else
                  HeaderMobile(
                    onLogoTap: () {},
                    onMenuTap: () {
                      scaffoldKey.currentState?.openEndDrawer();
                    },
                  ),

                if (constraints.maxWidth >= kMinDesktopWidth)
                  MainDesktop(
                    scrollToSection: scrollToContact,
      
                  )
                else
                  MainMobile(
                    scrollToSection: scrollToContact,
                  ),

                // SKILLS
                MouseRegion(
                  onHover: (event) =>
                      _mousePointerAnimation.handleMouseMove(event, context),
                  onExit: _mousePointerAnimation.handleMouseExit,
                  child: Container(
                    key: navbarKeys[1],
                    width: screenWidth,
                    padding: const EdgeInsets.fromLTRB(25, 20, 25, 0),
                    color: CustomColor.bgLight1,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // title
                        const CustomSectionHeading(
                          text: 'What I Can Do',
                          icon: Icons.computer,
                          subText: 'My Mastery Arsenal.',
                        ),
                        const SizedBox(height: 50),

                        // platforms and skills
                        if (constraints.maxWidth >= kMedDesktopWidth)
                           SkillsDesktop(
                        mousePosition: _mousePosition,
                          )
                        else
                          const SkillsMobile(),
                        const SizedBox(
                          height: 10,
                        ),
                      ],
                    ),
                  ),
                ),

                // INTRO VIDEO
                SizedBox(
                  height: getProportionateScreenHeight(700),
                  width: double.infinity,
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      Image.asset(
                        ImageAssets.creamCurtain,
                        fit: BoxFit.fill,
                      ),
                      YoutubePlayerScreen(
                        key: navbarKeys[2],
                      ),
                    ],
                  ),
                ),

                // PROJECTS
                Portfolio(
                  key: navbarKeys[3],
                ),

                const SizedBox(height: 30),

                // CONTACT
                ContactSection(
                  key: navbarKeys[4],
                ),

                // FOOTER
                const Footer(),
              ],
            ),
          ),
        ),
      );
    },);
  }

  void scrollToSection({int? navIndex}) {
    if (navIndex == 5) {
      // open a blog page
      html.window.open(
        SnsLinks.resume,
        'docx',
      );
      return;
    }

    final key = navbarKeys[navIndex ?? 3];
    Scrollable.ensureVisible(
      key.currentContext!,
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeInOut,
    );
  }

  void scrollToContact() {
    final key = navbarKeys[4];
    Scrollable.ensureVisible(
      key.currentContext!,
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeInOut,
    );
  }
}
