import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:my_portfolio/core/resources/styles/home_palette.dart';

/// About tile: a still from the intro video, slowly zooming, with a play
/// glyph.
class AboutTilePreview extends StatelessWidget {
  const AboutTilePreview({
    required this.progress,
    required this.color,
    super.key,
  });

  final double progress;
  final Color color;

  @override
  Widget build(BuildContext context) {
    final zoom = 1 + (0.05 * (0.5 - (0.5 * math.cos(progress * math.pi * 2))));
    return Stack(
      fit: StackFit.expand,
      children: [
        Transform.scale(
          scale: zoom,
          child: Image.asset(
            'assets/images/intro_video_thumb.jpg',
            fit: BoxFit.cover,
          ),
        ),
        ColoredBox(
          color: Theme.of(
            context,
          ).homePalette.shadowColor.withValues(alpha: 0.22),
        ),
        Center(
          child: Icon(
            Icons.play_circle_fill_rounded,
            size: 46,
            color: color,
          ),
        ),
      ],
    );
  }
}
