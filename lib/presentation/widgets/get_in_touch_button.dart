import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:my_portfolio/constants/colors.dart';
import 'package:my_portfolio/resources/size_config.dart';

class GetInTouchButton extends StatelessWidget {
  const GetInTouchButton({
    super.key,
    required this.scrollToSection,
  });

  final Function scrollToSection;

  @override
  Widget build(BuildContext context) {
    // Calculate responsive padding and font size
    // Calculate responsive padding and font size
    final horizontalPadding = SizeConfig.screenWidth < 600
        ? 10.0
        : SizeConfig.screenWidth < 900
            ? 12.0
            : 15.0;
    final verticalPadding = SizeConfig.screenWidth < 600
        ? 10.0
        : SizeConfig.screenWidth < 900
            ? 12.0
            : 15.0;
    final fontSize = SizeConfig.screenWidth < 600
        ? 20.0
        : SizeConfig.screenWidth < 900
            ? 25.0
            : 26.0;

    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: () {
          scrollToSection();
        },
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: EdgeInsets.symmetric(
            horizontal: horizontalPadding,
            vertical: verticalPadding,
          ),
          decoration: BoxDecoration(
            color: CustomColor.pastelRed,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFFBFA181)
                    .withValues(alpha: 0.25), // Soft brown shadow
                blurRadius: 8,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Text(
            'Get in touch',
            style: GoogleFonts.poppins(
              color: Colors.white,
              fontSize: fontSize,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}
