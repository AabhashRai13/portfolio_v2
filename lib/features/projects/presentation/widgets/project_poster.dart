import 'package:flutter/material.dart';
import 'package:my_portfolio/core/resources/styles/home_palette.dart';
import 'package:my_portfolio/features/projects/domain/models/project_summary.dart';

/// Width / height of every poster card. Posters are drawn for this shape.
const double kPosterAspect = 0.78;

/// A project's poster filling a rounded card. Posters are drawn at
/// [kPosterAspect]; other shapes are cropped to the centre.
class ProjectPoster extends StatelessWidget {
  const ProjectPoster({required this.project, super.key});

  final FeaturedProject project;

  @override
  Widget build(BuildContext context) {
    final palette = Theme.of(context).homePalette;
    final radius = BorderRadius.circular(28);
    return DecoratedBox(
      decoration: BoxDecoration(
        borderRadius: radius,
        boxShadow: [
          BoxShadow(
            color: palette.shadowColor.withValues(alpha: 0.22),
            blurRadius: 28,
            offset: const Offset(0, 14),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: radius,
        child: ColoredBox(
          color: palette.surfaceMuted,
          child: Image.asset(project.banner, fit: BoxFit.cover),
        ),
      ),
    );
  }
}
