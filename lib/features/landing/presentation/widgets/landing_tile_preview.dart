import 'package:flutter/material.dart';
import 'package:my_portfolio/app/navigation/site_navigation.dart';
import 'package:my_portfolio/features/landing/presentation/widgets/landing_looping_preview.dart';
import 'package:my_portfolio/features/landing/presentation/widgets/previews/about_tile_preview.dart';
import 'package:my_portfolio/features/landing/presentation/widgets/previews/contact_tile_preview.dart';
import 'package:my_portfolio/features/landing/presentation/widgets/previews/work_tile_preview.dart';
import 'package:my_portfolio/features/landing/presentation/widgets/previews/writing_tile_preview.dart';

class LandingTilePreview extends StatelessWidget {
  const LandingTilePreview({
    required this.section,
    required this.foreground,
    super.key,
  });

  final SiteSection section;
  final Color foreground;

  @override
  Widget build(BuildContext context) {
    return switch (section) {
      SiteSection.work => LandingLoopingPreview(
        duration: const Duration(seconds: 5),
        builder: (context, animation) =>
            WorkTilePreview(progress: animation.value, color: foreground),
      ),
      SiteSection.about => LandingLoopingPreview(
        duration: const Duration(seconds: 6),
        builder: (context, animation) =>
            AboutTilePreview(progress: animation.value, color: foreground),
      ),
      SiteSection.writing => LandingLoopingPreview(
        duration: const Duration(seconds: 4),
        builder: (context, animation) => WritingTilePreview(
          progress: animation.value,
          color: foreground,
        ),
      ),
      SiteSection.contact => LandingLoopingPreview(
        duration: const Duration(seconds: 4),
        builder: (context, animation) => ContactTilePreview(
          progress: animation.value,
          color: foreground,
        ),
      ),
    };
  }
}
