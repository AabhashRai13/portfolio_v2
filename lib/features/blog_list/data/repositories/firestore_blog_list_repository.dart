import 'package:my_portfolio/core/resources/typedef.dart';
import 'package:my_portfolio/core/services/firestore_request_handler.dart';
import 'package:my_portfolio/features/blog_list/data/datasources/blog_list_remote_data_source.dart';
import 'package:my_portfolio/features/blog_list/data/models/blog_post_summary_document.dart';
import 'package:my_portfolio/features/blog_list/domain/entities/blog_post_summary_entity.dart';
import 'package:my_portfolio/features/blog_list/domain/repositories/blog_list_repository.dart';

class FirestoreBlogListRepositoryImpl implements BlogListRepository {
  FirestoreBlogListRepositoryImpl({
    required BlogListRemoteDataSource remoteDataSource,
    required FirestoreRequestHandler requestHandler,
  }) : _remoteDataSource = remoteDataSource,
       _requestHandler = requestHandler;

  final BlogListRemoteDataSource _remoteDataSource;
  final FirestoreRequestHandler _requestHandler;

  @override
  ResultFuture<List<BlogPostSummaryEntity>> getBlogPosts() {
    return _requestHandler.run<List<BlogPostSummaryEntity>>(
      operation: 'blog_list.fetchPublishedPosts',
      fallbackMessage: 'Unable to load blog posts right now.',
      request: () async {
        final snapshot = await _remoteDataSource.fetchPublishedPosts();
        return snapshot.docs
            .map(BlogPostSummaryDocument.fromFirestore)
            .map((doc) => doc.toEntity())
            .toList(growable: false);
      },
      context: const <String, dynamic>{
        'collection': 'posts',
      },
    );
  }
}
