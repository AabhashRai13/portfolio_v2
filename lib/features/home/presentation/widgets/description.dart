import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:my_portfolio/core/resources/size_config.dart';
import 'package:my_portfolio/core/resources/styles/home_palette.dart';
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
    final palette = Theme.of(context).homePalette;
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
          // Editorial serif + warm gradient makes the name the memorable hook.
          ShaderMask(
            shaderCallback: (bounds) => LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: palette.nameGradient,
            ).createShader(bounds),
            child: Text(
              'Aabhash Rai',
              style: GoogleFonts.playfairDisplay(
                fontSize: nameSize,
                height: 1,
                fontWeight: FontWeight.w800,
                letterSpacing: -1,
                color: Colors.white, // painted over by the shader
              ),
            ),
          ),
          if (screenSize.height > 420) ...[
            const SizedBox(height: 20),
            ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 560),
              child: Text.rich(
                TextSpan(
                  style: GoogleFonts.poppins(
                    fontSize: bodySize,
                    height: 1.5,
                    fontWeight: FontWeight.w500,
                    color: palette.textSecondary, // medium brown
                  ),
                  children: [
                    const TextSpan(
                      text: 'I build mobile apps for a living: ',
                    ),
                    TextSpan(
                      text: 'rock-solid',
                      style: TextStyle(
                        fontWeight: FontWeight.w700,
                        color: palette.textStrong, // dark brown
                      ),
                    ),
                    const TextSpan(
                      text: ' when it counts, a little extra when it gets '
                          'to be ',
                    ),
                    TextSpan(
                      text: 'fun',
                      style: TextStyle(
                        fontWeight: FontWeight.w700,
                        color: palette.secondaryAccent, // muted coral
                      ),
                    ),
                    const TextSpan(text: '.'),
                  ],
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
    final palette = Theme.of(context).homePalette;
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
            color: palette.surfaceCard.withValues(alpha: 0.65),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: palette.primaryAccent.withValues(alpha: 0.25),
            ),
          ),
          child: Text(
            label,
            style: GoogleFonts.poppins(
              color: palette.textStrong,
              fontSize: fontSize,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
    );
  }
}
