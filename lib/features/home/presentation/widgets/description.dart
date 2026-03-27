import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:my_portfolio/constants/colors.dart';
import 'package:my_portfolio/constants/size.dart';
import 'package:my_portfolio/core/resources/size_config.dart';
import 'package:my_portfolio/features/home/presentation/widgets/get_in_touch_button.dart';

class Description extends StatelessWidget {
  const Description({
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

    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: 40,
        vertical: screenSize.width < 750 ? 20 : 0,
      ), // improve alignment
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start, // align text to left
        children: [
          // intro message
          RichText(
            textAlign: TextAlign.left,
            text: TextSpan(
              style: GoogleFonts.poppins(
                fontSize: 28,
                height: 1.5,
                fontWeight: FontWeight.bold,
                color: CustomColor.textPrimary, // dark brown
              ),
              children: [
                const TextSpan(
                  text: "Let's Build\n",
                ),
                TextSpan(
                  text: 'HIGH-PERFORMING APPS\n',
                  style: GoogleFonts.poppins(
                    color: CustomColor.textPrimary, // dark brown
                    fontSize: 32,
                    fontWeight: FontWeight.w900,
                    letterSpacing: 1.2,
                  ),
                ),
                const TextSpan(text: 'with '),
                TextSpan(
                  text: 'SCALABLE ARCHITECTURE',
                  style: GoogleFonts.poppins(
                    color: CustomColor.primary, // light brown
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ],
            ),
          ),
          if (SizeConfig.screenWidth >= kMinDesktopWidth)
            const SizedBox(height: 20)
          else
            const SizedBox(height: 10),
          if (screenSize.height > 500)
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'I am Aabhash Rai',
                  style: GoogleFonts.poppins(
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                    color: CustomColor.textPrimary, // dark brown
                  ),
                ),
                Text(
                  '• Based in Sydney',
                  style: GoogleFonts.poppins(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: CustomColor.textSecondary, // light brown
                  ),
                ),
                Text(
                  '• Flutter Developer',
                  style: GoogleFonts.poppins(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: CustomColor.textSecondary, // light brown
                  ),
                ),
                Text(
                  '• 5+ years a ',
                  style: GoogleFonts.poppins(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: CustomColor.textSecondary, // light brown
                  ),
                ),
              ],
            ),
          const SizedBox(height: 25),
          if (screenSize.height > 300)
            Wrap(
              spacing: 14,
              runSpacing: 14,
              children: [
                GetInTouchButton(scrollToSection: scrollToSection),
                _SecondaryActionButton(
                  label: 'Resume',
                  onTap: openResume,
                ),
                _SecondaryActionButton(
                  label: 'Blog',
                  onTap: openBlog,
                ),
              ],
            ),
        ],
      ),
    );
  }
}

class _SecondaryActionButton extends StatelessWidget {
  const _SecondaryActionButton({
    required this.label,
    required this.onTap,
  });

  final String label;
  final FutureOr<void> Function()? onTap;

  @override
  Widget build(BuildContext context) {
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
        ? 18.0
        : SizeConfig.screenWidth < 900
        ? 20.0
        : 22.0;

    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: onTap == null ? null : () => onTap!.call(),
        child: Container(
          padding: EdgeInsets.symmetric(
            horizontal: horizontalPadding,
            vertical: verticalPadding,
          ),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.65),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: CustomColor.primary.withValues(alpha: 0.25),
            ),
          ),
          child: Text(
            label,
            style: GoogleFonts.poppins(
              color: CustomColor.textPrimary,
              fontSize: fontSize,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
    );
  }
}
