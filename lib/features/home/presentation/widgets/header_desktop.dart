import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:my_portfolio/core/presentation/widgets/theme_toggle_button.dart';
import 'package:my_portfolio/core/resources/size_config.dart';
import 'package:my_portfolio/core/resources/styles/home_palette.dart';
import 'package:my_portfolio/features/home/presentation/models/home_navigation_item.dart';
import 'package:my_portfolio/features/home/presentation/widgets/frosted_container_widget.dart';

class HeaderDesktop extends StatelessWidget {
  const HeaderDesktop({
    required this.navigationItems,
    required this.onNavMenuTap,
    required this.onOpenNewsletter,
    super.key,
  });
  final List<HomeNavigationItem> navigationItems;
  final void Function(HomeNavigationItem) onNavMenuTap;
  final VoidCallback onOpenNewsletter;

  @override
  Widget build(BuildContext context) {
    final palette = Theme.of(context).homePalette;
    return FrostedGlassContainer(
      height: 75,
      width: double.maxFinite,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 25),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // The hero carries the name now; the old logo slot holds the
              // newsletter entry point instead.
              _NavButton(
                title: 'Newsletter',
                onTap: onOpenNewsletter,
                isPrimaryAction: false,
              ),
              const Spacer(),
              if (SizeConfig.screenWidth >= 1100)
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    for (final item in navigationItems)
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 10,
                        ),
                        child: _NavButton(
                          title: item.title,
                          onTap: () => onNavMenuTap(item),
                          isPrimaryAction: item == navigationItems.last,
                        ),
                      ),
                  ],
                )
              else
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    for (
                      int i = navigationItems.length - 2;
                      i < navigationItems.length;
                      i++
                    )
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 10,
                        ),
                        child: _NavButton(
                          title: navigationItems[i].title,
                          onTap: () => onNavMenuTap(navigationItems[i]),
                          isPrimaryAction: i == navigationItems.length - 1,
                        ),
                      ),
                  ],
                ),
              const SizedBox(width: 8),
              ThemeToggleButton(iconColor: palette.textStrong),
            ],
          ),
        ),
      ),
    );
  }
}

class _NavButton extends StatefulWidget {
  const _NavButton({
    required this.title,
    required this.onTap,
    required this.isPrimaryAction,
  });
  final String title;
  final VoidCallback onTap;
  final bool isPrimaryAction;

  @override
  State<_NavButton> createState() => _NavButtonState();
}

class _NavButtonState extends State<_NavButton> {
  bool isHovered = false;

  @override
  Widget build(BuildContext context) {
    final palette = Theme.of(context).homePalette;
    return MouseRegion(
      onEnter: (_) => setState(() => isHovered = true),
      onExit: (_) => setState(() => isHovered = false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          decoration: BoxDecoration(
            color: widget.isPrimaryAction
                ? (isHovered
                      ? palette.secondaryAccent
                      : palette.secondaryAccent.withValues(alpha: 0.1))
                : (isHovered
                      ? palette.primaryAccent.withValues(alpha: 0.1)
                      : Colors.transparent),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: widget.isPrimaryAction
                  ? isHovered
                        ? palette.secondaryAccent
                        : palette.onAccent
                  : (isHovered ? palette.textStrong : Colors.transparent),
              width: widget.isPrimaryAction ? 2 : 1.5,
            ),
            boxShadow: widget.isPrimaryAction
                ? [
                    BoxShadow(
                      color: palette.secondaryAccent.withValues(alpha: 0.1),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ]
                : null,
          ),
          child: Text(
            widget.title,
            style: GoogleFonts.poppins(
              fontSize: widget.isPrimaryAction ? 17 : 16,
              fontWeight: widget.isPrimaryAction
                  ? FontWeight.w600
                  : (isHovered ? FontWeight.w600 : FontWeight.w500),
              color: widget.isPrimaryAction
                  ? palette.onAccent
                  : palette.textStrong,
              letterSpacing: 0.3,
            ),
          ),
        ),
      ),
    );
  }
}
