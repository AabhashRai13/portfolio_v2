import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:my_portfolio/presentation/widgets/animated_logo.dart';
import 'package:my_portfolio/resources/size_config.dart';
import '../../constants/nav_items.dart';
import '../../constants/colors.dart';

class HeaderDesktop extends StatelessWidget {
  const HeaderDesktop({
    super.key,
    required this.onNavMenuTap,
  });
  final Function(int) onNavMenuTap;

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
        color: Colors.white.withOpacity(0.9),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: CustomColor.primary.withOpacity(0.1),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: CustomColor.primary.withOpacity(0.1),
            blurRadius: 20,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const AnimatedLogo(),
                const Spacer(),
                if (SizeConfig.screenWidth >= 1000)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      for (int i = 0; i < navTitles.length; i++)
                        Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 10,
                          ),
                          child: _NavButton(
                            title: navTitles[i],
                            onTap: () => onNavMenuTap(i),
                            isResume: i == 5,
                          ),
                        ),
                    ],
                  )
                else
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      for (int i = navTitles.length - 2;
                          i < navTitles.length;
                          i++)
                        Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 10,
                          ),
                          child: _NavButton(
                            title: navTitles[i],
                            onTap: () => onNavMenuTap(i),
                            isResume: i == 5,
                          ),
                        ),
                    ],
                  ),
              ],
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
  final bool isResume;

  const _NavButton({
    required this.title,
    required this.onTap,
    required this.isResume,
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
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          decoration: BoxDecoration(
            color: widget.isResume
                ? (isHovered
                    ? CustomColor.secondary
                    : CustomColor.secondary.withOpacity(0.1))
                : (isHovered
                    ? CustomColor.primary.withOpacity(0.1)
                    : Colors.transparent),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: widget.isResume
                  ? CustomColor.secondary
                  : (isHovered ? CustomColor.primary : Colors.transparent),
              width: widget.isResume ? 2 : 1.5,
            ),
            boxShadow: widget.isResume
                ? [
                    BoxShadow(
                      color: CustomColor.secondary.withOpacity(0.1),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ]
                : null,
          ),
          child: Text(
            widget.title,
            style: GoogleFonts.poppins(
              fontSize: widget.isResume ? 17 : 16,
              fontWeight: widget.isResume
                  ? FontWeight.w600
                  : (isHovered ? FontWeight.w600 : FontWeight.w500),
              color: widget.isResume
                  ? (isHovered ? Colors.white : CustomColor.secondary)
                  : (isHovered ? CustomColor.primary : CustomColor.textPrimary),
              letterSpacing: 0.3,
            ),
          ),
        ),
      ),
    );
  }
}
