import 'package:flutter/material.dart';
import 'package:my_portfolio/core/presentation/widgets/animated_logo.dart';
import 'package:my_portfolio/core/presentation/widgets/theme_toggle_button.dart';
import 'package:my_portfolio/core/resources/styles/blog_palette.dart';

class BlogTopNavigationBar extends StatelessWidget {
  const BlogTopNavigationBar({
    required this.onOpenHome,
    this.onOpenBlogList,
    super.key,
  });

  final VoidCallback onOpenHome;
  final VoidCallback? onOpenBlogList;

  @override
  Widget build(BuildContext context) {
    final palette = Theme.of(context).blogPalette;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 4),
      decoration: BoxDecoration(
        color: palette.surfaceSubtle,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: palette.borderSoft),
        boxShadow: <BoxShadow>[
          BoxShadow(
            color: palette.shadowColor,
            blurRadius: 18,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Row(
        children: <Widget>[
          _HomeLogoButton(onTap: onOpenHome),
          const Spacer(),
          if (onOpenBlogList != null) ...<Widget>[
            _NavigationPillButton(
              icon: Icons.article_outlined,
              label: 'All posts',
              onTap: onOpenBlogList!,
            ),
            const SizedBox(width: 12),
          ],
          _ThemePill(palette: palette),
        ],
      ),
    );
  }
}

class _HomeLogoButton extends StatelessWidget {
  const _HomeLogoButton({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      type: MaterialType.transparency,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: const AnimatedLogo(),
      ),
    );
  }
}

class _ThemePill extends StatelessWidget {
  const _ThemePill({required this.palette});

  final BlogPalette palette;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: palette.surfaceElevated,
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: palette.borderSoft),
        boxShadow: <BoxShadow>[
          BoxShadow(
            color: palette.shadowColor,
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ThemeToggleButton(iconColor: palette.textMuted),
    );
  }
}

class _NavigationPillButton extends StatefulWidget {
  const _NavigationPillButton({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final VoidCallback onTap;

  @override
  State<_NavigationPillButton> createState() => _NavigationPillButtonState();
}

class _NavigationPillButtonState extends State<_NavigationPillButton> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    final palette = Theme.of(context).blogPalette;

    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        curve: Curves.easeOutCubic,
        decoration: BoxDecoration(
          color: _isHovered
              ? palette.tagChipBackground
              : palette.surfaceElevated,
          borderRadius: BorderRadius.circular(999),
          border: Border.all(
            color: _isHovered ? palette.metaAccent : palette.borderSoft,
          ),
          boxShadow: <BoxShadow>[
            BoxShadow(
              color: palette.shadowColor,
              blurRadius: _isHovered ? 16 : 10,
              offset: Offset(0, _isHovered ? 7 : 4),
            ),
          ],
        ),
        child: Material(
          type: MaterialType.transparency,
          child: InkWell(
            onTap: widget.onTap,
            borderRadius: BorderRadius.circular(999),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Icon(
                    widget.icon,
                    size: 18,
                    color: palette.textStrong,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    widget.label,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: palette.textStrong,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
