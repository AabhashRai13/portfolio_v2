import 'package:my_portfolio/core/resources/typedef.dart';
import 'package:my_portfolio/features/blog_list/domain/entities/blog_post_summary_entity.dart';
import 'package:my_portfolio/features/blog_list/domain/repositories/blog_list_repository.dart';

enum BlogPostSortOrder {
  recentFirst('Recent First'),
  oldestFirst('Oldest First');

  const BlogPostSortOrder(this.label);

  final String label;
}

class GetBlogPostsUseCase {
  const GetBlogPostsUseCase({
    required BlogListRepository repository,
  }) : _repository = repository;

  final BlogListRepository _repository;

  ResultFuture<List<BlogPostSummaryEntity>> call({
    BlogPostSortOrder sortOrder = BlogPostSortOrder.recentFirst,
  }) async {
    final result = await _repository.getBlogPosts();
    return result.map((posts) => sortPosts(posts, sortOrder: sortOrder));
  }

  List<BlogPostSummaryEntity> sortPosts(
    List<BlogPostSummaryEntity> posts, {
    required BlogPostSortOrder sortOrder,
  }) {
    final sortedPosts = List<BlogPostSummaryEntity>.from(posts)
      ..sort((
        left,
        right,
      ) {
        final comparison = left.publishedAt.compareTo(right.publishedAt);
        return sortOrder == BlogPostSortOrder.recentFirst
            ? -comparison
            : comparison;
      });

    return List<BlogPostSummaryEntity>.unmodifiable(sortedPosts);
  }
}
