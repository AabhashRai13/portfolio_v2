import 'package:flutter/material.dart';
import 'package:my_portfolio/constants/colors.dart';
import 'package:my_portfolio/features/home/presentation/widgets/custom_text_heading.dart';
import 'package:my_portfolio/features/portfolio/domain/models/project_summary.dart';
import 'package:my_portfolio/features/portfolio/presentation/widgets/project_card.dart';
import 'package:my_portfolio/resources/configs/app_dimensions.dart';
import 'package:my_portfolio/resources/configs/space.dart';
import 'package:my_portfolio/resources/size_config.dart';

class PortfolioDesktop extends StatelessWidget {
  const PortfolioDesktop({
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
    return Container(
      padding:
          Space.h ?? EdgeInsets.symmetric(horizontal: AppDimensions.space(0.2)),
      child: Column(
        children: [
          const CustomSectionHeading(
            text: '\nPortfolio',
          ),
          Space.y!,
          Wrap(
            alignment: WrapAlignment.center,
            crossAxisAlignment: WrapCrossAlignment.center,
            spacing: AppDimensions.normalize(10),
            runSpacing: AppDimensions.normalize(10),
            children: projects
                .map(
                  (project) => ProjectCard(
                    banner: project.banner,
                    projectIcon: project.icon,
                    projectTitle: project.title,
                    onTap: () => onOpenProject(project),
                  ),
                )
                .toList(),
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
                  fontSize: getProportionateScreenHeight(20),
                  letterSpacing: 1.1,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
