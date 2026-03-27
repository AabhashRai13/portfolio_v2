import 'package:my_portfolio/core/commands/command.dart';
import 'package:my_portfolio/features/blog/domain/models/blog_post_summary.dart';
import 'package:my_portfolio/features/blog/domain/repositories/blog_repository.dart';

class BlogListController {
BlogListController({required this.blogRepository});

  final BlogRepository blogRepository ;

  final Command<List<BlogPostSummary>> loadBlogsCommand =
      Command(data: const <BlogPostSummary>[]);

  Future<void> loadBlogs() async {
    loadBlogsCommand.toggleLoading();

    try {
      final posts = await blogRepository.getBlogPosts();
      loadBlogsCommand.setData(posts);
    } on Exception {
      loadBlogsCommand.setError(
        'Unable to load blog posts right now. Please try again shortly.',
      );
    }
  }

  void dispose() {
    loadBlogsCommand.dispose();
  }
}
