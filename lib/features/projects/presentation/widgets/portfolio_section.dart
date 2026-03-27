import 'package:flutter/material.dart';
import 'package:my_portfolio/core/presentation/widgets/responsive.dart';
import 'package:my_portfolio/features/projects/domain/models/project_summary.dart';
import 'package:my_portfolio/features/projects/presentation/widgets/portfolio_desktop.dart';
import 'package:my_portfolio/features/projects/presentation/widgets/portfolio_mobile.dart';

class Portfolio extends StatelessWidget {
  const Portfolio({
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
    return Responsive(
      mobile: PortfolioMobileTab(
        projects: projects,
        onOpenMore: onOpenMore,
        onOpenProject: onOpenProject,
      ),
      tablet: PortfolioMobileTab(
        projects: projects,
        onOpenMore: onOpenMore,
        onOpenProject: onOpenProject,
      ),
      desktop: PortfolioDesktop(
        projects: projects,
        onOpenMore: onOpenMore,
        onOpenProject: onOpenProject,
      ),
    );
  }
}
