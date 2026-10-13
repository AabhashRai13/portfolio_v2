import 'package:flutter/material.dart';
import 'package:my_portfolio/core/presentation/widgets/press_scale.dart';
import 'package:my_portfolio/core/resources/styles/home_palette.dart';
import 'package:my_portfolio/core/services/tap_feedback.dart';

class CarouselArrow extends StatelessWidget {
  const CarouselArrow({
    required this.size,
    required this.icon,
    required this.tooltip,
    required this.onPressed,
    super.key,
  });

  final double size;
  final IconData icon;
  final String tooltip;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final palette = Theme.of(context).homePalette;
    return PressScale(
      child: IconButton(
        tooltip: tooltip,
        onPressed: () {
          tapFeedback();
          onPressed();
        },
        icon: Icon(icon, size: 24),
        style: IconButton.styleFrom(
          fixedSize: Size.square(size),
          // Drawn at [size] but tappable across 48 px.
          tapTargetSize: MaterialTapTargetSize.padded,
          foregroundColor: palette.textStrong,
          backgroundColor: palette.surfaceCard,
          elevation: 3,
          shadowColor: palette.shadowColor.withValues(alpha: 0.35),
        ),
      ),
    );
  }
}
