import 'package:flutter/material.dart';
import 'package:my_portfolio/core/resources/styles/blog_palette.dart';
import 'package:my_portfolio/features/blog_detail/presentation/controllers/blog_post_detail_controller.dart';

class BlogCommentFormCard extends StatelessWidget {
  const BlogCommentFormCard({
    required this.controller,
    super.key,
  });

  final BlogPostDetailController controller;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final palette = theme.blogPalette;
    final primary = theme.colorScheme.primary;
    final secondary = theme.colorScheme.secondary;

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 36, horizontal: 32),
      decoration: BoxDecoration(
        color: palette.surfaceElevated,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: palette.borderSoft),
        boxShadow: [
          BoxShadow(
            color: palette.shadowColor,
            blurRadius: 32,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Form(
        key: controller.formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.mode_comment_rounded,
                  color: primary,
                  size: 28,
                ),
                const SizedBox(width: 10),
                Text(
                  'Leave a Comment',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 26,
                    color: primary,
                    letterSpacing: 1.1,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 14),
            Center(
              child: Text(
                'Say what landed, what you disagree with, or what made you '
                'smile a little.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: palette.textSecondary,
                  fontSize: 15,
                  height: 1.6,
                ),
              ),
            ),
            const SizedBox(height: 26),
            _BlogCommentTextField(
              hintText: 'Your name',
              controller: controller.authorNameController,
              validator: controller.validateAuthorName,
            ),
            const SizedBox(height: 18),
            _BlogCommentTextField(
              hintText: 'Share your thoughts',
              controller: controller.messageController,
              validator: controller.validateMessage,
              maxLines: 8,
            ),
            const SizedBox(height: 18),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 14,
              ),
              decoration: BoxDecoration(
                color: palette.surfaceSubtle,
                borderRadius: BorderRadius.circular(14),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(
                    Icons.mark_chat_read_rounded,
                    color: primary,
                    size: 18,
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      'Comments are reviewed before they appear. Warm, honest, '
                      'and human wins every time.',
                      style: TextStyle(
                        color: palette.textSecondary,
                        height: 1.55,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: ListenableBuilder(
                listenable: controller.submitCommentCommand,
                builder: (context, _) {
                  final isLoading = controller.submitCommentCommand.isLoading;

                  return ElevatedButton.icon(
                    style: ButtonStyle(
                      backgroundColor: WidgetStateProperty.resolveWith<Color>((
                        states,
                      ) {
                        if (isLoading || states.contains(WidgetState.pressed)) {
                          return secondary;
                        }
                        if (states.contains(WidgetState.hovered)) {
                          return primary.withValues(alpha: 0.92);
                        }
                        return primary;
                      }),
                      foregroundColor: const WidgetStatePropertyAll<Color>(
                        Colors.white,
                      ),
                      elevation: WidgetStateProperty.resolveWith<double>((
                        states,
                      ) {
                        if (states.contains(WidgetState.pressed)) {
                          return 2;
                        }
                        return 4;
                      }),
                      padding: const WidgetStatePropertyAll<EdgeInsets>(
                        EdgeInsets.symmetric(vertical: 18),
                      ),
                      shape: WidgetStatePropertyAll<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                      ),
                      textStyle: const WidgetStatePropertyAll<TextStyle>(
                        TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                          letterSpacing: 1.1,
                        ),
                      ),
                    ),
                    onPressed: isLoading ? null : controller.submitComment,
                    icon: isLoading
                        ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              color: Colors.white,
                              strokeWidth: 2,
                            ),
                          )
                        : const Icon(Icons.send_rounded, size: 20),
                    label: Text(
                      isLoading ? 'Sending...' : 'Post your thoughts',
                    ),
                  );
                },
              ),
            ),
            if (controller.submitCommentCommand.error != null)
              Padding(
                padding: const EdgeInsets.only(top: 12),
                child: Text(
                  controller.submitCommentCommand.error!,
                  style: const TextStyle(
                    color: Colors.redAccent,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _BlogCommentTextField extends StatelessWidget {
  const _BlogCommentTextField({
    required this.hintText,
    required this.controller,
    required this.validator,
    this.maxLines = 1,
  });

  final String hintText;
  final TextEditingController controller;
  final String? Function(String?) validator;
  final int maxLines;

  @override
  Widget build(BuildContext context) {
    final palette = Theme.of(context).blogPalette;

    return TextFormField(
      controller: controller,
      validator: validator,
      maxLines: maxLines,
      style: TextStyle(color: palette.textStrong),
      decoration: InputDecoration(
        contentPadding: const EdgeInsets.all(16),
        filled: true,
        fillColor: palette.surfaceSubtle,
        focusedBorder: _inputBorder,
        enabledBorder: _inputBorder,
        border: _inputBorder,
        errorBorder: _inputBorder,
        focusedErrorBorder: _inputBorder,
        hintText: hintText,
        hintStyle: TextStyle(color: palette.textMuted),
      ),
    );
  }

  OutlineInputBorder get _inputBorder {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(10),
      borderSide: BorderSide.none,
    );
  }
}
