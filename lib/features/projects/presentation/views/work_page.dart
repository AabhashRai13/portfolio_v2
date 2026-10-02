import 'dart:async';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:my_portfolio/app/navigation/site_navigation.dart';
import 'package:my_portfolio/app/navigation/site_page.dart';
import 'package:my_portfolio/app/navigation/site_text_link.dart';
import 'package:my_portfolio/app/router/app_routes.dart';
import 'package:my_portfolio/features/projects/presentation/controllers/work_controller.dart';
import 'package:my_portfolio/features/projects/presentation/views/project_detail.dart';
import 'package:my_portfolio/features/projects/presentation/widgets/project_carousel.dart';

/// Flagship projects one at a time; the full list lives on /work/all. The
/// carousel's own "Work · 01 / 03" header is the page heading.
class WorkPage extends StatelessWidget {
  const WorkPage({required this.controller, super.key});

  final WorkController controller;

  @override
  Widget build(BuildContext context) {
    return SitePage(
      title: 'Work',
      section: SiteSection.work,
      showTitle: false,
      child: Column(
        children: [
          ProjectCarousel(
            title: 'Work',
            projects: controller.flagships,
            onOpen: (project, origin) => showProjectDetail(
              context,
              project: project,
              origin: origin,
              onOpenStore: () => unawaited(controller.openProject(project)),
            ),
          ),
          const SizedBox(height: 28),
          SiteTextLink(
            label: 'All projects ↗',
            plain: true,
            fontSize: 17,
            onTap: () => unawaited(context.push<void>(AppRoutes.allWork)),
          ),
        ],
      ),
    );
  }
}
