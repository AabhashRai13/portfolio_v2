import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:my_portfolio/constants/colors.dart';
import 'package:my_portfolio/core/resources/size_config.dart';
import 'package:my_portfolio/features/home/presentation/models/home_navigation_item.dart';
import 'package:my_portfolio/features/home/presentation/widgets/animated_logo.dart';
import 'package:my_portfolio/features/home/presentation/widgets/frosted_container_widget.dart';

class HeaderDesktop extends StatelessWidget {
  const HeaderDesktop({
    required this.navigationItems,
    required this.onNavMenuTap,
    super.key,
  });
  final List<HomeNavigationItem> navigationItems;
  final void Function(HomeNavigationItem) onNavMenuTap;

  @override
  Widget build(BuildContext context) {
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
              const AnimatedLogo(),
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
                          isPrimaryAction:
                              item == navigationItems.last,
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
                      ? CustomColor.secondary
                      : CustomColor.secondary.withValues(alpha: 0.1))
                : (isHovered
                      ? CustomColor.primary.withValues(alpha: 0.1)
                      : Colors.transparent),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: widget.isPrimaryAction
                  ? isHovered
                        ? CustomColor.secondary
                        : Colors.white
                  : (isHovered ? Colors.black : Colors.transparent),
              width: widget.isPrimaryAction ? 2 : 1.5,
            ),
            boxShadow: widget.isPrimaryAction
                ? [
                    BoxShadow(
                      color: CustomColor.secondary.withValues(alpha: 0.1),
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
                  ? Colors.white
                  : CustomColor.textPrimary,
              letterSpacing: 0.3,
            ),
          ),
        ),
      ),
    );
  }
}
