import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:my_portfolio/core/resources/size_config.dart';
import 'package:my_portfolio/core/resources/styles/home_palette.dart';

class GetInTouchButton extends StatelessWidget {
  const GetInTouchButton({
    required this.scrollToSection,
    super.key,
  });

  final VoidCallback scrollToSection;

  @override
  Widget build(BuildContext context) {
    // Calculate responsive padding and font size
    final palette = Theme.of(context).homePalette;
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
        onTap: scrollToSection,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: EdgeInsets.symmetric(
            horizontal: horizontalPadding,
            vertical: verticalPadding,
          ),
          decoration: BoxDecoration(
            color: palette.secondaryAccent,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: palette.primaryAccent
                    .withValues(alpha: 0.25), // Soft brown shadow
                blurRadius: 8,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Text(
            'Get in touch',
            style: GoogleFonts.poppins(
              color: palette.onAccent,
              fontSize: fontSize,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}
