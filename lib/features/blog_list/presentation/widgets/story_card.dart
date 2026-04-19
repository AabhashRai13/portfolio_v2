import 'package:flutter/material.dart';
import 'package:my_portfolio/core/resources/styles/blog_palette.dart';
import 'package:my_portfolio/core/resources/utils/blog_formatters.dart';
import 'package:my_portfolio/features/blog_list/domain/entities/blog_post_summary_entity.dart';
import 'package:my_portfolio/features/blog_list/presentation/widgets/blog_tag_chip.dart';
import 'package:my_portfolio/features/blog_list/presentation/widgets/meta_text.dart';
import 'package:my_portfolio/features/blog_list/presentation/widgets/story_visual.dart';

class StoryCard extends StatelessWidget {
  const StoryCard({
    required this.post,
    required this.onTap,
    super.key,
  });

  final BlogPostSummaryEntity post;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final palette = Theme.of(context).blogPalette;

    return InkWell(
      borderRadius: BorderRadius.circular(30),
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: palette.surfaceElevated,
          borderRadius: BorderRadius.circular(30),
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
            StoryVisual(
              post: post,
              aspectRatio: 16 / 8.8,
              isFeatured: false,
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(10, 18, 10, 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: post.tags
                        .take(2)
                        .map((tag) => BlogTagChip(tag: tag))
                        .toList(growable: false),
                  ),
                  const SizedBox(height: 14),
                  Text(
                    post.title,
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.w800,
                      color: palette.textStrong,
                      height: 1.14,
                      letterSpacing: -0.6,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    post.summary,
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      color: palette.textSecondary,
                      height: 1.6,
                    ),
                  ),
                  const SizedBox(height: 22),
                  Row(
                    children: <Widget>[
                      Expanded(
                        child: Wrap(
                          spacing: 10,
                          runSpacing: 6,
                          children: <Widget>[
                            MetaText(label: formatBlogDate(post.publishedAt)),
                            MetaText(
                              label: formatReadTime(post.readTimeMinutes),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 12),
                      const MetaText(label: 'Read article', isAccent: true),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
