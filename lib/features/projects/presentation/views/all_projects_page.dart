import 'dart:async';

import 'package:flutter/material.dart';
import 'package:my_portfolio/app/navigation/site_navigation.dart';
import 'package:my_portfolio/app/navigation/site_page.dart';
import 'package:my_portfolio/app/navigation/site_text_link.dart';
import 'package:my_portfolio/core/resources/configs/app.dart';
import 'package:my_portfolio/features/projects/presentation/controllers/work_controller.dart';
import 'package:my_portfolio/features/projects/presentation/widgets/project_card.dart';

/// Every project as a card grid, reached from "See all projects" on /work.
class AllProjectsPage extends StatelessWidget {
  const AllProjectsPage({required this.controller, super.key});

  final WorkController controller;

  @override
  Widget build(BuildContext context) {
    // ProjectCard sizes itself from the legacy App/AppDimensions config.
    App.init(context);

    return SitePage(
      title: 'All projects',
      section: SiteSection.work,
      showTitle: false,
      intro: 'Every app I have helped design, build and ship.',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Wrap(
            spacing: 16,
            runSpacing: 24,
            children: [
              for (final project in controller.projects)
                ProjectCard(
                  project: project,
                  onTap: () => unawaited(controller.openProject(project)),
                ),
            ],
          ),
          const SizedBox(height: 40),
          SiteTextLink(
            label: 'Source code on GitHub ↗',
            onTap: () => unawaited(controller.openSource()),
          ),
        ],
      ),
    );
  }
}
