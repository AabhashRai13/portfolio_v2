import 'package:flutter/material.dart';
import 'package:flutter_markdown_plus/flutter_markdown_plus.dart';
import 'package:my_portfolio/constants/colors.dart';
import 'package:my_portfolio/features/blog_detail/presentation/controllers/blog_post_detail_controller.dart';

class BlogPostDetailPage extends StatefulWidget {
  const BlogPostDetailPage({
    required this.blogPostDetailController,
    required this.slug,
    super.key,
  });

  final BlogPostDetailController blogPostDetailController;
  final String slug;

  @override
  State<BlogPostDetailPage> createState() => _BlogPostDetailPageState();
}

class _BlogPostDetailPageState extends State<BlogPostDetailPage> {
  late final BlogPostDetailController controller;

  @override
  void initState() {
    super.initState();
    controller = widget.blogPostDetailController;
    controller.loadPost(widget.slug);
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Blog'),
        backgroundColor: Colors.white,
        foregroundColor: CustomColor.textPrimary,
        elevation: 0,
      ),
      body: Container(
        width: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: <Color>[
              Color(0xFFFFF7F0),
              Color(0xFFFFFFFF),
            ],
          ),
        ),
        child: ListenableBuilder(
          listenable: Listenable.merge(<Listenable>[
            controller.loadPostCommand,
            controller.loadCommentsCommand,
            controller.likePostCommand,
            controller.submitCommentCommand,
          ]),
          builder: (context, _) {
            if (controller.loadPostCommand.isLoading &&
                controller.loadPostCommand.data == null) {
              return const Center(child: CircularProgressIndicator());
            }

            if (controller.loadPostCommand.error != null) {
              return Center(
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Text(
                        controller.loadPostCommand.error!,
                        style: const TextStyle(
                          fontSize: 16,
                          color: Colors.redAccent,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 16),
                      FilledButton.tonal(
                        onPressed: () => controller.loadPost(widget.slug),
                        child: const Text('Try again'),
                      ),
                    ],
                  ),
                ),
              );
            }

            final post = controller.currentPost;
            if (post == null) {
              return const SizedBox.shrink();
            }

            WidgetsBinding.instance.addPostFrameCallback((_) {
              final feedback = controller.submitCommentCommand.data;
              if (feedback != null && context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(feedback)),
                );
                controller.resetCommentFeedback();
              }
            });

            return Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 980),
                child: SingleChildScrollView(
                  padding: const EdgeInsets.fromLTRB(24, 24, 24, 64),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: post.tags
                            .map(
                              (tag) => Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 10,
                                  vertical: 6,
                                ),
                                decoration: BoxDecoration(
                                  color: CustomColor.primary.withValues(
                                    alpha: 0.08,
                                  ),
                                  borderRadius: BorderRadius.circular(999),
                                ),
                                child: Text(
                                  tag,
                                  style: const TextStyle(
                                    color: CustomColor.primary,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            )
                            .toList(),
                      ),
                      const SizedBox(height: 18),
                      Text(
                        post.title,
                        style: const TextStyle(
                          fontSize: 36,
                          fontWeight: FontWeight.w800,
                          color: CustomColor.textPrimary,
                          height: 1.2,
                        ),
                      ),
                      const SizedBox(height: 14),
                      Text(
                        post.summary,
                        style: const TextStyle(
                          fontSize: 18,
                          color: CustomColor.textSecondary,
                          height: 1.6,
                        ),
                      ),
                      const SizedBox(height: 18),
                      Wrap(
                        spacing: 16,
                        runSpacing: 10,
                        children: <Widget>[
                          _MetaChip(label: _formatBlogDate(post.publishedAt)),
                          _MetaChip(
                            label: _formatReadTime(post.readTimeMinutes),
                          ),
                          _MetaChip(label: '${post.viewCount} reads'),
                          _MetaChip(label: '${post.commentCount} comments'),
                        ],
                      ),
                      if (post.coverImageUrl != null &&
                          post.coverImageUrl!.isNotEmpty) ...<Widget>[
                        const SizedBox(height: 28),
                        ClipRRect(
                          borderRadius: BorderRadius.circular(28),
                          child: Image.network(
                            post.coverImageUrl!,
                            width: double.infinity,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) =>
                                const SizedBox.shrink(),
                          ),
                        ),
                      ],
                      const SizedBox(height: 32),
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(24),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(28),
                          boxShadow: <BoxShadow>[
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.05),
                              blurRadius: 18,
                              offset: const Offset(0, 8),
                            ),
                          ],
                        ),
                        child: MarkdownBody(
                          data: post.contentMarkdown,
                          selectable: true,
                          onTapLink: (text, href, title) async {
                            if (href == null || href.isEmpty) {
                              return;
                            }
                            try {
                              await controller.openLink(href);
                            } on Exception {
                              if (!context.mounted) {
                                return;
                              }
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('Unable to open that link.'),
                                ),
                              );
                            }
                          },
                          styleSheet:
                              MarkdownStyleSheet.fromTheme(
                                Theme.of(context),
                              ).copyWith(
                                p: const TextStyle(
                                  fontSize: 16,
                                  height: 1.8,
                                  color: CustomColor.textPrimary,
                                ),
                                h1: const TextStyle(
                                  fontSize: 30,
                                  fontWeight: FontWeight.w800,
                                  color: CustomColor.textPrimary,
                                ),
                                h2: const TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.w700,
                                  color: CustomColor.textPrimary,
                                ),
                                codeblockDecoration: BoxDecoration(
                                  color: const Color(0xFFF7EFE7),
                                  borderRadius: BorderRadius.circular(16),
                                ),
                              ),
                        ),
                      ),
                      const SizedBox(height: 28),
                      Container(
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(24),
                          border: Border.all(
                            color: CustomColor.primary.withValues(alpha: 0.12),
                          ),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Wrap(
                              spacing: 16,
                              runSpacing: 16,
                              crossAxisAlignment: WrapCrossAlignment.center,
                              children: <Widget>[
                                FilledButton.icon(
                                  onPressed:
                                      controller.likePostCommand.isLoading ||
                                          post.isLikedByCurrentBrowser
                                      ? null
                                      : controller.likePost,
                                  icon: Icon(
                                    post.isLikedByCurrentBrowser
                                        ? Icons.favorite
                                        : Icons.favorite_border,
                                  ),
                                  label: Text(
                                    post.isLikedByCurrentBrowser
                                        ? 'Liked • ${post.likeCount}'
                                        : 'Like • ${post.likeCount}',
                                  ),
                                ),
                                const Text(
                                  'If this article helped, drop a like or '
                                  'leave a comment.',
                                  style: TextStyle(
                                    color: CustomColor.textSecondary,
                                    fontSize: 15,
                                  ),
                                ),
                              ],
                            ),
                            if (controller.likePostCommand.error !=
                                null) ...<Widget>[
                              const SizedBox(height: 12),
                              Text(
                                controller.likePostCommand.error!,
                                style: const TextStyle(
                                  color: Colors.redAccent,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ],
                        ),
                      ),
                      const SizedBox(height: 32),
                      Text(
                        'Comments',
                        style: Theme.of(context).textTheme.headlineSmall
                            ?.copyWith(
                              fontWeight: FontWeight.w800,
                              color: CustomColor.textPrimary,
                            ),
                      ),
                      const SizedBox(height: 16),
                      Container(
                        padding: const EdgeInsets.all(24),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(24),
                          boxShadow: <BoxShadow>[
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.04),
                              blurRadius: 14,
                              offset: const Offset(0, 6),
                            ),
                          ],
                        ),
                        child: Form(
                          key: controller.formKey,
                          child: Column(
                            children: <Widget>[
                              TextFormField(
                                controller: controller.authorNameController,
                                validator: controller.validateAuthorName,
                                textInputAction: TextInputAction.next,
                                decoration: const InputDecoration(
                                  labelText: 'Your name',
                                  border: OutlineInputBorder(),
                                ),
                              ),
                              const SizedBox(height: 16),
                              TextFormField(
                                controller: controller.messageController,
                                validator: controller.validateMessage,
                                minLines: 4,
                                maxLines: 8,
                                decoration: const InputDecoration(
                                  labelText: 'Share your thoughts',
                                  alignLabelWithHint: true,
                                  border: OutlineInputBorder(),
                                ),
                              ),
                              const SizedBox(height: 16),
                              Align(
                                alignment: Alignment.centerLeft,
                                child: FilledButton(
                                  onPressed:
                                      controller.submitCommentCommand.isLoading
                                      ? null
                                      : controller.submitComment,
                                  child: Text(
                                    controller.submitCommentCommand.isLoading
                                        ? 'Posting...'
                                        : 'Post comment',
                                  ),
                                ),
                              ),
                              if (controller.submitCommentCommand.error != null)
                                Padding(
                                  padding: const EdgeInsets.only(top: 12),
                                  child: Text(
                                    controller.submitCommentCommand.error!,
                                    style: const TextStyle(
                                      color: Colors.redAccent,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      if (controller.loadCommentsCommand.isLoading &&
                          controller.loadCommentsCommand.data.isEmpty)
                        const Center(child: CircularProgressIndicator())
                      else if (controller.loadCommentsCommand.error != null)
                        Text(
                          controller.loadCommentsCommand.error!,
                          style: const TextStyle(
                            color: Colors.redAccent,
                            fontWeight: FontWeight.w600,
                          ),
                        )
                      else if (controller.loadCommentsCommand.data.isEmpty)
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(24),
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.9),
                            borderRadius: BorderRadius.circular(24),
                          ),
                          child: const Text(
                            'No comments yet. Be the first to join the '
                            'conversation.',
                            style: TextStyle(
                              color: CustomColor.textSecondary,
                              fontSize: 16,
                            ),
                          ),
                        )
                      else
                        Column(
                          children: controller.loadCommentsCommand.data
                              .map(
                                (comment) => Padding(
                                  padding: const EdgeInsets.only(bottom: 16),
                                  child: Container(
                                    width: double.infinity,
                                    padding: const EdgeInsets.all(20),
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(24),
                                      boxShadow: <BoxShadow>[
                                        BoxShadow(
                                          color: Colors.black.withValues(
                                            alpha: 0.04,
                                          ),
                                          blurRadius: 14,
                                          offset: const Offset(0, 6),
                                        ),
                                      ],
                                    ),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: <Widget>[
                                        Text(
                                          comment.authorName,
                                          style: const TextStyle(
                                            fontWeight: FontWeight.w700,
                                            color: CustomColor.textPrimary,
                                          ),
                                        ),
                                        const SizedBox(height: 6),
                                        Text(
                                          _formatCommentTimestamp(
                                            comment.createdAt,
                                          ),
                                          style: const TextStyle(
                                            fontSize: 13,
                                            color: CustomColor.textSecondary,
                                          ),
                                        ),
                                        const SizedBox(height: 12),
                                        Text(
                                          comment.message,
                                          style: const TextStyle(
                                            fontSize: 15,
                                            height: 1.6,
                                            color: CustomColor.textPrimary,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              )
                              .toList(),
                        ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

class _MetaChip extends StatelessWidget {
  const _MetaChip({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(999),
        border: Border.all(
          color: CustomColor.primary.withValues(alpha: 0.12),
        ),
      ),
      child: Text(
        label,
        style: const TextStyle(
          color: CustomColor.textSecondary,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}

String _formatBlogDate(DateTime date) {
  const months = <String>[
    'Jan',
    'Feb',
    'Mar',
    'Apr',
    'May',
    'Jun',
    'Jul',
    'Aug',
    'Sep',
    'Oct',
    'Nov',
    'Dec',
  ];

  final month = months[date.month - 1];
  return '$month ${date.day}, ${date.year}';
}

String _formatCommentTimestamp(DateTime date) {
  const months = <String>[
    'Jan',
    'Feb',
    'Mar',
    'Apr',
    'May',
    'Jun',
    'Jul',
    'Aug',
    'Sep',
    'Oct',
    'Nov',
    'Dec',
  ];

  final month = months[date.month - 1];
  final hour = date.hour == 0
      ? 12
      : (date.hour > 12 ? date.hour - 12 : date.hour);
  final minute = date.minute.toString().padLeft(2, '0');
  final suffix = date.hour >= 12 ? 'PM' : 'AM';

  return '$month ${date.day}, ${date.year} at $hour:$minute $suffix';
}

String _formatReadTime(int minutes) {
  return '$minutes min read';
}
