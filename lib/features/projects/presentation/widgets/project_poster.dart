import 'package:flutter/material.dart';
import 'package:my_portfolio/core/resources/styles/home_palette.dart';
import 'package:my_portfolio/features/projects/domain/models/project_summary.dart';

/// Width / height of every poster card. Posters are drawn for this shape.
const double kPosterAspect = 0.78;

/// Corner radius of a poster card as it appears on screen.
const double kPosterRadius = 28;

/// A project's poster filling a rounded card. Posters are drawn at
/// [kPosterAspect]; other shapes are cropped to the centre.
class ProjectPoster extends StatelessWidget {
  const ProjectPoster({
    required this.project,
    this.radius = kPosterRadius,
    this.shadow,
    super.key,
  });

  final FeaturedProject project;

  /// Before any scale applied around the card; the carousel divides by its
  /// scale so every card shows the same corner on screen.
  final double radius;

  /// Replaces the default drop shadow; the carousel lifts the middle card.
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
