import 'dart:math';

import 'package:flutter/material.dart';
import 'package:my_portfolio/resources/asset_manager.dart';

class BounceManAnimation extends StatefulWidget {
  const BounceManAnimation({super.key});

  @override
  State<BounceManAnimation> createState() => _BounceManAnimationState();
}

class _BounceManAnimationState extends State<BounceManAnimation>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    )..repeat(reverse: true);

    _animation = CurvedAnimation(
      parent: _controller,
      curve: Curves
          .easeInOut, // You can try Curves.bounceInOut for a bouncier effect
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        AnimatedBuilder(
          animation: _animation,
          builder: (context, child) {
            // The bounce goes from 0 to -40 pixels (up)
            final bounce = -20 * _animation.value;
            return Transform.translate(
              offset: Offset(0, bounce),
              child: child,
            );
          },
          child: Stack(
            alignment: Alignment.center,
            children: [
              Image.asset(
                ImageAssets.light,
                width: 300,
                height: 300,
              ),
              Transform.translate(
                offset: const Offset(10, 0), // Move 10 pixels to the right
                child: Image.asset(
                  ImageAssets.meditatingMan,
                  width: 200,
                  height: 200,
                ),
              ),
            ],
          ),
        ),
        AnimatedBuilder(
          animation: _animation,
          builder: (context, child) {
            final t = _animation.value;

            // Shadow width/height/opacity as before
            final shadowWidth = 120 + 40 * (1 - t);
            final shadowHeight = 24 - 8 * (1 - t);
            final shadowOpacity = 0.18 + 0.10 * (1 - t);

            return CustomPaint(
              size: Size(shadowWidth, shadowHeight),
              painter: IrregularShadowPainter(
                opacity: shadowOpacity,
                t: t,
              ),
            );
          },
        ),
      ],
    );
  }
}

class IrregularShadowPainter extends CustomPainter { // animation value

  IrregularShadowPainter({required this.opacity, required this.t});
  final double opacity;
  final double t;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.black.withValues(alpha: opacity)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 8);

    final path = Path();

    // Draw an ellipse with a little "wobble" for irregularity
    final cx = size.width / 2;
    final cy = size.height / 2;
    const points = 32;
    for (var i = 0; i <= points; i++) {
      final theta = 2 * pi * i / points;
      // Wobble amplitude and frequency
      final wobble = 1 + 0.08 * sin(theta * 3 + t * 2 * pi);
      final x = cx + (size.width / 2) * cos(theta) * wobble;
      final y = cy + (size.height / 2) * sin(theta) * wobble;
      if (i == 0) {
        path.moveTo(x, y);
      } else {
        path.lineTo(x, y);
      }
    }
    path.close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant IrregularShadowPainter oldDelegate) =>
      oldDelegate.opacity != opacity || oldDelegate.t != t;
}
