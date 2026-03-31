import 'package:flutter/material.dart';
import 'package:my_portfolio/constants/colors.dart';
import 'package:my_portfolio/features/blog_detail/domain/entities/blog_post_entity.dart';
import 'package:my_portfolio/features/blog_detail/presentation/widgets/editorial_action_button.dart';

class BlogPostEngagementCard extends StatelessWidget {
  const BlogPostEngagementCard({
    required this.post,
    required this.isLiking,
    required this.onLikePressed,
    this.errorMessage,
    super.key,
  });

  final BlogPostEntity post;
  final bool isLiking;
  final VoidCallback onLikePressed;
  final String? errorMessage;

  @override
  Widget build(BuildContext context) {
    final canLike = !isLiking && !post.isLikedByCurrentBrowser;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 220),
      curve: Curves.easeOutCubic,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.94),
        borderRadius: BorderRadius.circular(30),
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: <Color>[
            Color(0xFFFFFFFF),
            Color(0xFFFFFAF4),
          ],
        ),
        border: Border.all(
          color: const Color(0xFFF0E3D6),
        ),
        boxShadow: <BoxShadow>[
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.045),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
          BoxShadow(
            color: Colors.white.withValues(alpha: 0.75),
            blurRadius: 10,
            offset: const Offset(-4, -4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Container(
                width: 42,
                height: 42,
                decoration: BoxDecoration(
                  color: const Color(0xFFFFF4EA),
                  borderRadius: BorderRadius.circular(14),
                ),
                alignment: Alignment.center,
                child: Icon(
                  post.isLikedByCurrentBrowser
                      ? Icons.favorite_rounded
                      : Icons.favorite_border_rounded,
                  color: post.isLikedByCurrentBrowser
                      ? CustomColor.pastelRed
                      : CustomColor.secondary,
                ),
              ),
              const SizedBox(width: 14),
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      'Did this piece earn a little love?',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w800,
                        color: CustomColor.textPrimary,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      'A like or a thoughtful note tells me what actually '
                      'landed with you.',
                      style: TextStyle(
                        fontSize: 14,
                        height: 1.5,
                        color: CustomColor.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 22),
          Wrap(
            spacing: 18,
            runSpacing: 18,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: <Widget>[
              EditorialActionButton(
                onPressed: canLike ? onLikePressed : null,
                isActive: isLiking || post.isLikedByCurrentBrowser,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Icon(
                      post.isLikedByCurrentBrowser
                          ? Icons.favorite_rounded
                          : Icons.favorite_border_rounded,
                    ),
                    const SizedBox(width: 10),
                    Text(
                      post.isLikedByCurrentBrowser
                          ? 'Liked · ${post.likeCount}'
                          : isLiking
                          ? 'Sending love...'
                          : 'Like · ${post.likeCount}',
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 11,
                ),
                decoration: BoxDecoration(
                  color: const Color(0xFFFFF8F1),
                  borderRadius: BorderRadius.circular(999),
                ),
                child: Text(
                  post.isLikedByCurrentBrowser
                      ? 'You already left a kind mark here.'
                      : 'Quiet appreciation is welcome too.',
                  style: const TextStyle(
                    color: CustomColor.textSecondary,
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          if (errorMessage != null) ...<Widget>[
            const SizedBox(height: 12),
            Text(
              errorMessage!,
              style: const TextStyle(
                color: Colors.redAccent,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ],
      ),
    );
  }
}
