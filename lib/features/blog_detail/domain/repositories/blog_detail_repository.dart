import 'package:my_portfolio/core/resources/typedef.dart';
import 'package:my_portfolio/features/blog_detail/domain/entities/blog_comment_entity.dart';
import 'package:my_portfolio/features/blog_detail/domain/entities/blog_post_entity.dart';

abstract class BlogDetailRepository {
  ResultFuture<BlogPostEntity> getBlogPostBySlug(String slug);
  ResultFuture<bool> recordPostRead(BlogPostEntity post);
  ResultFuture<bool> likePost(BlogPostEntity post);
  ResultFuture<List<BlogCommentEntity>> getComments(String postId);
  ResultVoid addComment({
    required String postId,
    required String authorName,
    required String message,
  });
}
