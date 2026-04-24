import 'package:flutter/material.dart';
import 'package:my_portfolio/core/resources/styles/blog_palette.dart';
import 'package:my_portfolio/core/resources/utils/blog_formatters.dart';
import 'package:my_portfolio/features/blog_detail/domain/entities/blog_post_entity.dart';

class BlogPostHeader extends StatelessWidget {
  const BlogPostHeader({
    required this.post,
    super.key,
  });

  final BlogPostEntity post;

  @override
  Widget build(BuildContext context) {
    final palette = Theme.of(context).blogPalette;

    return LayoutBuilder(
      builder: (context, constraints) {
        final isWide = constraints.maxWidth >= 760;
        final titleFontSize = constraints.maxWidth >= 980
            ? 54.0
            : constraints.maxWidth >= 700
            ? 46.0
            : 36.0;
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(isWide ? 34 : 24),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: palette.headerGradient,
                ),
                borderRadius: BorderRadius.circular(34),
                border: Border.all(color: palette.borderSoft),
                boxShadow: <BoxShadow>[
                  BoxShadow(
                    color: palette.shadowColor,
                    blurRadius: 24,
                    offset: const Offset(0, 14),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Wrap(
                    spacing: 10,
                    runSpacing: 10,
                    children: post.tags
                        .map(
                          (tag) => _EditorialTagBadge(tag: tag),
                        )
                        .toList(growable: false),
                  ),
                  const SizedBox(height: 24),
                  Text(
                    post.title,
                    style: TextStyle(
                      fontSize: titleFontSize,
                      fontWeight: FontWeight.w900,
                      color: palette.textStrong,
                      height: 1.03,
                      letterSpacing: -1.2,
                    ),
                  ),
                  ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 760),
                    child: Text(
                      post.summary,
                      style: TextStyle(
                        fontSize: 19,
                        color: palette.textSecondary,
                        height: 1.75,
                        letterSpacing: -0.1,
                      ),
                    ),
                  ),
                  const SizedBox(height: 26),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 18,
                      vertical: 16,
                    ),
                    decoration: BoxDecoration(
                      color: palette.surfaceSubtle,
                      borderRadius: BorderRadius.circular(24),
                      border: Border.all(color: palette.borderSoft),
                    ),
                    child: Wrap(
                      spacing: 18,
                      runSpacing: 14,
                      children: <Widget>[
                        _MetaItem(
                          icon: Icons.calendar_today_outlined,
                          label: formatBlogDate(post.publishedAt),
                        ),
                        _MetaItem(
                          icon: Icons.schedule_rounded,
                          label: formatReadTime(post.readTimeMinutes),
                        ),
                        _MetaItem(
                          icon: Icons.visibility_outlined,
                          label: '${post.viewCount} reads',
                        ),
                        _MetaItem(
                          icon: Icons.mode_comment_outlined,
                          label: '${post.commentCount} comments',
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            if (post.coverImageUrl != null &&
                post.coverImageUrl!.isNotEmpty) ...<Widget>[
              const SizedBox(height: 30),
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(32),
                  boxShadow: <BoxShadow>[
                    BoxShadow(
                      color: palette.shadowColor,
                      blurRadius: 24,
                      offset: const Offset(0, 16),
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(32),
                  child: Image.network(
                    post.coverImageUrl!,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) =>
                        const SizedBox.shrink(),
                  ),
                ),
              ),
            ],
          ],
        );
      },
    );
  }
}

class _EditorialTagBadge extends StatefulWidget {
  const _EditorialTagBadge({required this.tag});

  final String tag;

  @override
  State<_EditorialTagBadge> createState() => _EditorialTagBadgeState();
}

class _EditorialTagBadgeState extends State<_EditorialTagBadge> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final palette = theme.blogPalette;

    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        curve: Curves.easeOutCubic,
        padding: const EdgeInsets.symmetric(
          horizontal: 14,
          vertical: 9,
        ),
        decoration: BoxDecoration(
          color: _isHovered ? palette.tagChipBackground : palette.surfaceSubtle,
          borderRadius: BorderRadius.circular(999),
          border: Border.all(
            color: _isHovered
                ? theme.colorScheme.secondary.withValues(alpha: 0.36)
                : palette.tagChipBorder,
          ),
          boxShadow: <BoxShadow>[
            BoxShadow(
              color: palette.shadowColor,
              blurRadius: _isHovered ? 14 : 8,
              offset: Offset(0, _isHovered ? 7 : 4),
            ),
          ],
        ),
        child: Text(
          widget.tag.toUpperCase(),
          style: TextStyle(
            color: _isHovered
                ? theme.colorScheme.secondary
                : palette.tagChipForeground,
            fontSize: 11.5,
            fontWeight: FontWeight.w800,
            letterSpacing: 0.9,
          ),
        ),
      ),
    );
  }
}

class _MetaItem extends StatelessWidget {
  const _MetaItem({
    required this.icon,
    required this.label,
  });

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    final palette = Theme.of(context).blogPalette;

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Container(
          width: 32,
          height: 32,
          decoration: BoxDecoration(
            color: palette.tagChipBackground,
            borderRadius: BorderRadius.circular(12),
          ),
          alignment: Alignment.center,
          child: Icon(
            icon,
            size: 16,
            color: palette.textStrong,
          ),
        ),
        const SizedBox(width: 10),
        Text(
          label,
          style: TextStyle(
            color: palette.textSecondary,
            fontSize: 14.5,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}
