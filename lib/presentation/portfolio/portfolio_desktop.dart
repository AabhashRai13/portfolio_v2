import 'package:flutter/material.dart';
import 'package:my_portfolio/constants/colors.dart';
import 'package:my_portfolio/presentation/widgets/custom_text_heading.dart';
import 'package:my_portfolio/presentation/widgets/project_card.dart';
import 'package:my_portfolio/resources/configs/app_dimensions.dart';
import 'package:my_portfolio/resources/configs/space.dart';
import 'package:my_portfolio/resources/size_config.dart';
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
          Space.h ?? EdgeInsets.symmetric(horizontal: AppDimensions.space(0.2)),
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
            height: getProportionateScreenHeight(60),
            width: getProportionateScreenWidth(80),
            child: ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor:
                    CustomColor.pastelRed, // Keep your pastel color
                elevation: 4,
                shadowColor: CustomColor.primary.withValues(alpha: 0.18),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(18), // More pill-like
                ),
                padding:
                    const EdgeInsets.symmetric(horizontal: 32, vertical: 18),
                textStyle: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                  letterSpacing: 1.1,
                ),
              ),
              onPressed: () => urlLauncherServices.openURL(StaticUtils.gitHub),
              icon: Icon(
                Icons.explore_rounded,
                size: getProportionateScreenHeight(16),
                color: Colors.white,
              ),
              label: Text(
                'See More',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: getProportionateScreenHeight(20),
                  letterSpacing: 1.1,
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
