import 'package:flutter/material.dart';
import 'package:my_portfolio/core/resources/styles/home_palette.dart';
import 'package:my_portfolio/features/projects/domain/models/project_summary.dart';

const double kPosterAspect = 0.78;
const double kPosterRadius = 28;

class ProjectPoster extends StatelessWidget {
  const ProjectPoster({
    required this.project,
    this.radius = kPosterRadius,
    this.shadow,
    super.key,
  });

  final FeaturedProject project;
  final double radius;
  final BoxShadow? shadow;

  @override
  Widget build(BuildContext context) {
    final palette = Theme.of(context).homePalette;
    final borderRadius = BorderRadius.circular(radius);
    return DecoratedBox(
      decoration: BoxDecoration(
        borderRadius: borderRadius,
        boxShadow: [
          shadow ??
              BoxShadow(
                color: palette.shadowColor.withValues(alpha: 0.22),
                blurRadius: 28,
                offset: const Offset(0, 14),
              ),
        ],
      ),
      child: ClipRRect(
        borderRadius: borderRadius,
        child: ColoredBox(
          color: palette.surfaceMuted,
          child: Image.asset(project.banner, fit: BoxFit.cover),
        ),
      ),
    );
  }
}
