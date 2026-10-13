import 'package:flutter/material.dart';
import 'package:my_portfolio/core/resources/styles/home_palette.dart';

class GlassPanel extends StatelessWidget {
  const GlassPanel({
    required this.child,
    this.radius = 20,
    this.clip = false,
    super.key,
  });

  final Widget child;
  final double radius;
  final bool clip;

  @override
  Widget build(BuildContext context) {
    final palette = Theme.of(context).homePalette;
    final borderRadius = BorderRadius.circular(radius);
    return DecoratedBox(
      decoration: BoxDecoration(
        color: palette.glassFill,
        borderRadius: borderRadius,
        border: Border.all(color: palette.glassBorder, width: 1.2),
        boxShadow: [
          BoxShadow(
            color: palette.shadowColor.withValues(alpha: 0.02),
            blurRadius: 30,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: DecoratedBox(
        decoration: BoxDecoration(
          borderRadius: borderRadius,
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [palette.glassHighlightStrong, palette.glassHighlightSoft],
          ),
        ),
        child: clip
            ? ClipRRect(borderRadius: borderRadius, child: child)
            : child,
      ),
    );
  }
}
