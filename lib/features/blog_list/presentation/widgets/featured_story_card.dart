import 'package:flutter/material.dart';
import 'package:my_portfolio/features/blog_list/domain/entities/blog_post_summary_entity.dart';
import 'package:my_portfolio/features/blog_list/presentation/service/blog_list_utils.dart';
import 'package:my_portfolio/features/blog_list/presentation/widgets/blog_tag_chip.dart';
import 'package:my_portfolio/features/blog_list/presentation/widgets/meta_text.dart';
import 'package:my_portfolio/features/blog_list/presentation/widgets/story_visual.dart';

class FeaturedStoryCard extends StatelessWidget {
  const FeaturedStoryCard({
    required this.post,
    required this.onTap,
    super.key,
  });

  final BlogPostSummaryEntity post;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(34),
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.9),
          borderRadius: BorderRadius.circular(34),
          border: Border.all(color: const Color(0xFFF4EADF)),
          boxShadow: <BoxShadow>[
            BoxShadow(
              color: const Color(0xFF926E4A).withValues(alpha: 0.08),
              blurRadius: 32,
              offset: const Offset(0, 16),
            ),
          ],
        ),
        child: LayoutBuilder(
          builder: (context, constraints) {
            final isWide = constraints.maxWidth >= 820;
            final image = StoryVisual(
              post: post,
              aspectRatio: isWide ? 1 : 16 / 10,
              isFeatured: true,
            );

            final content = Padding(
              padding: EdgeInsets.all(isWide ? 22 : 10),
              child: Column(
                mainAxisSize: isWide ? MainAxisSize.max : MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: post.tags
                        .take(3)
                        .map((tag) => BlogTagChip(tag: tag))
                        .toList(growable: false),
                  ),
                  const SizedBox(height: 18),
                  Text(
                    post.title,
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.w800,
                      color: const Color(0xFF2D241E),
                      height: 1.08,
                      letterSpacing: -0.8,
                    ),
                  ),
                  const SizedBox(height: 14),
                  Text(
                    post.summary,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: const Color(0xFF847568),
                      height: 1.6,
                    ),
                  ),
                  if (isWide) const Spacer() else const SizedBox(height: 12),
                  const SizedBox(height: 24),
                  Wrap(
                    spacing: 14,
                    runSpacing: 8,
                    children: <Widget>[
                      MetaText(label: formatBlogDate(post.publishedAt)),
                      MetaText(label: formatReadTime(post.readTimeMinutes)),
                      const MetaText(
                        label: 'Read article',
                        isAccent: true,
                      ),
                    ],
                  ),
                ],
              ),
            );

            if (!isWide) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  image,
                  content,
                ],
              );
            }

            return SizedBox(
              height: 370,
              child: Row(
                children: <Widget>[
                  Expanded(
                    flex: 11,
                    child: image,
                  ),
                  const SizedBox(width: 24),
                  Expanded(
                    flex: 15,
                    child: content,
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
