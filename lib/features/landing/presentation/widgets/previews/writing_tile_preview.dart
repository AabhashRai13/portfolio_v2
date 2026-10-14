import 'package:flutter/material.dart';

/// Writing tile: an article card whose lines write themselves.
class WritingTilePreview extends StatelessWidget {
  const WritingTilePreview({
    required this.progress,
    required this.color,
    super.key,
  });

  final double progress;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 42, 16, 18),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          for (var i = 0; i < 4; i++) ...[
            FractionallySizedBox(
              widthFactor:
                  (((progress * 1.45) - (i * 0.14)).clamp(0.0, 1.0)) *
                  (i == 3 ? 0.58 : 1),
              child: Container(
                height: i == 0 ? 9 : 5,
                decoration: BoxDecoration(
                  color: color.withValues(alpha: i == 0 ? 0.95 : 0.62),
                  borderRadius: BorderRadius.circular(5),
                ),
              ),
            ),
            const SizedBox(height: 8),
          ],
        ],
      ),
    );
  }
}
