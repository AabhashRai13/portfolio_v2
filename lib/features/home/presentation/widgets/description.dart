import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:my_portfolio/constants/colors.dart';
import 'package:my_portfolio/core/resources/size_config.dart';
import 'package:my_portfolio/features/home/presentation/widgets/get_in_touch_button.dart';

class Description extends StatelessWidget {
  const Description({
    required this.scrollToSection,
    required this.openBlog,
    required this.openNewsletter,
    super.key,
  });

  final VoidCallback scrollToSection;
  final VoidCallback openBlog;
  final VoidCallback openNewsletter;

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final isCompact = screenSize.width < 750;
    final nameSize = isCompact ? 44.0 : 64.0;
    final bodySize = isCompact ? 16.0 : 19.0;

    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: 40,
        vertical: screenSize.width < 750 ? 20 : 0,
      ), // improve alignment
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start, // align text to left
        children: [
          // Name — the dominant, memorable element of the hero.
          Text(
            'Aabhash Rai',
            style: GoogleFonts.poppins(
              fontSize: nameSize,
              height: 1.05,
              fontWeight: FontWeight.w800,
              letterSpacing: -1,
              color: CustomColor.textPrimary, // dark brown
            ),
          ),
          if (screenSize.height > 420) ...[
            const SizedBox(height: 20),
            ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 560),
              child: Text(
                'I build mobile apps for a living: rock-solid when it counts, '
                'a little extra when it gets to be fun.',
                style: GoogleFonts.poppins(
                  fontSize: bodySize,
                  height: 1.5,
                  fontWeight: FontWeight.w500,
                  color: CustomColor.textPrimary, // dark brown
                ),
              ),
            ),
          ],
          const SizedBox(height: 28),
          if (screenSize.height > 300)
            Wrap(
              spacing: 14,
              runSpacing: 14,
              children: [
                GetInTouchButton(scrollToSection: scrollToSection),
                _SecondaryActionButton(
                  label: 'Blog',
                  onTap: openBlog,
                ),
                _SecondaryActionButton(
                  label: 'Newsletter',
                  onTap: openNewsletter,
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
