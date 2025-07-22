import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:my_portfolio/presentation/widgets/description.dart';
import 'package:my_portfolio/resources/size_config.dart';

class MainMobile extends StatelessWidget {
  const MainMobile({required this.scrollToSection, super.key});

  final VoidCallback scrollToSection;

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final screenHeight = screenSize.height;
    log('screenHeight: $screenHeight');
    return Container(
      margin: const EdgeInsets.symmetric(
        horizontal: 5,
        vertical: 30,
      ),
  
      constraints: BoxConstraints(
        minHeight: getProportionateScreenHeight(500),
      ),
      child: Description(scrollToSection: scrollToSection),
    );
  }
}
