import 'package:flutter/material.dart';
import 'package:my_portfolio/presentation/widgets/bounce_man_animation_mobile.dart';
import 'package:my_portfolio/presentation/widgets/description.dart';

class MainMobile extends StatelessWidget {
  final Function scrollToSection;
  const MainMobile({super.key, required this.scrollToSection});

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final screenHeight = screenSize.height;

    return Container(
      margin: const EdgeInsets.symmetric(
        horizontal: 5.0,
        vertical: 30.0,
      ),
      height: screenHeight,
      constraints: const BoxConstraints(
        minHeight: 560.0,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // avatar img
          const SizedBox(height: 30),
          const BounceManAnimationMobile(),
          const SizedBox(height: 10),
          //intro message
          Description(scrollToSection: scrollToSection),
        ],
      ),
    );
  }
}
