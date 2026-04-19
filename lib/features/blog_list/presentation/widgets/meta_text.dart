import 'package:flutter/material.dart';
import 'package:my_portfolio/core/resources/styles/blog_palette.dart';

class MetaText extends StatelessWidget {
  const MetaText({
    required this.label,
    this.isAccent = false,
    super.key,
  });

  final String label;
  final bool isAccent;

  @override
  Widget build(BuildContext context) {
    final palette = Theme.of(context).blogPalette;

    return Text(
      label,
      style: Theme.of(context).textTheme.bodySmall?.copyWith(
        color: isAccent ? palette.metaAccent : palette.textMuted,
        fontWeight: FontWeight.w800,
        letterSpacing: 0.4,
      ),
    );
  }
}
