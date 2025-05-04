import 'package:flutter/material.dart';
import 'package:my_portfolio/widgets/bounce_man_animation.dart';
import 'package:my_portfolio/widgets/description.dart';
import 'package:my_portfolio/widgets/get_in_touch_button.dart';

import '../constants/colors.dart';

class MainMobile extends StatelessWidget {
  const MainMobile({super.key});

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final screenHeight = screenSize.height;

    return Container(
      margin: const EdgeInsets.symmetric(
        horizontal: 40.0,
        vertical: 30.0,
      ),
      height: screenHeight,
      constraints: const BoxConstraints(
        minHeight: 560.0,
      ),
      child: const Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // avatar img
          BounceManAnimation(),
          SizedBox(height: 30),
          // intro message
          Description(),
        ],
      ),
    );
  }
}
