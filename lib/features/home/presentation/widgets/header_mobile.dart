import 'package:flutter/material.dart';
import 'package:my_portfolio/core/presentation/widgets/theme_toggle_button.dart';
import 'package:my_portfolio/core/resources/styles/home_palette.dart';

class HeaderMobile extends StatelessWidget {
  const HeaderMobile({
    required this.onOpenNewsletter,
    super.key,
    this.onMenuTap,
  });
  final VoidCallback onOpenNewsletter;
  final VoidCallback? onMenuTap;
  @override
  Widget build(BuildContext context) {
    final palette = Theme.of(context).homePalette;
    return Container(
      height: 50,
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      decoration: BoxDecoration(
        color: palette.surfaceCard,
        borderRadius: BorderRadius.circular(35),
        boxShadow: [
          BoxShadow(
            color: palette.shadowColor.withValues(alpha: 0.1),
            blurRadius: 20,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      // The hero carries the name now; the old logo slot holds the newsletter
      // entry point instead.
      child: Row(
        children: [
          const SizedBox(width: 8),
          TextButton(
            onPressed: onOpenNewsletter,
            style: TextButton.styleFrom(
              foregroundColor: palette.textStrong,
            ),
            child: const Text('Newsletter'),
          ),
          const Spacer(),
          ThemeToggleButton(iconColor: palette.textStrong),
          IconButton(
            onPressed: onMenuTap,
            icon: Icon(Icons.menu, color: palette.textStrong),
          ),
          const SizedBox(width: 15),
        ],
      ),
    );
  }
}
