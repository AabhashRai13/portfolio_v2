import 'dart:math';
import 'package:flutter/material.dart';
import 'package:my_portfolio/constants/skill_items.dart';
import 'package:flutter/scheduler.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:my_portfolio/presentation/widgets/bounce_man_animation.dart';

class SkillOrbitDemo extends StatefulWidget {
  const SkillOrbitDemo({super.key});

  @override
  SkillOrbitDemoState createState() => SkillOrbitDemoState();
}

class SkillOrbitDemoState extends State<SkillOrbitDemo>
    with SingleTickerProviderStateMixin {
  late final Ticker _ticker;
  double _elapsedSeconds = 0;
  final List<_OrbitingIcon> _icons = [];

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
          _OrbitingIcon(
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

        return Stack(
          children: [
            // Center image (you)
            const Align(
              alignment: Alignment.center,
              child: BounceManAnimation(),
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
                child: FaIcon(
                  icon.iconData,
                  size: 70,
                  color: icon.color,
                  shadows: [
                    Shadow(
                      color: Colors.black.withOpacity(0.3),
                      blurRadius: 8,
                      offset: const Offset(4, 4),
                    ),
                  ],
                ),
              );
            }),
          ],
        );
      },
    );
  }
}

class _OrbitingIcon {
  final IconData iconData;
  final double baseRadius;
  double speed;
  final double initialAngle;
  final double wobbleFreq;
  final double wobbleAmp;
  double targetSpeed;
  double speedLerpT;
  final Color color;

  _OrbitingIcon({
    required this.iconData,
    required this.baseRadius,
    required this.speed,
    required this.initialAngle,
    required this.wobbleFreq,
    required this.wobbleAmp,
    required this.targetSpeed,
    required this.speedLerpT,
    required this.color,
  });
}
