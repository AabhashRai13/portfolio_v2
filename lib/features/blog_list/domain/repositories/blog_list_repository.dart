import 'package:my_portfolio/core/resources/typedef.dart';
import 'package:my_portfolio/features/blog_list/domain/entities/blog_post_summary_entity.dart';

// Kept as a contract so the blog list feature can swap data sources without
// changing controllers or views.
// ignore_for_file: one_member_abstracts
abstract class BlogListRepository {
  ResultFuture<List<BlogPostSummaryEntity>> getBlogPosts();
}
