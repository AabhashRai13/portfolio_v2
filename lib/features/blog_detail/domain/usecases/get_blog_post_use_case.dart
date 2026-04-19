import 'package:my_portfolio/core/resources/typedef.dart';
import 'package:my_portfolio/features/blog_detail/domain/entities/blog_post_entity.dart';
import 'package:my_portfolio/features/blog_detail/domain/repositories/blog_detail_repository.dart';
import 'package:my_portfolio/features/blog_detail/domain/utils/markdown_heading_parser.dart';

class GetBlogPostUseCase {
  const GetBlogPostUseCase({
    required BlogDetailRepository repository,
  }) : _repository = repository;

  final BlogDetailRepository _repository;

  ResultFuture<BlogPostEntity> call(String slug) async {
    final result = await _repository.getBlogPostBySlug(slug);
    return result.map((post) {
      final parsed = parseMarkdownDocument(post.contentMarkdown);
      return post.copyWith(
        headings: parsed.headings,
        sections: parsed.sections,
      );
    });
  }
}
