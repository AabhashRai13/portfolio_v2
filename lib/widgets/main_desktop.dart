import 'package:flutter/material.dart';
import 'package:my_portfolio/widgets/description.dart';
import 'package:my_portfolio/widgets/skill_orbit_animation.dart';

class MainDesktop extends StatelessWidget {
  const MainDesktop({super.key});

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final screenHeight = screenSize.height;

    return Container(
      margin: const EdgeInsets.symmetric(
        horizontal: 20.0,
      ),
      height: screenHeight / 1.2,
      constraints: const BoxConstraints(
        minHeight: 350.0,
      ),
      child: const Row(
        children: [
          Expanded(
            flex: 1,
            child: Description(),
          ),
          Expanded(
            flex: 2,
            child: SkillOrbitDemo(),
          ),
        ],
      ),
    );
  }
}
