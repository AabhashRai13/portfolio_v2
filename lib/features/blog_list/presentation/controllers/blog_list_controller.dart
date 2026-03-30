import 'package:my_portfolio/core/commands/command.dart';
import 'package:my_portfolio/core/error/failure_message_mapper.dart';
import 'package:my_portfolio/features/blog_list/domain/entities/blog_post_summary_entity.dart';
import 'package:my_portfolio/features/blog_list/domain/repositories/blog_list_repository.dart';

class BlogListController {
  BlogListController({required BlogListRepository blogListRepository})
    : _blogListRepository = blogListRepository;

  final BlogListRepository _blogListRepository;

  final Command<List<BlogPostSummaryEntity>> loadBlogsCommand =
      Command<List<BlogPostSummaryEntity>>(
        data: const <BlogPostSummaryEntity>[],
      );

  Future<void> loadBlogs() async {
    loadBlogsCommand.start();

    final result = await _blogListRepository.getBlogPosts();
    result.fold(
      (failure) => loadBlogsCommand.setError(
        mapFailureToMessage(
          failure,
          fallbackMessage:
              'Unable to load blog posts right now. Please try again shortly.',
        ),
      ),
      loadBlogsCommand.setData,
    );
  }

  void dispose() {
    loadBlogsCommand.dispose();
  }
}
