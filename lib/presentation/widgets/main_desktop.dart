import 'package:flutter/material.dart';
import 'package:my_portfolio/presentation/game/my_game.dart';
import 'package:my_portfolio/presentation/widgets/description.dart';
import 'package:my_portfolio/presentation/widgets/frosted_container_widget.dart';

class MainDesktop extends StatelessWidget {
  const MainDesktop({
    required this.scrollToSection,
    super.key,
  });
  final VoidCallback scrollToSection;

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final screenHeight = screenSize.height;

    return screenSize.width < 750
        ? Container(
            margin: const EdgeInsets.symmetric(
              horizontal: 20,
            ),
            height: screenHeight * 0.7,
            constraints: const BoxConstraints(
              minHeight: 350,
            ),
            child: Description(
              scrollToSection: scrollToSection,
            ),
          )
        : FrostedGlassContainer(
            height: screenHeight * 0.75,
            width: double.maxFinite,
            child: screenSize.width < 1000
                ? Description(
                    scrollToSection: scrollToSection,
                  )
                : Row(
                    children: [
                      Expanded(
                        flex: 3,
                        child: Description(
                          scrollToSection: scrollToSection,
                        ),
                      ),
                      Expanded(
                        flex: 2,
                        child: Container(
                          padding: const EdgeInsets.only(
                            left: 12,
                            top: 12,
                            right: 12,
                            bottom: 12,
                          ),
                          height: screenHeight * 0.75,
                          margin: const EdgeInsets.all(24),
                          decoration: BoxDecoration(
                            color: Colors.black,
                            borderRadius: BorderRadius.circular(48),
                            border: Border.all(
                              color: Colors.grey.shade800,
                              width: 2,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withValues(alpha: 0.05),
                                offset: const Offset(0, 8),
                                blurRadius: 2,
                              ),
                            ],
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(36),
                            child: const MyGame(),
                          ),
                        ),
                      ),
                    ],
                  ),
          );
  }
}
