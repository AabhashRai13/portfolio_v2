import 'package:flutter/material.dart';
import 'package:my_portfolio/presentation/widgets/bounce_man_animation_mobile.dart';
import 'package:my_portfolio/presentation/widgets/description.dart';

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
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // avatar img
          SizedBox(height: 30),
          BounceManAnimationMobile(),
          SizedBox(height: 10),
          //intro message
          Description(),
        ],
      ),
    );
  }
}
