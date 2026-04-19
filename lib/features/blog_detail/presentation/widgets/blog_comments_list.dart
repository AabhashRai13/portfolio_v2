import 'package:flutter/material.dart';
import 'package:my_portfolio/core/resources/styles/blog_palette.dart';
import 'package:my_portfolio/core/resources/utils/blog_formatters.dart';
import 'package:my_portfolio/features/blog_detail/domain/entities/blog_comment_entity.dart';

class BlogCommentsList extends StatelessWidget {
  const BlogCommentsList({
    required this.isLoading,
    required this.comments,
    this.error,
    super.key,
  });

  final bool isLoading;
  final List<BlogCommentEntity> comments;
  final String? error;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final palette = theme.blogPalette;

    if (isLoading && comments.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }

    if (error != null) {
      return Text(
        error!,
        style: const TextStyle(
          color: Colors.redAccent,
          fontWeight: FontWeight.w600,
        ),
      );
    }

    if (comments.isEmpty) {
      return Container(
        width: double.infinity,
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: palette.surfaceElevated,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: palette.borderSoft),
        ),
        child: Text(
          'Feel free to leave the first comment—your engagement means a lot.',
          style: TextStyle(
            color: palette.textSecondary,
            fontSize: 16,
          ),
        ),
      );
    }

    return Column(
      children: comments
          .asMap()
          .entries
          .map(
            (entry) => Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: _CommentCard(
                comment: entry.value,
                highlightColor: entry.key.isEven
                    ? theme.colorScheme.primary
                    : theme.colorScheme.tertiary,
              ),
            ),
          )
          .toList(growable: false),
    );
  }
}

class _CommentCard extends StatelessWidget {
  const _CommentCard({
    required this.comment,
    required this.highlightColor,
  });

  final BlogCommentEntity comment;
  final Color highlightColor;

  @override
  Widget build(BuildContext context) {
    final palette = Theme.of(context).blogPalette;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: palette.surfaceElevated,
        borderRadius: BorderRadius.circular(28),
        border: Border.all(
          color: highlightColor.withValues(alpha: 0.14),
        ),
        boxShadow: <BoxShadow>[
          BoxShadow(
            color: palette.shadowColor,
            blurRadius: 18,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              _CommentAvatar(
                authorName: comment.authorName,
                highlightColor: highlightColor,
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Wrap(
                      spacing: 10,
                      runSpacing: 8,
                      crossAxisAlignment: WrapCrossAlignment.center,
                      children: <Widget>[
                        Text(
                          comment.authorName,
                          style: TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.w800,
                            color: palette.textStrong,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    Text(
                      formatCommentTimestamp(comment.createdAt),
                      style: TextStyle(
                        fontSize: 13,
                        color: palette.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 18),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.fromLTRB(16, 14, 16, 16),
            decoration: BoxDecoration(
              color: palette.surfaceSubtle,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Icon(
                  Icons.format_quote_rounded,
                  color: highlightColor.withValues(alpha: 0.72),
                  size: 22,
                ),
                const SizedBox(height: 6),
                Text(
                  comment.message,
                  style: TextStyle(
                    fontSize: 15,
                    height: 1.7,
                    color: palette.textStrong,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _CommentAvatar extends StatelessWidget {
  const _CommentAvatar({
    required this.authorName,
    required this.highlightColor,
  });

  final String authorName;
  final Color highlightColor;

  @override
  Widget build(BuildContext context) {
    final palette = Theme.of(context).blogPalette;

    return Container(
      width: 48,
      height: 48,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: <Color>[
            highlightColor.withValues(alpha: 0.92),
            palette.textStrong.withValues(alpha: 0.88),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      alignment: Alignment.center,
      child: Text(
        _initials(authorName),
        style: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.w800,
          fontSize: 15,
          letterSpacing: 0.3,
        ),
      ),
    );
  }

  String _initials(String name) {
    final parts = name
        .trim()
        .split(RegExp(r'\s+'))
        .where((part) => part.isNotEmpty)
        .take(2)
        .toList(growable: false);

    if (parts.isEmpty) {
      return '?';
    }

    return parts.map((part) => part.characters.first.toUpperCase()).join();
  }
}
