import 'package:flutter/material.dart';
import 'package:my_portfolio/presentation/widgets/description.dart';
import 'package:my_portfolio/presentation/widgets/skill_orbit_animation.dart';

class MainDesktop extends StatelessWidget {
  final Function scrollToSection;
  const MainDesktop({super.key, required this.scrollToSection});

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
      child: screenSize.width < 750
          ? Description(
              scrollToSection: scrollToSection,
            )
          :  Row(
              children: [
                Expanded(
                  flex: 1,
                  child: Description(
                    scrollToSection: scrollToSection,
                  ),
                ),
             const   Expanded(
                  flex: 2,
                  child: SkillOrbitDemo(),
                ),
              ],
            ),
    );
  }
}
