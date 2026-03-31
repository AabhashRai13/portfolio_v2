import 'package:flutter/material.dart';
import 'package:my_portfolio/constants/colors.dart';
import 'package:my_portfolio/features/blog_detail/presentation/controllers/blog_post_detail_controller.dart';
import 'package:my_portfolio/features/blog_detail/presentation/widgets/blog_comment_form_card.dart';
import 'package:my_portfolio/features/blog_detail/presentation/widgets/blog_comments_list.dart';
import 'package:my_portfolio/features/blog_detail/presentation/widgets/blog_post_engagement_card.dart';
import 'package:my_portfolio/features/blog_detail/presentation/widgets/blog_post_header.dart';
import 'package:my_portfolio/features/blog_detail/presentation/widgets/blog_post_markdown_card.dart';

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
              return const Center(
                child: CircularProgressIndicator(
                  color: CustomColor.secondary,
                ),
              );
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
                      BlogPostHeader(post: post),
                      const SizedBox(height: 32),
                      BlogPostMarkdownCard(
                        contentMarkdown: post.contentMarkdown,
                        onOpenLink: controller.openLink,
                      ),
                      const SizedBox(height: 28),
                      BlogPostEngagementCard(
                        post: post,
                        isLiking: controller.likePostCommand.isLoading,
                        onLikePressed: controller.likePost,
                        errorMessage: controller.likePostCommand.error,
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
                      BlogCommentFormCard(controller: controller),
                      const SizedBox(height: 20),
                      BlogCommentsList(
                        isLoading: controller.loadCommentsCommand.isLoading,
                        comments: controller.loadCommentsCommand.data,
                        error: controller.loadCommentsCommand.error,
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
