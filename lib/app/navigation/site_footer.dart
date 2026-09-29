import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'package:my_portfolio/core/resources/fa_icons.dart';
import 'package:my_portfolio/core/resources/styles/home_palette.dart';

class SiteFooter extends StatelessWidget {
  const SiteFooter({super.key});

  @override
  Widget build(BuildContext context) {
    final palette = Theme.of(context).homePalette;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 24),
      decoration: BoxDecoration(
        color: palette.surfaceMuted,
        border: Border(
          top: BorderSide(
            color: palette.primaryAccent.withValues(alpha: 0.12),
            width: 2,
          ),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Name and heart
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Made by ',
                style: TextStyle(
                  fontWeight: FontWeight.w400,
                  color: palette.textSecondary,
                  fontSize: 16,
                ),
              ),
              Text(
                'Aabhash Rai',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: palette.primaryAccent,
                  fontSize: 17,
                  letterSpacing: 0.5,
                ),
              ),
              const SizedBox(width: 6),
              const Icon(
                Icons.favorite_rounded,
                color: Colors.redAccent,
                size: 18,
              ),
              const SizedBox(width: 6),
              Text(
                'with',
                style: TextStyle(
                  fontWeight: FontWeight.w400,
                  color: palette.textSecondary,
                  fontSize: 16,
                ),
              ),
              const SizedBox(width: 6),
              FaIcon(
                // Non-const on purpose, see fa_icons.dart.
                // ignore: prefer_const_constructors
                FaIconData(FaIcons.flutter),
                color: palette.primaryAccent,
                size: 18,
              ),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            'Built with Flutter 3.47',
            style: TextStyle(
              fontWeight: FontWeight.w400,
              color: palette.textSecondary,
              fontSize: 14,
              letterSpacing: 0.2,
            ),
          ),
        ],
      ),
    );
  }
}
