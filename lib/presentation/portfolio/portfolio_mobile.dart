import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:my_portfolio/constants/colors.dart';
import 'package:my_portfolio/presentation/widgets/custom_text_heading.dart';
import 'package:my_portfolio/presentation/widgets/project_card.dart';
import 'package:my_portfolio/resources/configs/space.dart';
import 'package:my_portfolio/resources/size_config.dart';
import 'package:my_portfolio/services/url_launcher_services.dart';
import 'package:my_portfolio/utils/project_utils.dart';
import 'package:my_portfolio/utils/static_utils.dart';

class PortfolioMobileTab extends StatelessWidget {
  PortfolioMobileTab({super.key});
  final UrlLauncherServices urlLauncherServices = UrlLauncherServices();
  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    return Column(
      children: [
        const CustomSectionHeading(
          text: '\nPortfolio',
        ),
        CarouselSlider.builder(
          itemCount: ProjectUtils.titles.length,
          itemBuilder: (BuildContext context, int itemIndex, int i) => Padding(
            padding: const EdgeInsets.symmetric(vertical: 15),
            child: ProjectCard(
              projectIcon: ProjectUtils.icons[i],
              projectLink: ProjectUtils.links[i],
              projectTitle: ProjectUtils.titles[i],
            ),
          ),
          options: CarouselOptions(
            height: height * 0.4,
            autoPlay: true,
            autoPlayInterval: const Duration(seconds: 5),
            enlargeCenterPage: true,
            enableInfiniteScroll: false,
          ),
        ),
        Space.y!,
        SizedBox(
          height: getProportionateScreenHeight(60),
          width: getProportionateScreenWidth(200),
          child: ElevatedButton.icon(
            style: ElevatedButton.styleFrom(
              backgroundColor: CustomColor.pastelRed,
              elevation: 4,
              shadowColor: CustomColor.primary.withValues(alpha: 0.18),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(28),
              ),
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
                fontSize: getProportionateScreenHeight(18),
                letterSpacing: 1.1,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
