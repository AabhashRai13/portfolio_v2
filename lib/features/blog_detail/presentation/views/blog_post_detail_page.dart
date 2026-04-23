import 'package:flutter/material.dart';
import 'package:my_portfolio/core/resources/styles/blog_palette.dart';
import 'package:my_portfolio/core/services/smooth_wheel_scroll_controller.dart';
import 'package:my_portfolio/features/blog_detail/domain/entities/blog_post_entity.dart';
import 'package:my_portfolio/features/blog_detail/presentation/controllers/blog_post_detail_controller.dart';
import 'package:my_portfolio/features/blog_detail/presentation/controllers/reading_progress_view_model.dart';
import 'package:my_portfolio/features/blog_detail/presentation/controllers/toc_view_model.dart';
import 'package:my_portfolio/features/blog_detail/presentation/widgets/blog_comment_form_card.dart';
import 'package:my_portfolio/features/blog_detail/presentation/widgets/blog_comments_list.dart';
import 'package:my_portfolio/features/blog_detail/presentation/widgets/blog_post_engagement_card.dart';
import 'package:my_portfolio/features/blog_detail/presentation/widgets/blog_post_header.dart';
import 'package:my_portfolio/features/blog_detail/presentation/widgets/blog_post_markdown_card.dart';
import 'package:my_portfolio/features/blog_detail/presentation/widgets/blog_toc_sidebar.dart';
import 'package:my_portfolio/features/blog_detail/presentation/widgets/reading_progress_bar.dart';

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
    controller.submitCommentCommand.addListener(_onCommentFeedback);
    controller.loadPost(widget.slug);
  }

  @override
  void dispose() {
    controller.submitCommentCommand.removeListener(_onCommentFeedback);
    controller.dispose();
    super.dispose();
  }

  void _onCommentFeedback() {
    final feedback = controller.submitCommentCommand.data;
    if (feedback == null || !mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(feedback)),
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final palette = Theme.of(context).blogPalette;

    return Scaffold(
      body: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: palette.pageGradient,
          ),
        ),
        child: ListenableBuilder(
          listenable: controller.loadPostCommand,
          builder: (context, _) {
            if (controller.loadPostCommand.isLoading &&
                controller.loadPostCommand.data == null) {
              return Center(
                child: CircularProgressIndicator(
                  color: Theme.of(context).colorScheme.secondary,
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

            return _BlogPostContent(
              post: post,
              controller: controller,
              screenWidth: screenWidth,
            );
          },
        ),
      ),
    );
  }
}

class _BlogPostContent extends StatefulWidget {
  const _BlogPostContent({
    required this.post,
    required this.controller,
    required this.screenWidth,
  });

  final BlogPostEntity post;
  final BlogPostDetailController controller;
  final double screenWidth;

  @override
  State<_BlogPostContent> createState() => _BlogPostContentState();
}

class _BlogPostContentState extends State<_BlogPostContent> {
  late final BlogPostEntity _post;
  late final Map<String, GlobalKey> _headingKeys;
  late final ReadingProgressViewModel _progressViewModel;
  late final TocViewModel? _tocViewModel;
  final _scrollController = SmoothWheelScrollController();

  @override
  void initState() {
    super.initState();
    _post = widget.post;
    _headingKeys = {
      for (final h in _post.headings) h.id: GlobalKey(),
    };
    _progressViewModel = ReadingProgressViewModel(
      scrollController: _scrollController,
    );
    _tocViewModel = _post.headings.isEmpty
        ? null
        : TocViewModel(
            scrollController: _scrollController,
            headings: _post.headings,
            headingKeys: _headingKeys,
          );
  }

  @override
  void dispose() {
    _progressViewModel.dispose();
    _tocViewModel?.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final showSidebar = widget.screenWidth >= 1200;

    final contentColumn = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        BlogPostHeader(post: _post),
        const SizedBox(height: 32),
        if (!showSidebar && _tocViewModel != null) ...<Widget>[
          BlogTocCollapsible(viewModel: _tocViewModel),
          const SizedBox(height: 24),
        ],
        BlogPostMarkdownCard(
          sections: _post.sections,
          onOpenLink: widget.controller.openLink,
          sectionKeys: _headingKeys,
        ),
        const SizedBox(height: 28),
        ListenableBuilder(
          listenable: Listenable.merge(<Listenable>[
            widget.controller.loadPostCommand,
            widget.controller.likePostCommand,
          ]),
          builder: (context, _) {
            final currentPost = widget.controller.currentPost ?? _post;
            return BlogPostEngagementCard(
              post: currentPost,
              isLiking: widget.controller.likePostCommand.isLoading,
              onLikePressed: widget.controller.likePost,
              errorMessage: widget.controller.likePostCommand.error,
            );
          },
        ),
        const SizedBox(height: 32),
        Text(
          'Comments',
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.w800,
                color: Theme.of(context).blogPalette.textStrong,
              ),
        ),
        const SizedBox(height: 16),
        BlogCommentFormCard(controller: widget.controller),
        const SizedBox(height: 20),
        ListenableBuilder(
          listenable: widget.controller.loadCommentsCommand,
          builder: (context, _) {
            return BlogCommentsList(
              isLoading: widget.controller.loadCommentsCommand.isLoading,
              comments: widget.controller.loadCommentsCommand.data,
              error: widget.controller.loadCommentsCommand.error,
            );
          },
        ),
      ],
    );

    return Stack(
      children: <Widget>[
        SmoothScrollWrapper(
          controller: _scrollController,
          enabled: shouldEnableSmoothWheelScroll(widget.screenWidth),
          child: _buildLayout(
            showSidebar: showSidebar,
            content: contentColumn,
          ),
        ),
        Positioned(
          top: 0,
          left: 0,
          right: 0,
          child: ReadingProgressBar(viewModel: _progressViewModel),
        ),
      ],
    );
  }

  Widget _buildLayout({
    required bool showSidebar,
    required Widget content,
  }) {
    if (showSidebar) {
      return Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1280),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Expanded(
                child: SingleChildScrollView(
                  controller: _scrollController,
                  padding: const EdgeInsets.fromLTRB(24, 24, 24, 64),
                  child: Center(
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 720),
                      child: content,
                    ),
                  ),
                ),
              ),
              if (_tocViewModel != null)
                SizedBox(
                  width: 260,
                  child: BlogTocSidebar(viewModel: _tocViewModel),
                ),
            ],
          ),
        ),
      );
    }

    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 720),
        child: SingleChildScrollView(
          controller: _scrollController,
          padding: const EdgeInsets.fromLTRB(24, 24, 24, 64),
          child: content,
        ),
      ),
    );
  }
}
