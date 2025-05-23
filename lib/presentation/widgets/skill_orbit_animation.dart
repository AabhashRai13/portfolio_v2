import 'dart:math';
import 'package:flutter/material.dart';
import 'package:my_portfolio/constants/skill_items.dart';
import 'package:flutter/scheduler.dart';
import 'package:my_portfolio/entity/orbit_icon.dart';
import 'package:my_portfolio/presentation/widgets/animated_icons.dart';
import 'package:my_portfolio/presentation/widgets/dash_3d.dart';

class OrbitLinesPainter extends CustomPainter {
  final List<double> radii;
  final Offset center;

  OrbitLinesPainter({required this.radii, required this.center});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.black.withValues(alpha: 0.2)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.0;

    for (final radius in radii) {
      // Create a path for the circle
      final path = Path()
        ..addOval(Rect.fromCircle(center: center, radius: radius));

      // Create a dash pattern
      final dashPath = Path();
      const dashWidth = 5.0;
      const dashSpace = 5.0;
      const dashArray = [dashWidth, dashSpace];

      // Draw the dashed circle
      final dashPathMetrics = path.computeMetrics();
      for (final metric in dashPathMetrics) {
        double distance = 0;
        while (distance < metric.length) {
          final length = dashArray[0];
          dashPath.addPath(
            metric.extractPath(distance, distance + length),
            Offset.zero,
          );
          distance += length + dashArray[1];
        }
      }

      canvas.drawPath(dashPath, paint);
    }
  }

  @override
  bool shouldRepaint(covariant OrbitLinesPainter oldDelegate) =>
      oldDelegate.center != center || oldDelegate.radii != radii;
}

class SkillOrbitDemo extends StatefulWidget {
  final Offset? mousePosition;
  const SkillOrbitDemo({super.key, this.mousePosition});

  @override
  SkillOrbitDemoState createState() => SkillOrbitDemoState();
}

class SkillOrbitDemoState extends State<SkillOrbitDemo>
    with SingleTickerProviderStateMixin {
  late final Ticker _ticker;
  double _elapsedSeconds = 0;
  final List<OrbitingIcon> _icons = [];

  @override
  void initState() {
    super.initState();
    _ticker = createTicker((elapsed) {
      setState(() {
        _elapsedSeconds = elapsed.inMilliseconds / 1000.0;
      });
    })
      ..start();

    final random = Random();
    final int n = skillItems.length;
    const numRings = 2; // You can adjust this
    final int iconsPerRing = (n / numRings).ceil();
    const baseRadius = 160;
    const ringSpacing = 100; // Distance between rings

    int iconIndex = 0;
    for (int ring = 0; ring < numRings; ring++) {
      double radius = (baseRadius + ring * ringSpacing) as double;
      int iconsThisRing = (ring == numRings - 1)
          ? n - iconIndex // last ring gets the remainder
          : iconsPerRing;
      for (int i = 0; i < iconsThisRing; i++) {
        var skill = skillItems[iconIndex++];
        double angle = (2 * pi * i) / iconsThisRing;

        // Set speed: ring 0 (inner) = fixed, ring 1 (outer) = random
        double speed;
        if (ring == 0) {
          speed = 0.06; // slower fixed value for the inner ring
        } else {
          speed =
              0.03 + random.nextDouble() * 0.07; // slower random for outer ring
        }

        _icons.add(
          OrbitingIcon(
            iconData: skill["icon"] as IconData,
            baseRadius: radius,
            speed: speed,
            initialAngle: angle,
            wobbleFreq: 0.5 + random.nextDouble() * 1.5,
            wobbleAmp: 10 + random.nextDouble() * 20,
            targetSpeed: min(0.6, 0.2 + random.nextDouble() * 0.4),
            speedLerpT: 1.0,
            color: skill["color"] as Color,
          ),
        );
      }
    }
  }

  @override
  void dispose() {
    _ticker.dispose();
    super.dispose();
  }

  Offset _calculatePosition(
      double angle, double radius, Offset center, Size iconSize) {
    return Offset(
      center.dx + cos(angle) * radius - iconSize.width / 2,
      center.dy + sin(angle) * radius - iconSize.height / 2,
    );
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final Size widgetSize =
            Size(constraints.maxWidth, constraints.maxHeight);
        final Offset center = widgetSize.center(Offset.zero);

        // Get unique radii for orbit lines
        final radii = _icons.map((icon) => icon.baseRadius).toSet().toList();

        return Stack(
          children: [
            // Orbit lines
            CustomPaint(
              size: widgetSize,
              painter: OrbitLinesPainter(
                radii: radii,
                center: center,
              ),
            ),
            // Center image (you)
             Align(
              alignment: Alignment.center,
              child: FlutterDash3D(
                mousePosition: widget.mousePosition,
              ),
            ),
            // Orbiting icons
            ..._icons.map((icon) {
              double angle =
                  icon.initialAngle + _elapsedSeconds * 2 * pi * icon.speed;
              final pos = _calculatePosition(
                  angle, icon.baseRadius, center, const Size(70, 70));
              return Positioned(
                left: pos.dx,
                top: pos.dy,
                child: AnimatedSkillIcons(icon: icon),
              );
            }),
          ],
        );
      },
    );
  }
}
