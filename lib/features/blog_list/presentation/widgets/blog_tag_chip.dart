import 'package:flutter/material.dart';

class BlogTagChip extends StatelessWidget {
  const BlogTagChip({
    required this.tag,
    super.key,
  });

  final String tag;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 11, vertical: 7),
      decoration: BoxDecoration(
        color: const Color(0xFFF4EEEA),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        tag.toUpperCase(),
        style: const TextStyle(
          color: Color(0xFF8B7D72),
          fontSize: 11,
          fontWeight: FontWeight.w800,
          letterSpacing: 0.9,
        ),
      ),
    );
  }
}
