import 'package:flutter/material.dart';
import 'package:my_portfolio/presentation/widgets/description.dart';
import 'package:my_portfolio/presentation/widgets/skill_orbit_animation.dart';

class MainDesktop extends StatelessWidget {
  final Function scrollToSection;
  final Offset? mousePosition;
  const MainDesktop(
      {super.key, required this.scrollToSection, this.mousePosition});

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final screenHeight = screenSize.height;
    return Container(
      margin: const EdgeInsets.symmetric(
        horizontal: 20.0,
      ),
      height: screenSize.width < 750? screenHeight*0.7 :screenHeight * 1.4,
      constraints: const BoxConstraints(
        minHeight: 350.0,
      ),
      child: screenSize.width < 750
          ? Description(
              scrollToSection: scrollToSection,
            )
          : Column(
              children: [
                SizedBox(
                  height: screenHeight*0.8,
                  child: SkillOrbitDemo(
                    mousePosition: mousePosition,
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: Description(
                    scrollToSection: scrollToSection,
                  ),
                ),
              ],
            ),
    );
  }
}
