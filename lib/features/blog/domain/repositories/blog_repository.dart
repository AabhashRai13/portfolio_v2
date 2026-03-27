import 'package:my_portfolio/features/blog/domain/models/blog_post_summary.dart';
// ignore_for_file: one_member_abstracts, document_ignores
// Kept as a repository contract so blog data sources can change without
// affecting controllers or views.
abstract class BlogRepository {
  Future<List<BlogPostSummary>> getBlogPosts();
}
