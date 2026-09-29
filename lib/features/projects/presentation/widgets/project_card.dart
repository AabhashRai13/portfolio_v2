import 'package:flutter/material.dart';
import 'package:my_portfolio/core/resources/configs/app_dimensions.dart';
import 'package:my_portfolio/core/resources/configs/app_typography.dart';
import 'package:my_portfolio/core/resources/configs/space.dart';
import 'package:my_portfolio/core/resources/styles/home_palette.dart';
import 'package:my_portfolio/features/projects/domain/models/project_summary.dart';

/// Screenshot on top, always-visible details below, so touch users and
/// skimmers see what the project is without hovering.
class ProjectCard extends StatefulWidget {
  const ProjectCard({
    required this.project,
    super.key,
    this.onTap,
  });
  final ProjectSummary project;
  final VoidCallback? onTap;

  @override
  ProjectCardState createState() => ProjectCardState();
}

class ProjectCardState extends State<ProjectCard> {
  bool isHover = false;
  @override
  Widget build(BuildContext context) {
    final palette = Theme.of(context).homePalette;
    final project = widget.project;

    return InkWell(
      hoverColor: Colors.transparent,
      splashColor: Colors.transparent,
      highlightColor: Colors.transparent,
      onTap: widget.onTap,
      onHover: (isHovering) => setState(() => isHover = isHovering),
      child: Container(
        margin: Space.h,
        width: AppDimensions.normalize(155),
        height: AppDimensions.normalize(130),
        clipBehavior: Clip.antiAlias,
        decoration: BoxDecoration(
          color: palette.surfaceCard,
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              color: (isHover ? palette.primaryAccent : palette.shadowColor)
                  .withAlpha(100),
              blurRadius: 12,
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: project.banner != null
                  ? Image.asset(
                      project.banner!,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) =>
                          const SizedBox.shrink(),
                    )
                  : project.icon != null
                  ? Padding(
                      padding: const EdgeInsets.all(16),
                      child: Image.asset(project.icon!),
                    )
                  : const SizedBox.shrink(),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          project.title,
                          style: AppText.b2b?.copyWith(fontSize: 16),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      Icon(
                        Icons.north_east_rounded,
                        size: 16,
                        color: isHover
                            ? palette.primaryAccent
                            : palette.textSecondary,
                      ),
                    ],
                  ),
                  if (project.role != null) ...[
                    const SizedBox(height: 2),
                    Text(
                      project.role!,
                      style: AppText.b2?.copyWith(
                        fontSize: 12,
                        color: palette.textSecondary.withValues(alpha: 0.8),
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                  const SizedBox(height: 6),
                  Text(
                    project.summary,
                    style: AppText.b2?.copyWith(
                      fontSize: 13,
                      color: palette.textSecondary,
                      height: 1.35,
                    ),
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                  ),
                  if (project.result != null) ...[
                    const SizedBox(height: 6),
                    Text(
                      project.result!,
                      style: AppText.b2?.copyWith(
                        fontSize: 12.5,
                        fontWeight: FontWeight.w600,
                        color: palette.primaryAccent,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
