import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:my_portfolio/core/error/failures.dart';
import 'package:my_portfolio/features/blog_detail/domain/entities/blog_post_entity.dart';
import 'package:my_portfolio/features/blog_detail/domain/usecases/get_blog_post_use_case.dart';

import '../../blog_detail_mocks.mocks.dart';

void main() {
  late MockBlogDetailRepository repo;
  late GetBlogPostUseCase useCase;

  setUp(() {
    repo = MockBlogDetailRepository();
    useCase = GetBlogPostUseCase(repository: repo);
  });

  group('GetBlogPostUseCase', () {
    test('hydrates headings + sections from post markdown on success',
        () async {
      const md = '''
Intro.

## First
Body one.

## Second
Body two.
''';
      when(repo.getBlogPostBySlug(any)).thenAnswer(
        (_) async => Right<Failure, BlogPostEntity>(_post(md)),
      );

      final result = await useCase('the-slug');

      final post = result.getOrElse(
        () => throw StateError('expected success'),
      );
      expect(post.headings.map((h) => h.id), <String>['first', 'second']);
      expect(post.sections, hasLength(3));
      expect(post.sections[0].heading, isNull);
      expect(post.sections[1].heading?.id, 'first');
      expect(post.sections[2].heading?.id, 'second');
    });

    test('passes repository failure through unchanged', () async {
      const failure = ServerFailure(message: 'boom');
      when(repo.getBlogPostBySlug(any)).thenAnswer(
        (_) async => const Left<Failure, BlogPostEntity>(failure),
      );

      final result = await useCase('missing');

      expect(result.isLeft(), isTrue);
      result.fold(
        (f) => expect(f, same(failure)),
        (_) => fail('expected failure'),
      );
    });

    test('forwards the slug to the repository', () async {
      when(repo.getBlogPostBySlug(any)).thenAnswer(
        (_) async => Right<Failure, BlogPostEntity>(_post('body')),
      );

      await useCase('the-slug');

      verify(repo.getBlogPostBySlug('the-slug')).called(1);
    });
  });
}

BlogPostEntity _post(String markdown) {
  final now = DateTime(2026);
  return BlogPostEntity(
    id: 'id-1',
    slug: 'my-slug',
    title: 'title',
    summary: 'summary',
    contentMarkdown: markdown,
    publishedAt: now,
    updatedAt: now,
    readTimeMinutes: 3,
    tags: const <String>[],
    likeCount: 0,
    commentCount: 0,
    viewCount: 0,
    isLikedByCurrentBrowser: false,
  );
}
