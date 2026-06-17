import 'package:flutter/material.dart';
import 'package:my_portfolio/core/resources/styles/blog_palette.dart';

class BlogTagChip extends StatelessWidget {
  const BlogTagChip({
    required this.tag,
    super.key,
  });

  final String tag;

  @override
  Widget build(BuildContext context) {
    final palette = Theme.of(context).blogPalette;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 11, vertical: 7),
      decoration: BoxDecoration(
        color: palette.tagChipBackground,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        tag.toUpperCase(),
        style: TextStyle(
          color: palette.tagChipForeground,
          fontSize: 11,
          fontWeight: FontWeight.w800,
          letterSpacing: 0.9,
        ),
      ),
    );
  }
}
