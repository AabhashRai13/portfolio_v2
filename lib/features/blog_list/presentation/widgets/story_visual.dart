import 'package:flutter/material.dart';
import 'package:my_portfolio/features/blog_list/domain/entities/blog_post_summary_entity.dart';
import 'package:my_portfolio/features/blog_list/presentation/widgets/fall_black_visual_content.dart';

class StoryVisual extends StatelessWidget {
  const StoryVisual({
    required this.post,
    required this.aspectRatio,
    required this.isFeatured,
    super.key,
  });

  final BlogPostSummaryEntity post;
  final double aspectRatio;
  final bool isFeatured;

  @override
  Widget build(BuildContext context) {
    final label = post.tags.isNotEmpty
        ? post.tags.first.toUpperCase()
        : 'ESSAY';

    return ClipRRect(
      borderRadius: BorderRadius.circular(isFeatured ? 28 : 24),
      child: AspectRatio(
        aspectRatio: aspectRatio,
        child: Stack(
          fit: StackFit.expand,
          children: <Widget>[
            DecoratedBox(
              decoration: BoxDecoration(
                gradient: _fallbackGradient(post),
              ),
              child:
                  post.coverImageUrl != null && post.coverImageUrl!.isNotEmpty
                  ? Image.network(
                      post.coverImageUrl!,
                      fit: BoxFit.contain,
                      errorBuilder: (context, error, stackTrace) =>
                          FallbackVisualContent(
                            label: label,
                            title: post.title,
                            isFeatured: isFeatured,
                          ),
                    )
                  : FallbackVisualContent(
                      label: label,
                      title: post.title,
                      isFeatured: isFeatured,
                    ),
            ),
            Positioned(
              top: 14,
              left: 14,
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 7,
                ),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.92),
                  borderRadius: BorderRadius.circular(999),
                ),
                child: Text(
                  label,
                  style: const TextStyle(
                    color: Color(0xFF7F6F64),
                    fontSize: 11,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 0.9,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  LinearGradient _fallbackGradient(BlogPostSummaryEntity post) {
    final seed = post.slug.length % 3;

    switch (seed) {
      case 0:
        return const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: <Color>[
            Color(0xFF2A3433),
            Color(0xFF3B4745),
            Color(0xFF18211F),
          ],
        );
      case 1:
        return const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: <Color>[
            Color(0xFFEDE7DC),
            Color(0xFFD8D2F5),
            Color(0xFFD2DDF8),
          ],
        );
      default:
        return const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: <Color>[
            Color(0xFF263133),
            Color(0xFF566564),
            Color(0xFFE4ECE8),
          ],
        );
    }
  }
}
