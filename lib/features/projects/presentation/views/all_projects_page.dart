import 'dart:async';

import 'package:flutter/material.dart';
import 'package:my_portfolio/app/navigation/site_navigation.dart';
import 'package:my_portfolio/app/navigation/site_page.dart';
import 'package:my_portfolio/core/presentation/widgets/press_scale.dart';
import 'package:my_portfolio/core/resources/styles/home_palette.dart';
import 'package:my_portfolio/core/resources/styles/site_text.dart';
import 'package:my_portfolio/core/services/tap_feedback.dart';
import 'package:my_portfolio/features/projects/domain/models/project_summary.dart';
import 'package:my_portfolio/features/projects/presentation/controllers/work_controller.dart';
import 'package:my_portfolio/features/projects/presentation/views/project_detail.dart';

/// Every project as icon, name and one line: three across on desktop, two
/// on tablets, one on phones.
/// Featured projects open their project view; the rest open their store.
class AllProjectsPage extends StatelessWidget {
  const AllProjectsPage({required this.controller, super.key});

  final WorkController controller;

  @override
  Widget build(BuildContext context) {
    final palette = Theme.of(context).homePalette;
    return SitePage(
      title: 'All projects',
      intro: "Every app I've helped design, build and ship.",
      background: LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: palette.heroGradient.take(3).toList(),
      ),
      section: SiteSection.work,
      child: LayoutBuilder(
        builder: (context, constraints) {
          const gap = 16.0;
          final width = constraints.maxWidth;
          final columns = width >= 900 ? 3 : (width >= 560 ? 2 : 1);
          // Floored so rounding never pushes the last card onto a new row.
          final tileWidth = ((width - gap * (columns - 1)) / columns)
              .floorToDouble();
          return Wrap(
            spacing: gap,
            runSpacing: gap,
            children: [
              for (final project in controller.all)
                SizedBox(
                  width: tileWidth,
                  child: Builder(
                    builder: (tile) => _ProjectTile(
                      project: project,
                      compact: columns == 1,
                      onTap: () => _open(tile, project),
                    ),
                  ),
                ),
            ],
          );
        },
      ),
    );
  }

  void _open(BuildContext tile, ProjectSummary project) {
    if (project is! FeaturedProject) {
      unawaited(controller.openLink(project.links.first));
      return;
    }
    final box = tile.findRenderObject()! as RenderBox;
    unawaited(
      showProjectDetail(
        tile,
        project: project,
        origin: box.localToGlobal(Offset.zero) & box.size,
        onOpenStore: (link) => unawaited(controller.openLink(link)),
      ),
    );
  }
}

class _ProjectTile extends StatelessWidget {
  const _ProjectTile({
    required this.project,
    required this.compact,
    required this.onTap,
  });

  final ProjectSummary project;

  /// Phones: one row with the icon beside the text, so the list stays
  /// short; the whole row is the link, so it drops the arrow.
  final bool compact;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final palette = Theme.of(context).homePalette;
    final icon = ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: Image.asset(project.icon, width: 48, height: 48),
    );
    final arrow = Icon(
      Icons.north_east_rounded,
      size: 18,
      color: palette.textSecondary,
    );
    final title = Text(
      project.title.toUpperCase(),
      style: SiteText.display(palette.textStrong, size: compact ? 22 : 24),
      maxLines: compact ? 2 : 1,
      overflow: TextOverflow.ellipsis,
    );
    final about = Text(
      project.about,
      style: SiteText.body(
        palette.textSecondary,
        size: 14,
      ).copyWith(height: 1.45),
      maxLines: 2,
      overflow: TextOverflow.ellipsis,
    );

    return Semantics(
      button: true,
      label: 'Open ${project.title}',
      excludeSemantics: true,
      child: GestureDetector(
        onTap: () {
          tapFeedback();
          onTap();
        },
        child: MouseRegion(
          cursor: SystemMouseCursors.click,
          child: PressScale(
            pressedScale: 0.97,
            child: DecoratedBox(
              decoration: BoxDecoration(
                color: palette.surfaceCard.withValues(alpha: 0.7),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: palette.textSecondary.withValues(alpha: 0.12),
                ),
              ),
              child: Padding(
                padding: EdgeInsets.all(compact ? 16 : 20),
                child: compact
                    ? Row(
                        children: [
                          icon,
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [title, about],
                            ),
                          ),
                        ],
                      )
                    : Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [icon, const Spacer(), arrow],
                          ),
                          const SizedBox(height: 16),
                          title,
                          const SizedBox(height: 4),
                          // Always two lines tall, so every card in a row
                          // matches.
                          SizedBox(
                            height:
                                MediaQuery.textScalerOf(
                                  context,
                                ).scale(14 * 1.45) *
                                2,
                            child: about,
                          ),
                        ],
                      ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
