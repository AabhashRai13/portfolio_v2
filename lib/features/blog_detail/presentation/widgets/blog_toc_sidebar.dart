import 'package:flutter/material.dart';
import 'package:my_portfolio/constants/colors.dart';
import 'package:my_portfolio/core/services/smooth_wheel_scroll_controller.dart';
import 'package:my_portfolio/features/blog_detail/domain/entities/toc_heading.dart';

/// Desktop sidebar variant — always visible alongside content.
class BlogTocSidebar extends StatefulWidget {
  const BlogTocSidebar({
    required this.headings,
    required this.headingKeys,
    required this.scrollController,
    super.key,
  });

  final List<TocHeading> headings;
  final Map<String, GlobalKey> headingKeys;
  final SmoothWheelScrollController scrollController;

  @override
  State<BlogTocSidebar> createState() => _BlogTocSidebarState();
}

class _BlogTocSidebarState extends State<BlogTocSidebar> {
  int _activeIndex = 0;

  @override
  void initState() {
    super.initState();
    widget.scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    widget.scrollController.removeListener(_onScroll);
    super.dispose();
  }

  // TODO(performance): This fires on every scroll pixel (~60x/sec).
  // Consider throttling with a Timer (~100ms) to reduce localToGlobal
  // calls. Not critical with <20 headings — needs profiling first.
  void _onScroll() {
    final newIndex = _computeActiveIndex();
    if (newIndex != _activeIndex) {
      setState(() => _activeIndex = newIndex);
    }
  }

  int _computeActiveIndex() {
    const topPadding = 100.0;
    var lastVisible = 0;

    for (var i = 0; i < widget.headings.length; i++) {
      final key = widget.headingKeys[widget.headings[i].id];
      if (key == null) continue;

      final ctx = key.currentContext;
      if (ctx == null) continue;

      final renderObject = ctx.findRenderObject();
      if (renderObject is! RenderBox || !renderObject.attached) continue;

      final offset = renderObject.localToGlobal(Offset.zero);
      if (offset.dy <= topPadding) {
        lastVisible = i;
      } else {
        break;
      }
    }

    return lastVisible;
  }

  Future<void> _scrollToHeading(int index) async {
    final heading = widget.headings[index];
    final key = widget.headingKeys[heading.id];
    final ctx = key?.currentContext;
    if (ctx == null) return;

    await Scrollable.ensureVisible(
      ctx,
      alignment: 0.05,
      duration: const Duration(milliseconds: 400),
      curve: Curves.easeInOut,
    );
    widget.scrollController.resetWheelTarget();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.headings.isEmpty) return const SizedBox.shrink();

    return Padding(
      padding: const EdgeInsets.only(left: 16, top: 80),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            const Text(
              'ON THIS PAGE',
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w800,
                letterSpacing: 1.2,
                color: CustomColor.textSecondary,
              ),
            ),
            const SizedBox(height: 16),
            for (var i = 0; i < widget.headings.length; i++)
              _TocEntry(
                heading: widget.headings[i],
                isActive: i == _activeIndex,
                onTap: () => _scrollToHeading(i),
              ),
          ],
        ),
      ),
    );
  }
}

class _TocEntry extends StatefulWidget {
  const _TocEntry({
    required this.heading,
    required this.isActive,
    required this.onTap,
  });

  final TocHeading heading;
  final bool isActive;
  final VoidCallback onTap;

  @override
  State<_TocEntry> createState() => _TocEntryState();
}

class _TocEntryState extends State<_TocEntry> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    final isH3 = widget.heading.level == 3;
    final isActive = widget.isActive;

    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          curve: Curves.easeOutCubic,
          padding: EdgeInsets.fromLTRB(
            isH3 ? 16.0 : 0,
            6,
            8,
            6,
          ),
          decoration: BoxDecoration(
            border: Border(
              left: BorderSide(
                color: isActive
                    ? CustomColor.secondary
                    : _isHovered
                        ? CustomColor.primary.withValues(alpha: 0.3)
                        : Colors.transparent,
                width: 2,
              ),
            ),
          ),
          child: Text(
            widget.heading.text,
            style: TextStyle(
              fontSize: isH3 ? 13.0 : 14.0,
              fontWeight: isActive ? FontWeight.w700 : FontWeight.w500,
              color: isActive
                  ? CustomColor.secondary
                  : _isHovered
                      ? CustomColor.textPrimary
                      : CustomColor.textSecondary,
              height: 1.4,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ),
    );
  }
}

/// Mobile / tablet collapsible variant — shown above the article.
class BlogTocCollapsible extends StatelessWidget {
  const BlogTocCollapsible({
    required this.headings,
    required this.headingKeys,
    required this.scrollController,
    super.key,
  });

  final List<TocHeading> headings;
  final Map<String, GlobalKey> headingKeys;
  final SmoothWheelScrollController scrollController;

  Future<void> _scrollToHeading(TocHeading heading) async {
    final key = headingKeys[heading.id];
    final ctx = key?.currentContext;
    if (ctx == null) return;

    await Scrollable.ensureVisible(
      ctx,
      alignment: 0.05,
      duration: const Duration(milliseconds: 400),
      curve: Curves.easeInOut,
    );
    scrollController.resetWheelTarget();
  }

  @override
  Widget build(BuildContext context) {
    if (headings.isEmpty) return const SizedBox.shrink();

    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.7),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFEADCCD)),
      ),
      child: ExpansionTile(
        tilePadding: const EdgeInsets.symmetric(horizontal: 20),
        childrenPadding: const EdgeInsets.fromLTRB(20, 0, 20, 16),
        shape: const RoundedRectangleBorder(),
        collapsedShape: const RoundedRectangleBorder(),
        title: const Text(
          'Table of Contents',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w700,
            color: CustomColor.textPrimary,
            letterSpacing: 0.2,
          ),
        ),
        leading: const Icon(
          Icons.list_rounded,
          size: 20,
          color: CustomColor.textSecondary,
        ),
        children: <Widget>[
          for (final heading in headings)
            InkWell(
              onTap: () => _scrollToHeading(heading),
              borderRadius: BorderRadius.circular(8),
              child: Padding(
                padding: EdgeInsets.fromLTRB(
                  heading.level == 3 ? 16.0 : 0,
                  6,
                  8,
                  6,
                ),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    heading.text,
                    style: TextStyle(
                      fontSize: heading.level == 3 ? 13.0 : 14.0,
                      fontWeight: heading.level == 3
                          ? FontWeight.w500
                          : FontWeight.w600,
                      color: CustomColor.textSecondary,
                      height: 1.5,
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
