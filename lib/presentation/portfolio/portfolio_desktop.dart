import 'package:flutter/material.dart';
import 'package:my_portfolio/constants/colors.dart';
import 'package:my_portfolio/presentation/widgets/custom_text_heading.dart';
import 'package:my_portfolio/presentation/widgets/project_card.dart';
import 'package:my_portfolio/resources/configs/app_dimensions.dart';
import 'package:my_portfolio/resources/configs/space.dart';
import 'package:my_portfolio/services/url_launcher_services.dart';
import 'package:my_portfolio/utils/project_utils.dart';
import 'package:my_portfolio/utils/static_utils.dart';

class PortfolioDesktop extends StatefulWidget {
  const PortfolioDesktop({super.key});

  @override
  State<PortfolioDesktop> createState() => _PortfolioDesktopState();
}

class _PortfolioDesktopState extends State<PortfolioDesktop> {
  final UrlLauncherServices urlLauncherServices = UrlLauncherServices();

  List<ProjectCard> _buildProjectCards() {
    final List<ProjectCard> cards = [];
    for (int i = 0; i < ProjectUtils.banners.length; i++) {
      if (i < ProjectUtils.icons.length &&
          i < ProjectUtils.links.length &&
          i < ProjectUtils.titles.length) {
        cards.add(
          ProjectCard(
            banner: ProjectUtils.banners[i],
            projectIcon: ProjectUtils.icons[i],
            projectLink: ProjectUtils.links[i],
            projectTitle: ProjectUtils.titles[i],
          ),
        );
      }
    }
    return cards;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding:
          Space.h ?? EdgeInsets.symmetric(horizontal: AppDimensions.space(0.5)),
      child: Column(
        children: [
          const CustomSectionHeading(
            text: "\nPortfolio",
          ),
          Space.y!,
          Wrap(
            alignment: WrapAlignment.center,
            crossAxisAlignment: WrapCrossAlignment.center,
            spacing: AppDimensions.normalize(10),
            runSpacing: AppDimensions.normalize(10),
            children: _buildProjectCards(),
          ),
          Space.y2 ?? SizedBox(height: AppDimensions.space(2)),
          SizedBox(
            height: AppDimensions.normalize(16),
            width: AppDimensions.normalize(60),
            child: ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: CustomColor.pastelRed, // Light pastel purple
                elevation: 6,
                shadowColor: const Color(0xFFDEBFF3).withOpacity(0.5),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              ),
              onPressed: () => urlLauncherServices.openURL(StaticUtils.gitHub),
              icon: const Icon(
                Icons.explore_rounded,
                size: 20,
                color: Colors.white,
              ),
              label: const Text(
                'See More',
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 16,
                  color: Colors.white,
                  letterSpacing: 1.05,
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
