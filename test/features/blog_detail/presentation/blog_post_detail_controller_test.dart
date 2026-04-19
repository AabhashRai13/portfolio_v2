import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:my_portfolio/core/error/failures.dart';
import 'package:my_portfolio/features/blog_detail/domain/entities/blog_comment_entity.dart';
import 'package:my_portfolio/features/blog_detail/domain/entities/blog_post_entity.dart';
import 'package:my_portfolio/features/blog_detail/domain/usecases/get_blog_post_use_case.dart';
import 'package:my_portfolio/features/blog_detail/presentation/controllers/blog_post_detail_controller.dart';

import '../blog_detail_mocks.mocks.dart';

void main() {
  late MockBlogDetailRepository repo;
  late MockAppLaunchService launchService;
  late BlogPostDetailController controller;

  setUp(() {
    repo = MockBlogDetailRepository();
    launchService = MockAppLaunchService();
    controller = BlogPostDetailController(
      getBlogPost: GetBlogPostUseCase(repository: repo),
      blogDetailRepository: repo,
      launchService: launchService,
    );
    addTearDown(controller.dispose);
  });

  group('BlogPostDetailController', () {
    group('loadPost', () {
      test('bumps viewCount and loads comments when recordPostRead returns '
          'true', () async {
        final post = _post();
        _stubLoad(
          repo,
          post: post,
          recordRead: true,
          comments: <BlogCommentEntity>[_comment()],
        );

        await controller.loadPost(post.slug);

        expect(controller.loadPostCommand.error, isNull);
        expect(controller.loadPostCommand.data?.viewCount, post.viewCount + 1);
        expect(controller.loadCommentsCommand.data, hasLength(1));
        // The use case returns a hydrated copy of the post (via copyWith),
        // so the arg identity differs from the test's `post` and
        // BlogPostEntity has no value equality. Count-only check is enough.
        verify(repo.recordPostRead(any)).called(1);
        verify(repo.getComments(post.id)).called(1);
      });

      test('does not bump viewCount when recordPostRead returns false',
          () async {
        final post = _post();
        _stubLoad(repo, post: post, recordRead: false);

        await controller.loadPost(post.slug);

        expect(controller.loadPostCommand.data?.viewCount, post.viewCount);
      });

      test('still loads the post when recordPostRead fails', () async {
        final post = _post();
        when(repo.getBlogPostBySlug(any)).thenAnswer(
          (_) async => Right<Failure, BlogPostEntity>(post),
        );
        when(repo.recordPostRead(any)).thenAnswer(
          (_) async => const Left<Failure, bool>(ServerFailure()),
        );
        when(repo.getComments(any)).thenAnswer(
          (_) async => const Right<Failure, List<BlogCommentEntity>>(
            <BlogCommentEntity>[],
          ),
        );

        await controller.loadPost(post.slug);

        expect(controller.loadPostCommand.error, isNull);
        expect(controller.loadPostCommand.data?.viewCount, post.viewCount);
      });

      test('reports an error and skips comments when getBlogPost fails',
          () async {
        when(repo.getBlogPostBySlug(any)).thenAnswer(
          (_) async => const Left<Failure, BlogPostEntity>(
            ServerFailure(message: 'boom'),
          ),
        );

        await controller.loadPost('missing');

        expect(controller.loadPostCommand.data, isNull);
        expect(controller.loadPostCommand.error, isNotNull);
        verifyNever(repo.getComments(any));
      });
    });

    group('likePost', () {
      test('is a no-op when the browser has already liked the post', () async {
        final post = _post(isLiked: true, likeCount: 7);
        _stubLoad(repo, post: post, recordRead: false);
        await controller.loadPost(post.slug);

        await controller.likePost();

        verifyNever(repo.likePost(any));
        expect(controller.loadPostCommand.data?.likeCount, 7);
      });

      test('increments likeCount and flips isLiked on success', () async {
        final post = _post(likeCount: 3);
        _stubLoad(repo, post: post, recordRead: false);
        when(repo.likePost(any)).thenAnswer(
          (_) async => const Right<Failure, bool>(true),
        );
        await controller.loadPost(post.slug);

        await controller.likePost();

        expect(controller.loadPostCommand.data?.likeCount, 4);
        expect(
          controller.loadPostCommand.data?.isLikedByCurrentBrowser,
          isTrue,
        );
        expect(controller.likePostCommand.data, isTrue);
      });

      test('does not mutate the post when repository reports didLike=false',
          () async {
        final post = _post(likeCount: 3);
        _stubLoad(repo, post: post, recordRead: false);
        when(repo.likePost(any)).thenAnswer(
          (_) async => const Right<Failure, bool>(false),
        );
        await controller.loadPost(post.slug);

        await controller.likePost();

        expect(controller.loadPostCommand.data?.likeCount, 3);
        expect(
          controller.loadPostCommand.data?.isLikedByCurrentBrowser,
          isFalse,
        );
      });

      test('reports an error on failure', () async {
        final post = _post();
        _stubLoad(repo, post: post, recordRead: false);
        when(repo.likePost(any)).thenAnswer(
          (_) async => const Left<Failure, bool>(ServerFailure()),
        );
        await controller.loadPost(post.slug);

        await controller.likePost();

        expect(controller.likePostCommand.error, isNotNull);
      });
    });

    group('validators', () {
      test('validateAuthorName rejects empty, too short, too long', () {
        expect(controller.validateAuthorName(null), isNotNull);
        expect(controller.validateAuthorName('   '), isNotNull);
        expect(controller.validateAuthorName('ab'), isNotNull);
        expect(controller.validateAuthorName('a' * 51), isNotNull);
      });

      test('validateAuthorName accepts a trimmed 3-50 char name', () {
        expect(controller.validateAuthorName('Aabhash'), isNull);
        expect(controller.validateAuthorName('  Aabhash  '), isNull);
      });

      test('validateMessage rejects empty, too short, too long', () {
        expect(controller.validateMessage(null), isNotNull);
        expect(controller.validateMessage(''), isNotNull);
        expect(controller.validateMessage('hi'), isNotNull);
        expect(controller.validateMessage('a' * 2001), isNotNull);
      });

      test('validateMessage accepts a trimmed 4-2000 char message', () {
        expect(controller.validateMessage('Nice read'), isNull);
        expect(controller.validateMessage('a' * 2000), isNull);
      });
    });

    test('resetCommentFeedback clears the submitCommentCommand data', () {
      controller.submitCommentCommand.setData('some feedback');
      expect(controller.submitCommentCommand.data, isNotNull);

      controller.resetCommentFeedback();
      expect(controller.submitCommentCommand.data, isNull);
    });

    test('openLink forwards to AppLaunchService', () async {
      when(launchService.openExternalUrl(any)).thenAnswer((_) async {});

      await controller.openLink('https://example.com');

      verify(launchService.openExternalUrl('https://example.com')).called(1);
    });
  });
}

void _stubLoad(
  MockBlogDetailRepository repo, {
  required BlogPostEntity post,
  required bool recordRead,
  List<BlogCommentEntity> comments = const <BlogCommentEntity>[],
}) {
  when(repo.getBlogPostBySlug(any)).thenAnswer(
    (_) async => Right<Failure, BlogPostEntity>(post),
  );
  when(repo.recordPostRead(any)).thenAnswer(
    (_) async => Right<Failure, bool>(recordRead),
  );
  when(repo.getComments(any)).thenAnswer(
    (_) async => Right<Failure, List<BlogCommentEntity>>(comments),
  );
}

BlogPostEntity _post({
  int likeCount = 0,
  int viewCount = 0,
  bool isLiked = false,
}) {
  final now = DateTime(2026);
  return BlogPostEntity(
    id: 'id-1',
    slug: 'slug-1',
    title: 'Title',
    summary: 'Summary',
    contentMarkdown: '## Only Heading\nBody.',
    publishedAt: now,
    updatedAt: now,
    readTimeMinutes: 3,
    tags: const <String>[],
    likeCount: likeCount,
    commentCount: 0,
    viewCount: viewCount,
    isLikedByCurrentBrowser: isLiked,
  );
}

BlogCommentEntity _comment() => BlogCommentEntity(
      id: 'c1',
      authorName: 'Alex',
      message: 'Nice',
      createdAt: DateTime(2026),
    );
