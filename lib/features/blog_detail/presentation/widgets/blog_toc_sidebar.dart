import 'package:flutter/material.dart';
import 'package:my_portfolio/core/resources/styles/blog_palette.dart';
import 'package:my_portfolio/features/blog_detail/domain/entities/toc_heading.dart';
import 'package:my_portfolio/features/blog_detail/presentation/controllers/toc_view_model.dart';

/// Desktop sidebar variant — always visible alongside content.
class BlogTocSidebar extends StatelessWidget {
  const BlogTocSidebar({required this.viewModel, super.key});

  final TocViewModel viewModel;

  @override
  Widget build(BuildContext context) {
    if (viewModel.headings.isEmpty) return const SizedBox.shrink();

    final palette = Theme.of(context).blogPalette;

    return Padding(
      padding: const EdgeInsets.only(left: 16, top: 80),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              'ON THIS PAGE',
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w800,
                letterSpacing: 1.2,
                color: palette.textMuted,
              ),
            ),
            const SizedBox(height: 16),
            ListenableBuilder(
              listenable: viewModel,
              builder: (context, _) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    for (var i = 0; i < viewModel.headings.length; i++)
                      _TocEntry(
                        heading: viewModel.headings[i],
                        isActive: i == viewModel.activeIndex,
                        onTap: () => viewModel.scrollToHeading(i),
                      ),
                  ],
                );
              },
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
    final theme = Theme.of(context);
    final palette = theme.blogPalette;
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
            isH3 ? 24.0 : 12.0,
            6,
            8,
            6,
          ),
          decoration: BoxDecoration(
            border: Border(
              left: BorderSide(
                color: isActive
                    ? theme.colorScheme.secondary
                    : _isHovered
                        ? theme.colorScheme.primary.withValues(alpha: 0.3)
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
                  ? theme.colorScheme.secondary
                  : _isHovered
                      ? palette.textStrong
                      : palette.textSecondary,
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
  const BlogTocCollapsible({required this.viewModel, super.key});

  final TocViewModel viewModel;

  @override
  Widget build(BuildContext context) {
    if (viewModel.headings.isEmpty) return const SizedBox.shrink();

    final palette = Theme.of(context).blogPalette;

    return Container(
      decoration: BoxDecoration(
        color: palette.surfaceSubtle,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: palette.borderSoft),
      ),
      child: ExpansionTile(
        tilePadding: const EdgeInsets.symmetric(horizontal: 20),
        childrenPadding: const EdgeInsets.fromLTRB(20, 0, 20, 16),
        shape: const RoundedRectangleBorder(),
        collapsedShape: const RoundedRectangleBorder(),
        title: Text(
          'Table of Contents',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w700,
            color: palette.textStrong,
            letterSpacing: 0.2,
          ),
        ),
        leading: Icon(
          Icons.list_rounded,
          size: 20,
          color: palette.textSecondary,
        ),
        children: <Widget>[
          for (var i = 0; i < viewModel.headings.length; i++)
            InkWell(
              onTap: () => viewModel.scrollToHeading(i),
              borderRadius: BorderRadius.circular(8),
              child: Padding(
                padding: EdgeInsets.fromLTRB(
                  viewModel.headings[i].level == 3 ? 16.0 : 0,
                  6,
                  8,
                  6,
                ),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    viewModel.headings[i].text,
                    style: TextStyle(
                      fontSize: viewModel.headings[i].level == 3 ? 13.0 : 14.0,
                      fontWeight: viewModel.headings[i].level == 3
                          ? FontWeight.w500
                          : FontWeight.w600,
                      color: palette.textSecondary,
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
