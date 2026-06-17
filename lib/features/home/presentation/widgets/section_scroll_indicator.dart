import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:my_portfolio/constants/colors.dart';
import 'package:my_portfolio/features/home/presentation/models/home_section.dart';

/// A fixed, subtle glass "01 — 05" rail that tracks the section currently in
/// view. It shows only numbers at rest, and on hover it grows and reveals the
/// section names. Tapping a number jumps to that section.
class SectionScrollIndicator extends StatefulWidget {
  const SectionScrollIndicator({
    required this.sections,
    required this.sectionKeys,
    required this.scrollController,
    required this.onSectionTap,
    super.key,
  });

  /// Ordered sections to surface, with their display label.
  final List<({HomeSection section, String label})> sections;

  /// Keys attached to each section in the scroll view, used to read positions.
  final Map<HomeSection, GlobalKey> sectionKeys;

  final ScrollController scrollController;
  final void Function(HomeSection section) onSectionTap;

  @override
  State<SectionScrollIndicator> createState() => _SectionScrollIndicatorState();
}

class _SectionScrollIndicatorState extends State<SectionScrollIndicator> {
  static const _duration = Duration(milliseconds: 220);

  int _activeIndex = 0;
  bool _hovered = false;

  @override
  void initState() {
    super.initState();
    widget.scrollController.addListener(_recomputeActive);
    WidgetsBinding.instance.addPostFrameCallback((_) => _recomputeActive());
  }

  @override
  void dispose() {
    widget.scrollController.removeListener(_recomputeActive);
    super.dispose();
  }

  void _recomputeActive() {
    if (!mounted) {
      return;
    }

    // The active section is the last one whose top has crossed above an
    // imaginary line a third of the way down the viewport.
    final threshold = MediaQuery.of(context).size.height * 0.35;
    var active = 0;
    for (var i = 0; i < widget.sections.length; i++) {
      final top = _topOf(widget.sections[i].section);
      if (top != null && top <= threshold) {
        active = i;
      }
    }

    if (active != _activeIndex) {
      setState(() => _activeIndex = active);
    }
  }

  double? _topOf(HomeSection section) {
    final context = widget.sectionKeys[section]?.currentContext;
    final box = context?.findRenderObject() as RenderBox?;
    if (box == null || !box.attached) {
      return null;
    }
    return box.localToGlobal(Offset.zero).dy;
  }

  @override
  Widget build(BuildContext context) {
    // Hidden on the first (hero) section; fades in from the second onward.
    final visible = _activeIndex > 0;

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        AnimatedOpacity(
          duration: _duration,
          opacity: visible ? 1 : 0,
          child: IgnorePointer(
            ignoring: !visible,
            child: MouseRegion(
              onEnter: (_) => setState(() => _hovered = true),
              onExit: (_) => setState(() => _hovered = false),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(18),
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      vertical: 14,
                      horizontal: 12,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.32),
                      borderRadius: BorderRadius.circular(18),
                      border: Border.all(
                        color: Colors.white.withValues(alpha: 0.45),
                        width: 1.2,
                      ),
                    ),
                    child: AnimatedSize(
                      duration: _duration,
                      curve: Curves.easeOutCubic,
                      alignment: Alignment.centerLeft,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          for (var i = 0; i < widget.sections.length; i++)
                            _IndicatorItem(
                              number: (i + 1).toString().padLeft(2, '0'),
                              label: widget.sections[i].label,
                              isActive: i == _activeIndex,
                              isHovered: _hovered,
                              duration: _duration,
                              onTap: () => widget.onSectionTap(
                                widget.sections[i].section,
                              ),
                            ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _IndicatorItem extends StatelessWidget {
  const _IndicatorItem({
    required this.number,
    required this.label,
    required this.isActive,
    required this.isHovered,
    required this.duration,
    required this.onTap,
  });

  final String number;
  final String label;
  final bool isActive;
  final bool isHovered;
  final Duration duration;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final color = isActive
        ? CustomColor.textPrimary
        : CustomColor.textSecondary.withValues(alpha: isHovered ? 0.6 : 0.4);
    final lineWidth = isActive
        ? (isHovered ? 26.0 : 16.0)
        : (isHovered ? 16.0 : 10.0);

    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              AnimatedContainer(
                duration: duration,
                curve: Curves.easeOutCubic,
                width: lineWidth,
                height: 2,
                color: color,
              ),
              const SizedBox(width: 8),
              AnimatedDefaultTextStyle(
                duration: duration,
                style: GoogleFonts.poppins(
                  fontSize: isHovered ? 14 : 12,
                  fontWeight: FontWeight.w600,
                  color: color,
                ),
                child: Text(number),
              ),
              if (isHovered)
                Padding(
                  padding: const EdgeInsets.only(left: 12),
                  child: Text(
                    label,
                    style: GoogleFonts.poppins(
                      fontSize: 13,
                      fontWeight: isActive ? FontWeight.w600 : FontWeight.w500,
                      letterSpacing: 0.3,
                      color: color,
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
