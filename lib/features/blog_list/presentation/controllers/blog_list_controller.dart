import 'package:my_portfolio/core/commands/command.dart';
import 'package:my_portfolio/core/error/failure_message_mapper.dart';
import 'package:my_portfolio/features/blog_list/domain/entities/blog_post_summary_entity.dart';
import 'package:my_portfolio/features/blog_list/domain/usecases/get_blog_posts_use_case.dart';

class BlogListController {
  BlogListController({
    required GetBlogPostsUseCase getBlogPosts,
  }) : _getBlogPosts = getBlogPosts;

  final GetBlogPostsUseCase _getBlogPosts;
  List<BlogPostSummaryEntity> _loadedPosts = const <BlogPostSummaryEntity>[];

  final Command<List<BlogPostSummaryEntity>> loadBlogsCommand =
      Command<List<BlogPostSummaryEntity>>(
        data: const <BlogPostSummaryEntity>[],
      );

  Future<void> loadBlogs({
    BlogPostSortOrder sortOrder = BlogPostSortOrder.recentFirst,
  }) async {
    loadBlogsCommand.start();

    final result = await _getBlogPosts(sortOrder: sortOrder);
    result.fold(
      (failure) => loadBlogsCommand.setError(
        mapFailureToMessage(
          failure,
          fallbackMessage:
              'Unable to load blog posts right now. Please try again shortly.',
        ),
      ),
      (posts) {
        _loadedPosts = posts;
        loadBlogsCommand.setData(posts);
      },
    );
  }

  void applySort(BlogPostSortOrder sortOrder) {
    if (_loadedPosts.isEmpty) {
      return;
    }

    loadBlogsCommand.setData(
      _getBlogPosts.sortPosts(_loadedPosts, sortOrder: sortOrder),
    );
  }

  void dispose() {
    loadBlogsCommand.dispose();
  }
}
