import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:my_portfolio/constants/colors.dart';
import 'package:my_portfolio/constants/size.dart';
import 'package:my_portfolio/resources/size_config.dart';
import 'package:my_portfolio/presentation/widgets/get_in_touch_button.dart';

class Description extends StatelessWidget {
  const Description({
    super.key,
    required this.scrollToSection,
  });

  final Function scrollToSection;

  @override
  Widget build(BuildContext context) {
     final screenSize = MediaQuery.of(context).size;
    return Padding(
      padding:  EdgeInsets.symmetric(horizontal: 40.0, vertical: screenSize.width < 750? 20:0), // improve alignment
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
                  text: "HIGH-PERFORMING APPS\n",
                  style: GoogleFonts.poppins(
                    color: CustomColor.textPrimary, // dark brown
                    fontSize: 32,
                    fontWeight: FontWeight.w900,
                    letterSpacing: 1.2,
                  ),
                ),
                const TextSpan(text: "with "),
                TextSpan(
                  text: "SCALABLE ARCHITECTURE",
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
          RichText(
            textAlign: TextAlign.left,
            maxLines: 6,
            overflow: TextOverflow.ellipsis,
            text: TextSpan(
              style: GoogleFonts.poppins(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                height: 1.7,
                color: CustomColor.textPrimary, // dark brown
                letterSpacing: 0.5,
                shadows: [
                  Shadow(
                    color: Colors.black.withValues(alpha: 0.08),
                    blurRadius: 4,
                    offset: const Offset(1, 2),
                  ),
                ],
              ),
              children: [
                const TextSpan(text: "I'm "),
                TextSpan(
                  text: "Aabhash Rai",
                  style: GoogleFonts.poppins(
                    color: CustomColor.textPrimary, // dark brown
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
                const TextSpan(text: ", a Sydney-based "),
                const TextSpan(
                  text: "Flutter developer",
                  style: TextStyle(
                    color: CustomColor.primary, // light brown
                    fontWeight: FontWeight.w900,
                    fontSize: 18,
                  ),
                ),
                const TextSpan(text: " with over "),
                const TextSpan(
                  text: "5 years of experience",
                  style: TextStyle(
                    color: CustomColor.primary, // light brown
                    fontWeight: FontWeight.w900,
                    fontSize: 18,
                  ),
                ),
                const TextSpan(text: ". I'm a blend of "),
                const TextSpan(
                  text: "creativity, innovation, professionalism, and passion",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: CustomColor.textPrimary, // dark brown
                    fontSize: 18,
                  ),
                ),
                const TextSpan(
                  text:
                      " — turning bold ideas into seamless digital experiences users love.",
                ),
              ],
            ),
          ),

          const SizedBox(height: 25),
          // contact btn with hover effects and shadow
          GetInTouchButton(scrollToSection: scrollToSection),
        ],
      ),
    );
  }
}
