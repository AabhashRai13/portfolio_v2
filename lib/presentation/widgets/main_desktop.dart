import 'package:flutter/material.dart';
import 'package:my_portfolio/presentation/widgets/description.dart';

class MainDesktop extends StatelessWidget {

  const MainDesktop({
    required this.scrollToSection, super.key,
  });
  final Function scrollToSection;

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final screenHeight = screenSize.height;
    return Container(
      margin: const EdgeInsets.symmetric(
        horizontal: 20,
      ),
      height: screenSize.width < 750 ? screenHeight * 0.7 : screenHeight * 0.8,
      constraints: const BoxConstraints(
        minHeight: 350,
      ),
      child: screenSize.width < 750
          ? Description(
              scrollToSection: scrollToSection,
            )
          : Row(
              children: [
                Expanded(
                  child: Description(
                    scrollToSection: scrollToSection,
                  ),
                ),
              ],
            ),
    );
  }
}
