import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:my_portfolio/constants/colors.dart';
import 'package:my_portfolio/resources/size_config.dart';

class AnimatedLogo extends StatefulWidget {
  const AnimatedLogo({super.key});

  @override
  State<AnimatedLogo> createState() => AnimatedLogoState();
}

class AnimatedLogoState extends State<AnimatedLogo> {
  bool isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => isHovered = true),
      onExit: (_) => setState(() => isHovered = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
        decoration: BoxDecoration(
          color: isHovered
              ? CustomColor.secondary.withValues(alpha: 0.1)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Text(
              'Aabhash Rai',
              style: GoogleFonts.notoSans(
                fontSize: getProportionateScreenHeight(20),
                fontWeight: FontWeight.w900,
                foreground: Paint()
                  ..shader = const LinearGradient(
                    colors: [
                      CustomColor.primary,
                      CustomColor.secondary,
                    ],
                  ).createShader(const Rect.fromLTWH(0.0, 0.0, 50.0, 50.0)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
