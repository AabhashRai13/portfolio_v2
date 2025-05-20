import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:my_portfolio/constants/colors.dart';
import 'package:my_portfolio/presentation/widgets/custom_text_heading.dart';
import 'package:my_portfolio/presentation/widgets/project_card.dart';
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
          height: MediaQuery.of(context).size.height * 0.05,
          width: MediaQuery.of(context).size.width * 0.3,
          child: ElevatedButton.icon(
            style: ElevatedButton.styleFrom(
              backgroundColor: CustomColor.pastelRed,
              elevation: 6,
              shadowColor: const Color(0xFFDEBFF3).withOpacity(0.5),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              padding: EdgeInsets.symmetric(
                horizontal: MediaQuery.of(context).size.width * 0.02,
                vertical: MediaQuery.of(context).size.height * 0.015,
              ),
            ),
            onPressed: () => urlLauncherServices.openURL(StaticUtils.gitHub),
            icon: Icon(
              Icons.explore_rounded,
              size: MediaQuery.of(context).size.width * 0.04,
              color: Colors.white,
            ),
            label: Text(
              'See More',
              style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: MediaQuery.of(context).size.width * 0.035,
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
