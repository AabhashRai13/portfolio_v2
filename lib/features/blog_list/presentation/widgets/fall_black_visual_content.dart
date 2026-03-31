import 'package:flutter/material.dart';

class FallbackVisualContent extends StatelessWidget {
  const FallbackVisualContent({
    required this.label,
    required this.title,
    required this.isFeatured,
    super.key,
  });

  final String label;
  final String title;
  final bool isFeatured;

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: isFeatured ? Alignment.bottomLeft : Alignment.center,
      padding: EdgeInsets.all(isFeatured ? 24 : 18),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: <Color>[
            Colors.white.withValues(alpha: 0.08),
            Colors.transparent,
          ],
        ),
      ),
      child: Text(
        isFeatured ? title.toUpperCase() : label,
        maxLines: isFeatured ? 3 : 1,
        overflow: TextOverflow.ellipsis,
        style: TextStyle(
          color: Colors.white.withValues(alpha: isFeatured ? 0.9 : 0.75),
          fontSize: isFeatured ? 22 : 18,
          fontWeight: FontWeight.w800,
          letterSpacing: isFeatured ? 1.8 : 3.6,
          height: 1.15,
        ),
      ),
    );
  }
}
