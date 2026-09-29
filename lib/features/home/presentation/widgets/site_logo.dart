import 'package:flutter/material.dart';

import 'package:my_portfolio/core/resources/styles/home_palette.dart';

class SiteLogo extends StatelessWidget {
  const SiteLogo({
    super.key,
    this.onTap,
  });
  final VoidCallback? onTap;
  @override
  Widget build(BuildContext context) {
    final palette = Theme.of(context).homePalette;
    return GestureDetector(
      onTap: onTap,
      child: Text(
        'AR',
        style: TextStyle(
          fontSize: 22,
          fontWeight: FontWeight.bold,
          color: palette.primaryAccent,
        ),
      ),
    );
  }
}
