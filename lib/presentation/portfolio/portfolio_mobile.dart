import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:my_portfolio/constants/colors.dart';
import 'package:my_portfolio/presentation/widgets/custom_text_heading.dart';
import 'package:my_portfolio/presentation/widgets/project_card.dart';
import 'package:my_portfolio/resources/configs/app_dimensions.dart';
import 'package:my_portfolio/resources/configs/space.dart';
import 'package:my_portfolio/services/url_launcher_services.dart';
import 'package:my_portfolio/utils/project_utils.dart';
import 'package:my_portfolio/utils/static_utils.dart';

class PortfolioMobileTab extends StatelessWidget {
  PortfolioMobileTab({super.key});
  final UrlLauncherServices urlLauncherServices = UrlLauncherServices();
  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    return Column(
      children: [
        const CustomSectionHeading(
          text: "\nPortfolio",
        ),
        CarouselSlider.builder(
          itemCount: ProjectUtils.titles.length,
          itemBuilder: (BuildContext context, int itemIndex, int i) => Padding(
            padding: const EdgeInsets.symmetric(vertical: 15.0),
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
            autoPlayCurve: Curves.fastOutSlowIn,
            autoPlayAnimationDuration: const Duration(milliseconds: 800),
            enableInfiniteScroll: false,
          ),
        ),
        Space.y!,
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
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
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
    );
  }
}
