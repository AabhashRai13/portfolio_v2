import 'package:flutter/material.dart';
import 'package:my_portfolio/widgets/get_in_touch_button.dart';
import 'package:my_portfolio/widgets/skill_orbit_animation.dart';

import '../constants/colors.dart';

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
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // intro message
                Text(
                  "Hi,\nI'm Aabhash Rai\nA Flutter Developer",
                  style: TextStyle(
                    fontSize: 30,
                    height: 1.5,
                    fontWeight: FontWeight.bold,
                    color: CustomColor.textPrimary,
                  ),
                ),
                SizedBox(height: 15),
                // contact btn
                GetInTouchButton()
              ],
            ),
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
