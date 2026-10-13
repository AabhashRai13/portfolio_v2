import 'package:flutter/material.dart';
import 'package:my_portfolio/core/presentation/widgets/tappable.dart';
import 'package:my_portfolio/core/resources/styles/home_palette.dart';
import 'package:my_portfolio/features/projects/domain/models/project_summary.dart';
import 'package:my_portfolio/features/projects/presentation/widgets/project_poster.dart';

class CarouselSlide extends StatelessWidget {
  const CarouselSlide({
    required this.project,
    required this.pageWidth,
    required this.scale,
    required this.distance,
    required this.label,
    required this.onTap,
    super.key,
  });

  final FeaturedProject project;
  final double pageWidth;
  final double scale;

  /// 0 in the middle, 1 one page away.
  final double distance;
  final String label;

  /// Gets the card's own context, to measure where the project view grows
  /// from.
  final ValueChanged<BuildContext> onTap;

  @override
  Widget build(BuildContext context) {
    final palette = Theme.of(context).homePalette;
    return Center(
      child: SizedBox(
        width: pageWidth,
        height: pageWidth / kPosterAspect,
        child: Transform.scale(
          scale: scale,
          child: Builder(
            builder: (card) => Tappable(
              label: label,
              onTap: () => onTap(card),
              // Neighbours step back, a little faded and less saturated,
              // so the middle card holds the eye.
              child: Opacity(
                opacity: 1 - 0.15 * distance,
                child: ColorFiltered(
                  colorFilter: ColorFilter.matrix(
                    _saturation(1 - 0.4 * distance),
                  ),
                  child: ProjectPoster(
                    project: project,
                    // The same corner on screen at every scale.
                    radius: kPosterRadius / scale,
                    shadow: BoxShadow.lerp(
                      BoxShadow(
                        color: palette.shadowColor.withValues(alpha: 0.3),
                        blurRadius: 48,
                        offset: const Offset(0, 24),
                      ),
                      BoxShadow(
                        color: palette.shadowColor.withValues(alpha: 0.1),
                        blurRadius: 16,
                        offset: const Offset(0, 8),
                      ),
                      distance,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// Colour matrix that keeps [s] of the saturation: 1 leaves colours alone,
/// 0 is greyscale (Rec. 709 luma weights).
List<double> _saturation(double s) {
  const r = 0.2126;
  const g = 0.7152;
  const b = 0.0722;
  final k = 1 - s;
  return [
    r * k + s, g * k, b * k, 0, 0, //
    r * k, g * k + s, b * k, 0, 0, //
    r * k, g * k, b * k + s, 0, 0, //
    0, 0, 0, 1, 0, //
  ];
}
