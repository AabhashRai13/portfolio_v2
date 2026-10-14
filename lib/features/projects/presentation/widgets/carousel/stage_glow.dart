import 'package:flutter/material.dart';
import 'package:my_portfolio/core/resources/styles/home_palette.dart';

/// Light gathered behind the stage: soft peach low on the left and dusty
/// lavender high on the right, both fading out well before the page edge so
/// the rest of the page stays plain warm cream. Radial gradients rather than
/// a blur, so it paints once and costs nothing while the carousel moves.
class StageGlow extends StatelessWidget {
  const StageGlow({super.key});

  @override
  Widget build(BuildContext context) {
    final [peach, lavender] = Theme.of(context).homePalette.stageGlow;
    return IgnorePointer(
      child: RepaintBoundary(
        child: Stack(
          fit: StackFit.expand,
          children: [
            _wash(peach, const Alignment(-0.7, 0.45)),
            _wash(lavender, const Alignment(0.7, -0.45)),
          ],
        ),
      ),
    );
  }

  /// A wide, soft oval of [color] centred at [at]. The gradient reaches
  /// transparent at the box's short edges, so nothing ends in a hard line.
  static Widget _wash(Color color, Alignment at) => Align(
    alignment: at,
    child: FractionallySizedBox(
      widthFactor: 0.42,
      heightFactor: 0.9,
      child: Transform.scale(
        scaleX: 1.5,
        child: DecoratedBox(
          decoration: BoxDecoration(
            gradient: RadialGradient(
              colors: [color, color.withValues(alpha: 0)],
            ),
          ),
        ),
      ),
    ),
  );
}
