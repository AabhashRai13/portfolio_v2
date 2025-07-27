
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:my_portfolio/constants/colors.dart';
import 'package:my_portfolio/constants/size.dart';
import 'package:my_portfolio/presentation/widgets/get_in_touch_button.dart';
import 'package:my_portfolio/resources/size_config.dart';

class Description extends StatelessWidget {
  const Description({
    required this.scrollToSection, super.key,
  });

  final VoidCallback scrollToSection;

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
  
    return Padding(
      padding: EdgeInsets.symmetric(
          horizontal: 40,
          vertical: screenSize.width < 750 ? 20 : 0,), // improve alignment
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
            if(screenSize.height > 500)
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('I am Aabhash Rai',
                  style: GoogleFonts.poppins(
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                    color: CustomColor.textPrimary, // dark brown
                  ),),
              Text('• Based in Sydney',
                  style: GoogleFonts.poppins(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: CustomColor.textSecondary, // light brown
                  ),),
              Text('• Flutter Developer',
                  style: GoogleFonts.poppins(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: CustomColor.textSecondary, // light brown
                  ),),
              Text('• 5+ years of experien',
                  style: GoogleFonts.poppins(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: CustomColor.textSecondary, // light brown
                  ),),
             
            
            ],
          ),
          const SizedBox(height: 25),
          // contact btn with hover effects and shadow
           if (screenSize.height > 300)
          GetInTouchButton(scrollToSection: scrollToSection),
        ],
      ),
    );
  }
}
