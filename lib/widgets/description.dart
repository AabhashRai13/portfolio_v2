import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:my_portfolio/constants/colors.dart';
import 'package:my_portfolio/constants/size.dart';
import 'package:my_portfolio/resources/size_config.dart';
import 'package:my_portfolio/widgets/get_in_touch_button.dart';

class Description extends StatelessWidget {
  const Description({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 40.0), // improve alignment
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
                color: CustomColor.textPrimary,
              ),
              children: [
                const TextSpan(
                  text: "Let's Build\n",
                ),
                TextSpan(
                  text: "HIGH-PERFORMING APPS\n",
                  style: GoogleFonts.poppins(
                    color: CustomColor.pastelRed,
                    fontSize: 32,
                    fontWeight: FontWeight.w900,
                    letterSpacing: 1.2,
                  ),
                ),
                const TextSpan(text: "with "),
                TextSpan(
                  text: "SCALABLE ARCHITECTURE",
                  style: GoogleFonts.poppins(
                    color: CustomColor.primary,
                    fontWeight: FontWeight.w900, // darkened weight for contrast
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 20),
          if (SizeConfig.screenWidth >= kMinDesktopWidth)
            RichText(
              textAlign: TextAlign.left,
              maxLines: 6,
              overflow: TextOverflow.ellipsis,
              text: TextSpan(
                style: GoogleFonts.poppins(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  height: 1.7,
                  color: CustomColor.textPrimary,
                  letterSpacing: 0.5,
                  shadows: [
                    Shadow(
                      color: Colors.black.withOpacity(0.08),
                      blurRadius: 4,
                      offset: const Offset(1, 2),
                    ),
                  ],
                ),
                children: [
                  const TextSpan(text: "I'm "),
                  TextSpan(
                    text: "Aabhash Rai",
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.primary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const TextSpan(text: ", a Sydney-based "),
                  TextSpan(
                    text: "Flutter developer",
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.secondary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const TextSpan(text: " with over "),
                  const TextSpan(
                    text: "5 years of experience",
                    style: TextStyle(
                      color: CustomColor.pastelRed,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const TextSpan(text: ". I'm a blend of "),
                  const TextSpan(
                    text: "creativity",
                    style: TextStyle(
                      color: Colors.orange,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const TextSpan(text: ", "),
                  const TextSpan(
                    text: "innovation",
                    style: TextStyle(
                      color: Color(0xFFB0B0B0),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const TextSpan(text: ", "),
                  const TextSpan(
                    text: "professionalism",
                    style: TextStyle(
                      color: Colors.lightBlue,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const TextSpan(text: ", and "),
                  const TextSpan(
                    text: "passion",
                    style: TextStyle(
                      color: Color(0xFFFF0000),
                      fontWeight: FontWeight.bold,
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
          const GetInTouchButton(),
        ],
      ),
    );
  }
}
