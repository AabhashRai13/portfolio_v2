import 'dart:math';

import 'package:flutter/material.dart';
import 'package:my_portfolio/resources/asset_manager.dart';

class BounceManAnimationMobile extends StatefulWidget {
  const BounceManAnimationMobile({super.key});

  @override
  State<BounceManAnimationMobile> createState() =>
      _BounceManAnimationStateMobile();
}

class _BounceManAnimationStateMobile extends State<BounceManAnimationMobile>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    )..repeat(reverse: true);

    _animation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Responsive sizing
    final screenWidth = MediaQuery.of(context).size.width;
    final avatarRadius = screenWidth < 400 ? 90.0 : 120.0;
    final bounceHeight = screenWidth < 400 ? 12.0 : 18.0;
    final shadowBaseWidth = screenWidth < 400 ? 60.0 : 90.0;
    final shadowBaseHeight = screenWidth < 400 ? 12.0 : 18.0;

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        AnimatedBuilder(
          animation: _animation,
          builder: (context, child) {
            final bounce = -bounceHeight * _animation.value;
            return Transform.translate(
              offset: Offset(0, bounce),
              child: child,
            );
          },
          child: Stack(
            alignment: Alignment.center,
            children: [
              Image.asset(
                ImageAssets.mandala,
                width: avatarRadius,
                height: avatarRadius,
              ),
              Transform.translate(
                offset: const Offset(7, 0), // Move 10 pixels to the right
                child: Image.asset(
                  ImageAssets.meditatingMan,
                  width: avatarRadius,
                  height: avatarRadius,
                ),
              ),
            ],
          ),
        ),
        AnimatedBuilder(
          animation: _animation,
          builder: (context, child) {
            final t = _animation.value;
            final shadowWidth = shadowBaseWidth + 20 * (1 - t);
            final shadowHeight = shadowBaseHeight - 4 * (1 - t);
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

class IrregularShadowPainter extends CustomPainter {

  IrregularShadowPainter({required this.opacity, required this.t});
  final double opacity;
  final double t;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.black.withValues(alpha: opacity)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 8);

    final path = Path();
    final cx = size.width / 2;
    final cy = size.height / 2;
    const points = 32;
    for (var i = 0; i <= points; i++) {
      final theta = 2 * pi * i / points;
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
