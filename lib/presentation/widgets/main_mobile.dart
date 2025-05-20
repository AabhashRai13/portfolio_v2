import 'package:flutter/material.dart';
import 'package:my_portfolio/presentation/widgets/description.dart';
import 'package:my_portfolio/resources/size_config.dart';

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
      height: screenHeight * 0.7,
      constraints: BoxConstraints(
        minHeight: getProportionateScreenHeight(400),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // avatar img
          SizedBox(height: getProportionateScreenHeight(70)),

          //intro message
          Description(scrollToSection: scrollToSection),
        ],
      ),
    );
  }
}
