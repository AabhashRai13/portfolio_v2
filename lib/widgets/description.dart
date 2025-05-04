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
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
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
              TextSpan(
                text: "Let's Build\n",
                style: GoogleFonts.poppins(
                  color: CustomColor.textPrimary,
                  fontSize: 28,
                  height: 1.5,
                  fontWeight: FontWeight.bold,
                ),
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
                  fontWeight: FontWeight.w800,
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height: 15),
        (SizeConfig.screenWidth >= kMinDesktopWidth)
            ? Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(20.0, 0.0, 0.0, 10.0),
                    child: RichText(
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
                  ),
                ],
              )
            : const SizedBox(),

        const SizedBox(height: 15),
        // contact btn
        const GetInTouchButton()
      ],
    );
  }
}
