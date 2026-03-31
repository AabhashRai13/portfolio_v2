import 'package:flutter/material.dart';
import 'package:my_portfolio/core/commands/command.dart';
import 'package:my_portfolio/core/error/failure_message_mapper.dart';
import 'package:my_portfolio/core/services/app_launch_service.dart';
import 'package:my_portfolio/features/blog_detail/domain/entities/blog_comment_entity.dart';
import 'package:my_portfolio/features/blog_detail/domain/entities/blog_post_entity.dart';
import 'package:my_portfolio/features/blog_detail/domain/repositories/blog_detail_repository.dart';

class BlogPostDetailController {
  BlogPostDetailController({
    required BlogDetailRepository blogDetailRepository,
    required AppLaunchService launchService,
  }) : _blogDetailRepository = blogDetailRepository,
       _launchService = launchService;

  final BlogDetailRepository _blogDetailRepository;
  final AppLaunchService _launchService;

  final formKey = GlobalKey<FormState>();
  final authorNameController = TextEditingController();
  final messageController = TextEditingController();

  final Command<BlogPostEntity?> loadPostCommand = Command<BlogPostEntity?>(
    data: null,
  );
  final Command<List<BlogCommentEntity>> loadCommentsCommand =
      Command<List<BlogCommentEntity>>(data: const <BlogCommentEntity>[]);
  final Command<bool> likePostCommand = Command<bool>(data: false);
  final Command<String?> submitCommentCommand = Command<String?>(data: null);

  BlogPostEntity? get currentPost => loadPostCommand.data;

  Future<void> loadPost(String slug) async {
    loadPostCommand.start();

    final result = await _blogDetailRepository.getBlogPostBySlug(slug);
    await result.fold(
      (failure) async {
        loadPostCommand.setError(
          mapFailureToMessage(
            failure,
            fallbackMessage:
                'Unable to load this blog post right now. Please try again '
                'shortly.',
          ),
        );
      },
      (post) async {
        var hydratedPost = post;

        final readResult = await _blogDetailRepository.recordPostRead(post);
        readResult.fold(
          (_) {},
          (wasRecorded) {
            if (wasRecorded) {
              hydratedPost = post.copyWith(viewCount: post.viewCount + 1);
            }
          },
        );

        loadPostCommand.setData(hydratedPost);
        await loadComments(hydratedPost.id);
      },
    );
  }

  Future<void> loadComments(String postId) async {
    loadCommentsCommand.start();

    final result = await _blogDetailRepository.getComments(postId);
    result.fold(
      (failure) => loadCommentsCommand.setError(
        mapFailureToMessage(
          failure,
          fallbackMessage:
              'Unable to load comments right now. Please try again shortly.',
        ),
      ),
      loadCommentsCommand.setData,
    );
  }

  Future<void> likePost() async {
    final post = currentPost;
    if (post == null || post.isLikedByCurrentBrowser) {
      return;
    }

    likePostCommand.start();

    final result = await _blogDetailRepository.likePost(post);
    result.fold(
      (failure) => likePostCommand.setError(
        mapFailureToMessage(
          failure,
          fallbackMessage:
              'Unable to register your like right now. Please try again later.',
        ),
      ),
      (didLike) {
        if (didLike) {
          loadPostCommand.setData(
            post.copyWith(
              likeCount: post.likeCount + 1,
              isLikedByCurrentBrowser: true,
            ),
          );
        }
        likePostCommand.setData(didLike);
      },
    );
  }

  Future<void> submitComment() async {
    final post = currentPost;
    final isValid = formKey.currentState?.validate() ?? false;
    if (!isValid || post == null) {
      return;
    }

    submitCommentCommand.start();

    final result = await _blogDetailRepository.addComment(
      postId: post.id,
      authorName: authorNameController.text.trim(),
      message: messageController.text.trim(),
    );

    await result.fold(
      (failure) async {
        submitCommentCommand.setError(
          mapFailureToMessage(
            failure,
            fallbackMessage:
                'Unable to post your comment right now. Please try again '
                'later.',
          ),
        );
      },
      (_) async {
        authorNameController.clear();
        messageController.clear();
        submitCommentCommand.setData(
          'Comment submitted for review. It will appear once approved.',
        );
      },
    );
  }

  Future<void> openLink(String url) {
    return _launchService.openExternalUrl(url);
  }

  String? validateAuthorName(String? value) {
    final name = value?.trim() ?? '';
    if (name.isEmpty) {
      return 'Please add your name.';
    }
    if (name.length < 3) {
      return 'Name must be at least 3 characters.';
    }
    if (name.length > 50) {
      return 'Name must be 50 characters or fewer.';
    }
    return null;
  }

  String? validateMessage(String? value) {
    final message = value?.trim() ?? '';
    if (message.isEmpty) {
      return 'Please write a comment.';
    }
    if (message.length < 4) {
      return 'Comment is too short.';
    }
    if (message.length > 2000) {
      return 'Comment must be 2000 characters or fewer.';
    }
    return null;
  }

  void resetCommentFeedback() {
    submitCommentCommand.setData(null);
  }

  void dispose() {
    authorNameController.dispose();
    messageController.dispose();
    loadPostCommand.dispose();
    loadCommentsCommand.dispose();
    likePostCommand.dispose();
    submitCommentCommand.dispose();
  }
}
