import 'package:flutter/material.dart';
import 'package:my_portfolio/presentation/widgets/description.dart';
import 'package:my_portfolio/resources/size_config.dart';

class MainMobile extends StatelessWidget {
  const MainMobile({required this.scrollToSection, super.key});

  final Function scrollToSection;

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final screenHeight = screenSize.height;

    return Container(
      margin: const EdgeInsets.symmetric(
        horizontal: 5,
        vertical: 30,
      ),
      height: screenHeight * 0.8,
      constraints: BoxConstraints(
        minHeight: getProportionateScreenHeight(500),
      ),
      child: Column(
        children: [
          // avatar img
          SizedBox(height: getProportionateScreenHeight(20)),

          //intro message
          Description(scrollToSection: scrollToSection),
        ],
      ),
    );
  }
}
