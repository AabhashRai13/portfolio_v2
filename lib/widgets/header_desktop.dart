import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../constants/nav_items.dart';
import '../constants/colors.dart';

class HeaderDesktop extends StatelessWidget {
  const HeaderDesktop({
    super.key,
    required this.onNavMenuTap,
  });
  final Function(int) onNavMenuTap;

  // Define gold colors for consistent use
  static const Color goldPrimary = Color(0xFFBF9B30);    // Rich gold
  static const Color goldLight = Color(0xFFDFBF68);      // Light gold
  static const Color goldDark = Color(0xFF8B7355);       // Dark gold accent

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 75.0,
      margin: const EdgeInsets.symmetric(
        vertical: 15.0,
        horizontal: 30.0,
      ),
      width: double.maxFinite,
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.7),
        borderRadius: BorderRadius.circular(35),
        border: Border.all(
          color: goldLight.withOpacity(0.3),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: goldPrimary.withOpacity(0.08),
            blurRadius: 20,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(35),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25),
            child: Row(
              children: [
                _AnimatedLogo(
                  onTap: () {},
                  goldColor: goldPrimary,
                ),
                const Spacer(),
                for (int i = 0; i < navTitles.length; i++)
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    child: _NavButton(
                      title: navTitles[i],
                      onTap: () => onNavMenuTap(i),
                      goldColor: goldPrimary,
                      goldLight: goldLight,
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _AnimatedLogo extends StatefulWidget {
  final VoidCallback onTap;
  final Color goldColor;

  const _AnimatedLogo({
    required this.onTap,
    required this.goldColor,
  });

  @override
  State<_AnimatedLogo> createState() => _AnimatedLogoState();
}

class _AnimatedLogoState extends State<_AnimatedLogo> {
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
          color: isHovered ? widget.goldColor.withOpacity(0.1) : Colors.transparent,
          borderRadius: BorderRadius.circular(20),
        ),
        child: ShaderMask(
          shaderCallback: (bounds) => LinearGradient(
            colors: [
              widget.goldColor,
              HeaderDesktop.goldLight,
            ],
          ).createShader(bounds),
          child: Text(
            'AR',
            style: GoogleFonts.poppins(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.white, // This will be masked by the gradient
            ),
          ),
        ),
      ),
    );
  }
}

class _NavButton extends StatefulWidget {
  final String title;
  final VoidCallback onTap;
  final Color goldColor;
  final Color goldLight;

  const _NavButton({
    required this.title,
    required this.onTap,
    required this.goldColor,
    required this.goldLight,
  });

  @override
  State<_NavButton> createState() => _NavButtonState();
}

class _NavButtonState extends State<_NavButton> {
  bool isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => isHovered = true),
      onExit: (_) => setState(() => isHovered = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        decoration: BoxDecoration(
          color: isHovered ? CustomColor.primary.withOpacity(0.1) : Colors.transparent,
          borderRadius: BorderRadius.circular(25),
          border: isHovered ? Border.all(
            color: CustomColor.primary.withOpacity(0.3),
            width: 1,
          ) : null,
        ),
        child: Text(
          widget.title,
          style: GoogleFonts.poppins(
            fontSize: 16,
            fontWeight: isHovered ? FontWeight.w600 : FontWeight.w500,
            color: isHovered ? CustomColor.primary : CustomColor.textGold,
            letterSpacing: 0.3,
          ),
        ),
      ),
    );
  }
}
