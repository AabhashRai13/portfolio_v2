import 'package:flutter/material.dart';

/// Work tile: an app screen assembling itself from wireframe blocks.
class WorkTilePreview extends StatelessWidget {
  const WorkTilePreview({
    required this.progress,
    required this.color,
    super.key,
  });

  final double progress;
  final Color color;

  @override
  Widget build(BuildContext context) => CustomPaint(
    painter: _WorkPreviewPainter(progress: progress, color: color),
  );
}

class _WorkPreviewPainter extends CustomPainter {
  const _WorkPreviewPainter({required this.progress, required this.color});

  final double progress;
  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = color;
    final outline = Paint()
      ..color = color.withValues(alpha: 0.48)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;
    final reveal = Curves.easeInOutCubic.transform(
      (progress / 0.72).clamp(0.0, 1.0),
    );

    final screen = RRect.fromRectAndRadius(
      Rect.fromLTWH(
        size.width * 0.2,
        size.height * 0.25,
        size.width * 0.6,
        size.height * 0.58,
      ),
      const Radius.circular(9),
    );
    canvas.drawRRect(screen, outline);

    final blocks = <Rect>[
      Rect.fromLTWH(
        size.width * 0.27,
        size.height * 0.34,
        size.width * 0.46,
        size.height * 0.11,
      ),
      Rect.fromLTWH(
        size.width * 0.27,
        size.height * 0.5,
        size.width * 0.2,
        size.height * 0.2,
      ),
      Rect.fromLTWH(
        size.width * 0.52,
        size.height * 0.5,
        size.width * 0.21,
        size.height * 0.2,
      ),
    ];

    for (var i = 0; i < blocks.length; i++) {
      final amount = ((reveal * blocks.length) - i).clamp(0.0, 1.0);
      final rect = blocks[i];
      canvas.drawRRect(
        RRect.fromRectAndRadius(
          Rect.fromLTWH(rect.left, rect.top, rect.width * amount, rect.height),
          const Radius.circular(5),
        ),
        paint..color = color.withValues(alpha: 0.28 + (amount * 0.54)),
      );
    }
  }

  @override
  bool shouldRepaint(_WorkPreviewPainter oldDelegate) =>
      progress != oldDelegate.progress || color != oldDelegate.color;
}
