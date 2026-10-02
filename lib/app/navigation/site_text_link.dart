import 'package:flutter/material.dart';
import 'package:my_portfolio/core/resources/styles/home_palette.dart';
import 'package:my_portfolio/core/resources/styles/site_text.dart';

/// Understated link used across the site: mono caps by default, or the
/// label as written in the body font when [plain]. Keyboard focusable, at
/// least 48 px tall, rose on hover or focus; rose with a dot in front when
/// [selected] (the page you are on).
class SiteTextLink extends StatefulWidget {
  const SiteTextLink({
    required this.label,
    required this.onTap,
    this.fontSize = 13,
    this.selected = false,
    this.plain = false,
    super.key,
  });

  final String label;
  final VoidCallback onTap;
  final double fontSize;
  final bool selected;
  final bool plain;

  @override
  State<SiteTextLink> createState() => _SiteTextLinkState();
}

class _SiteTextLinkState extends State<SiteTextLink> {
  bool _active = false;

  @override
  Widget build(BuildContext context) {
    final palette = Theme.of(context).homePalette;
    final color = _active || widget.selected
        ? palette.linkActive
        : palette.textStrong;

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
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (widget.selected) ...[
                  DecoratedBox(
                    decoration: BoxDecoration(
                      color: palette.linkActive,
                      shape: BoxShape.circle,
                    ),
                    child: const SizedBox.square(dimension: 7),
                  ),
                  const SizedBox(width: 8),
                ],
                Text(
                  widget.plain ? widget.label : widget.label.toUpperCase(),
                  style: widget.plain
                      ? SiteText.body(color, size: widget.fontSize)
                      : SiteText.label(color, size: widget.fontSize),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
