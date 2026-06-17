import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:my_portfolio/app/router/app_routes.dart';
import 'package:my_portfolio/core/presentation/widgets/blog_top_navigation_bar.dart';
import 'package:my_portfolio/core/resources/styles/blog_palette.dart';
import 'package:my_portfolio/core/services/smooth_wheel_scroll_controller.dart';
import 'package:my_portfolio/features/blog_list/domain/usecases/get_blog_posts_use_case.dart';
import 'package:my_portfolio/features/blog_list/presentation/controllers/blog_list_controller.dart';
import 'package:my_portfolio/features/blog_list/presentation/widgets/blog_feed_back_state.dart';
import 'package:my_portfolio/features/blog_list/presentation/widgets/blog_hero.dart';
import 'package:my_portfolio/features/blog_list/presentation/widgets/featured_story_card.dart';
import 'package:my_portfolio/features/blog_list/presentation/widgets/story_card.dart';

class BlogListPage extends StatefulWidget {
  const BlogListPage({required this.blogListController, super.key});

  final BlogListController blogListController;

  @override
  State<BlogListPage> createState() => _BlogListPageState();
}

class _BlogListPageState extends State<BlogListPage> {
  late final BlogListController blogListController;
  final scrollController = SmoothWheelScrollController();
  BlogPostSortOrder _sortOrder = BlogPostSortOrder.recentFirst;

  @override
  void initState() {
    super.initState();
    blogListController = widget.blogListController;
    blogListController.loadBlogs(sortOrder: _sortOrder);
  }

  @override
  void dispose() {
    scrollController.dispose();
    blogListController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final palette = Theme.of(context).blogPalette;

    return Scaffold(
      body: SmoothScrollWrapper(
        controller: scrollController,
        enabled: shouldEnableSmoothWheelScroll(screenWidth),
        child: Container(
          width: double.infinity,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: palette.pageGradient,
            ),
          ),
          child: SafeArea(
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 1180),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 28,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                      BlogTopNavigationBar(
                        onOpenHome: () => context.go(AppRoutes.home),
                      ),
                      const SizedBox(height: 24),
                      Expanded(
                        child: ListenableBuilder(
                          listenable: blogListController.loadBlogsCommand,
                          builder: (context, _) {
                            final command = blogListController.loadBlogsCommand;

                            if (command.isLoading && command.data.isEmpty) {
                              return Center(
                                child: CircularProgressIndicator(
                                  color: Theme.of(
                                    context,
                                  ).colorScheme.secondary,
                                ),
                              );
                            }

                            if (command.error != null) {
                              return Center(
                                child: BlogFeedbackState(
                                  title: 'Unable to load the Blogs right now.',
                                  message: command.error!,
                                  actionLabel: 'Try again',
                                  onPressed: blogListController.loadBlogs,
                                ),
                              );
                            }

                            if (command.data.isEmpty) {
                              return Center(
                                child: BlogFeedbackState(
                                  title: 'No stories published yet.',
                                  message:
                                      'Fresh notes, essays, and product '
                                      'thinking '
                                      'will show up here soon.',
                                  actionLabel: 'Refresh',
                                  onPressed: blogListController.loadBlogs,
                                ),
                              );
                            }

                            final posts = command.data;
                            final featuredPost = posts.first;
                            final remainingPosts = posts
                                .skip(1)
                                .toList(growable: false);

                            return SingleChildScrollView(
                              controller: scrollController,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: <Widget>[
                                  BlogHero(
                                    sortOrder: _sortOrder,
                                    onSortChanged: (value) {
                                      if (value == null) {
                                        return;
                                      }
                                      setState(() {
                                        _sortOrder = value;
                                      });
                                      blogListController.applySort(value);
                                    },
                                  ),
                                  const SizedBox(height: 34),
                                  FeaturedStoryCard(
                                    post: featuredPost,
                                    onTap: () => context.go(
                                      AppRoutes.blogPost(featuredPost.slug),
                                    ),
                                  ),
                                  if (remainingPosts.isNotEmpty) ...<Widget>[
                                    const SizedBox(height: 28),
                                    LayoutBuilder(
                                      builder: (context, constraints) {
                                        final isWide =
                                            constraints.maxWidth >= 880;
                                        const spacing = 24.0;
                                        final cardWidth = isWide
                                            ? (constraints.maxWidth - spacing) /
                                                  2
                                            : constraints.maxWidth;

                                        return Wrap(
                                          spacing: spacing,
                                          runSpacing: spacing,
                                          children: remainingPosts
                                              .map(
                                                (post) => SizedBox(
                                                  width: cardWidth,
                                                  child: StoryCard(
                                                    post: post,
                                                    onTap: () => context.go(
                                                      AppRoutes.blogPost(
                                                        post.slug,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              )
                                              .toList(growable: false),
                                        );
                                      },
                                    ),
                                  ],
                                ],
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
