import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:my_portfolio/core/resources/size_config.dart';
import 'package:my_portfolio/features/home/presentation/widgets/description.dart';

class MainMobile extends StatelessWidget {
  const MainMobile({
    required this.scrollToSection,
    required this.openResume,
    required this.openBlog,
    super.key,
  });

  final VoidCallback scrollToSection;
  final Future<void> Function() openResume;
  final VoidCallback openBlog;

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
      child: Description(
        scrollToSection: scrollToSection,
        openResume: openResume,
        openBlog: openBlog,
      ),
    );
  }
}
