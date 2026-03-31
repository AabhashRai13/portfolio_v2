import 'package:flutter/material.dart';

class OrbitingIcon {
  OrbitingIcon({
    required this.iconData,
    required this.baseRadius,
    required this.speed,
    required this.initialAngle,
    required this.wobbleFreq,
    required this.wobbleAmp,
    required this.color,
  });
  final IconData iconData;
  final double baseRadius;
  double speed;
  final double initialAngle;
  final double wobbleFreq;
  final double wobbleAmp;
  final Color color;
}
