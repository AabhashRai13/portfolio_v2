import 'dart:async';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:my_portfolio/app/navigation/site_navigation.dart';
import 'package:my_portfolio/app/navigation/site_page.dart';
import 'package:my_portfolio/app/navigation/site_text_link.dart';
import 'package:my_portfolio/app/router/app_routes.dart';
import 'package:my_portfolio/core/resources/styles/home_palette.dart';
import 'package:my_portfolio/features/projects/presentation/controllers/work_controller.dart';
import 'package:my_portfolio/features/projects/presentation/views/project_detail.dart';
import 'package:my_portfolio/features/projects/presentation/widgets/project_carousel.dart';

/// The apps built end to end, one at a time; every app is on /work/all.
class WorkPage extends StatelessWidget {
  const WorkPage({required this.controller, super.key});

  final WorkController controller;

  @override
  Widget build(BuildContext context) {
    final palette = Theme.of(context).homePalette;
    return SitePage(
      title: 'Work',
      // The warm wash from the first version of the site; its darkest stop
      // is left out so text near the bottom keeps its contrast.
      background: LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: palette.heroGradient.take(3).toList(),
      ),
      section: SiteSection.work,
      showTitle: false,
      child: Column(
        children: [
          ProjectCarousel(
            projects: controller.featured,
            onOpen: (project, origin) => showProjectDetail(
              context,
              project: project,
              origin: origin,
              onOpenStore: (link) => unawaited(controller.openLink(link)),
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
