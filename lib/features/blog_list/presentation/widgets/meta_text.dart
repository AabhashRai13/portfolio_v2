import 'package:flutter/material.dart';
import 'package:my_portfolio/constants/colors.dart';

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
    return Text(
      label,
      style: Theme.of(context).textTheme.bodySmall?.copyWith(
        color: isAccent ? CustomColor.primary : const Color(0xFF9E9084),
        fontWeight: FontWeight.w800,
        letterSpacing: 0.4,
      ),
    );
  }
}
