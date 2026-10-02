import 'package:flutter/material.dart';
import 'package:my_portfolio/core/resources/styles/home_palette.dart';
import 'package:my_portfolio/core/resources/styles/site_text.dart';

/// Understated mono caps link used across the site. Keyboard focusable,
/// at least 48 px tall, rose on hover or focus; rose and underlined when
/// [selected] (the page you are on).
class SiteTextLink extends StatefulWidget {
  const SiteTextLink({
    required this.label,
    required this.onTap,
    this.fontSize = 13,
    this.selected = false,
    super.key,
  });

  final String label;
  final VoidCallback onTap;
  final double fontSize;
  final bool selected;

  @override
  State<SiteTextLink> createState() => _SiteTextLinkState();
}

class _SiteTextLinkState extends State<SiteTextLink> {
  bool _active = false;

  @override
  Widget build(BuildContext context) {
    final palette = Theme.of(context).homePalette;

    return Semantics(
      link: true,
      // Null, not false: ordinary links have no selected state at all.
      selected: widget.selected ? true : null,
      child: InkWell(
        onTap: widget.onTap,
        onHover: (value) => setState(() => _active = value),
        onFocusChange: (value) => setState(() => _active = value),
        borderRadius: BorderRadius.circular(6),
        hoverColor: Colors.transparent,
        splashColor: Colors.transparent,
        highlightColor: Colors.transparent,
        child: ConstrainedBox(
          constraints: const BoxConstraints(minHeight: 48),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 6),
            child: Center(
              widthFactor: 1,
              child: Text(
                widget.label.toUpperCase(),
                style:
                    SiteText.label(
                      _active || widget.selected
                          ? palette.linkActive
                          : palette.textStrong,
                      size: widget.fontSize,
                    ).copyWith(
                      decoration: widget.selected
                          ? TextDecoration.underline
                          : null,
                      decorationColor: palette.linkActive,
                      decorationThickness: 2,
                    ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
