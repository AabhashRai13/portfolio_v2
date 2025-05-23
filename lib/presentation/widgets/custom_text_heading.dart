import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:my_portfolio/constants/colors.dart';
import 'package:my_portfolio/constants/size.dart';
import 'package:my_portfolio/resources/size_config.dart';

class CustomSectionHeading extends StatelessWidget {
  final String text;
  final String? subText;
  final IconData? icon;
  final bool? isVideoHeading;

  const CustomSectionHeading(
      {super.key,
      required this.text,
      this.subText,
      this.icon,
      this.isVideoHeading = false});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (icon != null) Icon(icon, color: CustomColor.primary, size: 32),
            const SizedBox(width: 10),
            isVideoHeading!
                ? Text(
                    text,
                    style: GoogleFonts.poppins(
                      fontSize:
                          SizeConfig.screenWidth >= kMinDesktopWidth ? 38 : 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white.withValues(alpha: 0.7),
                      letterSpacing: 1.2,
                    ),
                  )
                : ShaderMask(
                    shaderCallback: (Rect bounds) {
                      return const LinearGradient(
                        colors: [CustomColor.primary, CustomColor.pastelRed],
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
            gradient:  LinearGradient(
              colors:isVideoHeading!?[Colors.white.withValues(alpha: 0.7), Colors.white.withValues(alpha: 0.7)]: [CustomColor.primary, CustomColor.pastelRed],
            ),
          ),
        ),
        const SizedBox(height: 10),
        Text(
          subText ?? "A selection of my favorite projects",
          style: GoogleFonts.poppins(
            fontSize: 18,
            color:isVideoHeading!?Colors.white.withValues(alpha: 0.7): CustomColor.textSecondary,
            fontWeight: FontWeight.w400,
          ),
        ),
      ],
    );
  }
}
