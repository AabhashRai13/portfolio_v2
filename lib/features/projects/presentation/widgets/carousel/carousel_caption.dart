import 'package:flutter/material.dart';
import 'package:my_portfolio/core/resources/styles/home_palette.dart';
import 'package:my_portfolio/core/resources/styles/site_text.dart';
import 'package:my_portfolio/features/projects/domain/models/project_summary.dart';

class CarouselCaption extends StatelessWidget {
  const CarouselCaption({
    required this.project,
    required this.opacity,
    required this.compact,
    super.key,
  });

  final FeaturedProject project;
  final double opacity;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    final palette = Theme.of(context).homePalette;
    return Opacity(
      opacity: opacity,
      child: Column(
        children: [
          Text(
            project.title,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.center,
            style: SiteText.body(
              palette.textStrong,
              size: compact ? 18 : 20,
            ).copyWith(fontWeight: FontWeight.w600, height: 1.3),
          ),
          const SizedBox(height: 2),
          Text(
            project.about,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.center,
            style: SiteText.body(palette.textSecondary, size: 15),
          ),
        ],
      ),
    );
  }
}
