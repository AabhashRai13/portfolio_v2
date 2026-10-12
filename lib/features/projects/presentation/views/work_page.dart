import 'dart:async';
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:my_portfolio/app/navigation/site_navigation.dart';
import 'package:my_portfolio/app/navigation/site_page.dart';
import 'package:my_portfolio/app/router/app_routes.dart';
import 'package:my_portfolio/constants/breakpoints.dart';
import 'package:my_portfolio/core/resources/styles/home_palette.dart';
import 'package:my_portfolio/core/resources/styles/site_text.dart';
import 'package:my_portfolio/features/projects/presentation/controllers/work_controller.dart';
import 'package:my_portfolio/features/projects/presentation/views/project_detail.dart';
import 'package:my_portfolio/features/projects/presentation/widgets/all_projects_button.dart';
import 'package:my_portfolio/features/projects/presentation/widgets/project_carousel.dart';

/// The apps built end to end, one at a time; every app is on /work/all.
/// One screen, top to bottom: heading, carousel with the middle project's
/// name, pills, then the way to every project.
class WorkPage extends StatelessWidget {
  const WorkPage({required this.controller, super.key});

  static const String heading = 'Selected work';
  static const String intro =
      'Apps I built end to end, from first screen to release.';

  /// Everything on a desktop page but the middle card: top bar, heading,
  /// stage padding, caption, pills, the link and the gaps between them.
  static const double _chromeHeight = 490;

  /// Below this the posters lose their detail, so the page scrolls instead.
  static const double _minCardHeight = 300;

  final WorkController controller;

  @override
  Widget build(BuildContext context) {
    final palette = Theme.of(context).homePalette;
    final window = MediaQuery.sizeOf(context);
    final isNarrow = window.width < Breakpoints.tablet;
    // Plain warm cream: the carousel brings its own glow.
    return SitePage(
      title: 'Work',
      section: SiteSection.work,
      fillViewport: true,
      child: Column(
        children: [
          Semantics(
            header: true,
            child: Text(
              heading.toUpperCase(),
              textAlign: TextAlign.center,
              style: SiteText.display(
                palette.textStrong,
                size: isNarrow ? 44 : 56,
              ),
            ),
          ),
          const SizedBox(height: 10),
          Text(
            intro,
            textAlign: TextAlign.center,
            style: SiteText.body(
              palette.textSecondary,
              size: isNarrow ? 15 : 17,
            ),
          ),
          SizedBox(height: isNarrow ? 28 : 32),
          ProjectCarousel(
            projects: controller.featured,
            // Desktop fits the whole page in the window; phones scroll.
            maxCardHeight: isNarrow
                ? double.infinity
                : math.max(_minCardHeight, window.height - _chromeHeight),
            onOpen: (project, origin) => showProjectDetail(
              context,
              project: project,
              origin: origin,
              onOpenStore: (link) => unawaited(controller.openLink(link)),
            ),
          ),
          SizedBox(height: isNarrow ? 24 : 28),
          AllProjectsButton(
            onTap: () => unawaited(context.push<void>(AppRoutes.allWork)),
          ),
        ],
      ),
    );
  }
}
