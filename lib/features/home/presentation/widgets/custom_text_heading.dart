import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:my_portfolio/constants/size.dart';
import 'package:my_portfolio/core/resources/size_config.dart';
import 'package:my_portfolio/core/resources/styles/home_palette.dart';

class CustomSectionHeading extends StatelessWidget {
  const CustomSectionHeading({
    required this.text,
    super.key,
    this.subText,
    this.icon,
    this.isVideoHeading = false,
  });
  final String text;
  final String? subText;
  final IconData? icon;
  final bool? isVideoHeading;

  @override
  Widget build(BuildContext context) {
    final palette = Theme.of(context).homePalette;
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (icon != null)
              Icon(icon, color: palette.primaryAccent, size: 32),
            const SizedBox(width: 10),
            if (isVideoHeading!)
              Text(
                text,
                style: GoogleFonts.poppins(
                  fontSize: SizeConfig.screenWidth >= kMinDesktopWidth
                      ? 38
                      : 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.white.withValues(alpha: 0.7),
                  letterSpacing: 1.2,
                ),
              )
            else
              ShaderMask(
                shaderCallback: (Rect bounds) {
                  return LinearGradient(
                    colors: palette.accentGradient,
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ).createShader(bounds);
                },
                child: Text(
                  text,
                  style: GoogleFonts.poppins(
                    fontSize: SizeConfig.screenWidth >= kMinDesktopWidth
                        ? 38
                        : 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white.withValues(alpha: 0.7),
                    letterSpacing: 1.2,
                  ),
                ),
              ),
          ],
        ),
        const SizedBox(height: 6),
        Container(
          width: 60,
          height: 4,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(2),
            gradient: LinearGradient(
              colors: isVideoHeading!
                  ? [
                      Colors.white.withValues(alpha: 0.7),
                      Colors.white.withValues(alpha: 0.7),
                    ]
                  : palette.accentGradient,
            ),
          ),
        ),
        const SizedBox(height: 10),
        Text(
          subText ?? 'A selection of my favorite projects',
          style: GoogleFonts.poppins(
            fontSize: 18,
            color: isVideoHeading!
                ? Colors.white.withValues(alpha: 0.7)
                : palette.textSecondary,
            fontWeight: FontWeight.w400,
          ),
        ),
      ],
    );
  }
}
