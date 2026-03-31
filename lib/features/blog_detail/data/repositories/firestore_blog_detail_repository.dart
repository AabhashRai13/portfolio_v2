import 'package:my_portfolio/core/error/exceptions.dart';
import 'package:my_portfolio/core/resources/typedef.dart';
import 'package:my_portfolio/core/services/firestore_request_handler.dart';
import 'package:my_portfolio/features/blog_detail/data/datasources/blog_detail_remote_data_source.dart';
import 'package:my_portfolio/features/blog_detail/data/models/blog_comment_document.dart';
import 'package:my_portfolio/features/blog_detail/data/models/blog_post_document.dart';
import 'package:my_portfolio/features/blog_detail/data/services/blog_analytics_service.dart';
import 'package:my_portfolio/features/blog_detail/data/services/blog_engagement_local_store.dart';
import 'package:my_portfolio/features/blog_detail/domain/entities/blog_comment_entity.dart';
import 'package:my_portfolio/features/blog_detail/domain/entities/blog_post_entity.dart';
import 'package:my_portfolio/features/blog_detail/domain/repositories/blog_detail_repository.dart';

class FirestoreBlogDetailRepositoryImpl implements BlogDetailRepository {
  FirestoreBlogDetailRepositoryImpl({
    required BlogDetailRemoteDataSource remoteDataSource,
    required FirestoreRequestHandler requestHandler,
    required BlogAnalyticsService analyticsService,
    required BlogEngagementLocalStore engagementLocalStore,
  }) : _remoteDataSource = remoteDataSource,
       _requestHandler = requestHandler,
       _analyticsService = analyticsService,
       _engagementLocalStore = engagementLocalStore;

  final BlogDetailRemoteDataSource _remoteDataSource;
  final FirestoreRequestHandler _requestHandler;
  final BlogAnalyticsService _analyticsService;
  final BlogEngagementLocalStore _engagementLocalStore;

  @override
  ResultFuture<BlogPostEntity> getBlogPostBySlug(String slug) {
    return _requestHandler.run<BlogPostEntity>(
      operation: 'blog_detail.getBlogPostBySlug',
      fallbackMessage: 'Unable to load this blog post right now.',
      request: () async {
        final querySnapshot = await _remoteDataSource.fetchPublishedPostBySlug(
          slug,
        );

        if (querySnapshot.docs.isEmpty) {
          throw const NotFoundException('Blog post not found');
        }

        final postDocument = BlogPostDocument.fromFirestore(
          querySnapshot.docs.first,
        );

        final counts = await Future.wait<int>([
          _remoteDataSource.fetchLikeCount(postDocument.id),
          _remoteDataSource.fetchCommentCount(postDocument.id),
          _remoteDataSource.fetchViewCount(postDocument.id),
        ]);

        return postDocument.toEntity(
          likeCount: counts[0],
          commentCount: counts[1],
          viewCount: counts[2],
          isLikedByCurrentBrowser: _engagementLocalStore.hasLiked(
            postDocument.slug,
          ),
        );
      },
      context: <String, dynamic>{
        'slug': slug,
      },
    );
  }

  @override
  ResultFuture<bool> recordPostRead(BlogPostEntity post) {
    return _requestHandler.run<bool>(
      operation: 'blog_detail.recordPostRead',
      fallbackMessage: 'Unable to record the blog read right now.',
      request: () async {
        if (_engagementLocalStore.hasRecordedView(post.slug)) {
          return false;
        }

        final sessionId = _engagementLocalStore.sessionId();
        await _remoteDataSource.createView(post.id, sessionId);

        _engagementLocalStore.markViewRecorded(post.slug);
        await _analyticsService.logBlogPostViewed(post.slug);
        return true;
      },
      context: <String, dynamic>{
        'postId': post.id,
        'slug': post.slug,
      },
    );
  }

  @override
  ResultFuture<bool> likePost(BlogPostEntity post) {
    return _requestHandler.run<bool>(
      operation: 'blog_detail.likePost',
      fallbackMessage: 'Unable to register your like right now.',
      request: () async {
        if (_engagementLocalStore.hasLiked(post.slug)) {
          return false;
        }

        final browserId = _engagementLocalStore.browserId();
        await _remoteDataSource.createLike(post.id, browserId);

        _engagementLocalStore.markLiked(post.slug);
        await _analyticsService.logBlogPostLiked(post.slug);
        return true;
      },
      context: <String, dynamic>{
        'postId': post.id,
        'slug': post.slug,
      },
    );
  }

  @override
  ResultFuture<List<BlogCommentEntity>> getComments(String postId) {
    return _requestHandler.run<List<BlogCommentEntity>>(
      operation: 'blog_detail.getComments',
      fallbackMessage: 'Unable to load comments right now.',
      request: () async {
        final snapshot = await _remoteDataSource.fetchComments(postId);
        return snapshot.docs
            .map(BlogCommentDocument.fromFirestore)
            .map((doc) => doc.toEntity())
            .toList(growable: false);
      },
      context: <String, dynamic>{
        'postId': postId,
      },
    );
  }

  @override
  ResultVoid addComment({
    required String postId,
    required String authorName,
    required String message,
  }) {
    return _requestHandler.runVoid(
      operation: 'blog_detail.addComment',
      fallbackMessage: 'Unable to post your comment right now.',
      request: () async {
        final data = await _remoteDataSource.fetchPostData(postId);
        if (data == null || data['isPublished'] != true) {
          throw const NotFoundException('Blog post not found');
        }

        await _remoteDataSource.createComment(
          postId: postId,
          authorName: authorName,
          message: message,
        );

        final slug = (data['slug'] as String?)?.trim();
        if (slug != null && slug.isNotEmpty) {
          await _analyticsService.logBlogCommentSubmitted(slug);
        }
      },
      context: <String, dynamic>{
        'postId': postId,
      },
    );
  }
}
