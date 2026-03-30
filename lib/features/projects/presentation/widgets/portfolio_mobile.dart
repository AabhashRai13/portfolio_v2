import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:my_portfolio/constants/colors.dart';
import 'package:my_portfolio/core/resources/configs/space.dart';
import 'package:my_portfolio/core/resources/size_config.dart';
import 'package:my_portfolio/features/home/presentation/widgets/custom_text_heading.dart';
import 'package:my_portfolio/features/projects/domain/models/project_summary.dart';
import 'package:my_portfolio/features/projects/presentation/widgets/project_card.dart';

class PortfolioMobileTab extends StatelessWidget {
  const PortfolioMobileTab({
    required this.projects,
    required this.onOpenMore,
    required this.onOpenProject,
    super.key,
  });

  final List<ProjectSummary> projects;
  final VoidCallback onOpenMore;
  final ValueChanged<ProjectSummary> onOpenProject;

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    return Column(
      children: [
        const CustomSectionHeading(
          text: '\nPortfolio',
        ),
        CarouselSlider.builder(
          itemCount: projects.length,
          itemBuilder: (BuildContext context, int itemIndex, int i) => Padding(
            padding: const EdgeInsets.symmetric(vertical: 15),
            child: ProjectCard(
              projectIcon: projects[i].icon,
              projectTitle: projects[i].title,
              projectSummary: projects[i].summary,
              onTap: () => onOpenProject(projects[i]),
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
            onPressed: onOpenMore,
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
