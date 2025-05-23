import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:my_portfolio/entity/orbit_icon.dart';

class AnimatedSkillIcons extends StatelessWidget {
  const AnimatedSkillIcons({
    super.key,
    required this.icon,
  });

  final OrbitingIcon icon;

  @override
  Widget build(BuildContext context) {
    return FaIcon(
      icon.iconData,
      size: 70,
      color: icon.color,
      shadows: [
        Shadow(
          color: Colors.black.withValues(alpha: 0.3),
          blurRadius: 8,
          offset: const Offset(4, 4),
        ),
      ],
    );
  }
}
