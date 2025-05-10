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
    final avatarRadius = screenWidth < 400 ? 70.0 : 95.0;
    final bounceHeight = screenWidth < 400 ? 12.0 : 18.0;
    final shadowBaseWidth = screenWidth < 400 ? 60.0 : 90.0;
    final shadowBaseHeight = screenWidth < 400 ? 12.0 : 18.0;

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        AnimatedBuilder(
          animation: _animation,
          builder: (context, child) {
            final double bounce = -bounceHeight * _animation.value;
            return Transform.translate(
              offset: Offset(0, bounce),
              child: child,
            );
          },
          child: CircleAvatar(
            radius: avatarRadius,
            backgroundImage: const AssetImage(ImageAssets.meditatingMan),
            backgroundColor: Colors.white,
          ),
        ),
        AnimatedBuilder(
          animation: _animation,
          builder: (context, child) {
            final double t = _animation.value;
            final double shadowWidth = shadowBaseWidth + 20 * (1 - t);
            final double shadowHeight = shadowBaseHeight - 4 * (1 - t);
            final double shadowOpacity = 0.18 + 0.10 * (1 - t);

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
  final double opacity;
  final double t;

  IrregularShadowPainter({required this.opacity, required this.t});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.black.withOpacity(opacity)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 8);

    final path = Path();
    final double cx = size.width / 2;
    final double cy = size.height / 2;
    const points = 32;
    for (int i = 0; i <= points; i++) {
      final double theta = 2 * pi * i / points;
      final double wobble = 1 + 0.08 * sin(theta * 3 + t * 2 * pi);
      final double x = cx + (size.width / 2) * cos(theta) * wobble;
      final double y = cy + (size.height / 2) * sin(theta) * wobble;
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
