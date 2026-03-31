import 'package:flutter/material.dart';
import 'package:my_portfolio/constants/colors.dart';
import 'package:my_portfolio/features/blog_detail/presentation/controllers/blog_post_detail_controller.dart';
import 'package:my_portfolio/features/blog_detail/presentation/widgets/editorial_action_button.dart';

class BlogCommentFormCard extends StatelessWidget {
  const BlogCommentFormCard({
    required this.controller,
    super.key,
  });

  final BlogPostDetailController controller;

  @override
  Widget build(BuildContext context) {
    final canSubmit = !controller.submitCommentCommand.isLoading;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 220),
      curve: Curves.easeOutCubic,
      padding: const EdgeInsets.all(26),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.95),
        borderRadius: BorderRadius.circular(30),
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: <Color>[
            Color(0xFFFFFFFF),
            Color(0xFFFFFAF5),
          ],
        ),
        border: Border.all(
          color: const Color(0xFFF0E3D7),
        ),
        boxShadow: <BoxShadow>[
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.045),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
          BoxShadow(
            color: Colors.white.withValues(alpha: 0.74),
            blurRadius: 10,
            offset: const Offset(-4, -4),
          ),
        ],
      ),
      child: Form(
        key: controller.formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            const Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                _CommentMoodBadge(),
                SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        'Leave a thoughtful note',
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.w800,
                          color: CustomColor.textPrimary,
                        ),
                      ),
                      SizedBox(height: 6),
                      Text(
                        'A sentence, a reaction, a gentle disagreement, or a '
                        'clever observation. Keep it real, not perfect.',
                        style: TextStyle(
                          fontSize: 15,
                          height: 1.6,
                          color: CustomColor.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 22),
            TextFormField(
              controller: controller.authorNameController,
              validator: controller.validateAuthorName,
              textInputAction: TextInputAction.next,
              decoration: _inputDecoration(
                labelText: 'Your name',
                hintText: 'The name you would like to be seen with',
              ),
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: controller.messageController,
              validator: controller.validateMessage,
              minLines: 4,
              maxLines: 8,
              decoration: _inputDecoration(
                labelText: 'Your message',
                hintText:
                    'What stood out, what you agree with, or where you think '
                    'I am wrong.',
                alignLabelWithHint: true,
              ),
            ),
            const SizedBox(height: 16),
           
            const SizedBox(height: 22),
            Row(
              children: <Widget>[
                Expanded(
                  child: EditorialActionButton(
                    onPressed: canSubmit ? controller.submitComment : null,
                    isActive: controller.submitCommentCommand.isLoading,
                    expand: true,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Icon(
                          controller.submitCommentCommand.isLoading
                              ? Icons.hourglass_top_rounded
                              : Icons.mode_comment_outlined,
                        ),
                        const SizedBox(width: 10),
                        Text(
                          controller.submitCommentCommand.isLoading
                              ? 'Sending it through...'
                              : 'Post your thoughts',
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
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

InputDecoration _inputDecoration({
  required String labelText,
  required String hintText,
  bool alignLabelWithHint = false,
}) {
  OutlineInputBorder border(Color color, {double width = 1.2}) {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(20),
      borderSide: BorderSide(
        color: color,
        width: width,
      ),
    );
  }

  return InputDecoration(
    labelText: labelText,
    hintText: hintText,
    alignLabelWithHint: alignLabelWithHint,
    filled: true,
    fillColor: const Color(0xFFFFFCF8),
    hoverColor: const Color(0xFFFFF4EA),
    contentPadding: const EdgeInsets.symmetric(
      horizontal: 18,
      vertical: 18,
    ),
    labelStyle: const TextStyle(
      color: CustomColor.textSecondary,
      fontWeight: FontWeight.w600,
    ),
    hintStyle: TextStyle(
      color: CustomColor.textSecondary.withValues(alpha: 0.62),
      height: 1.45,
    ),
    enabledBorder: border(const Color(0xFFDCCDBF)),
    focusedBorder: border(CustomColor.secondary, width: 1.8),
    errorBorder: border(Colors.redAccent),
    focusedErrorBorder: border(Colors.redAccent, width: 1.8),
  );
}

class _CommentMoodBadge extends StatelessWidget {
  const _CommentMoodBadge();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 46,
      height: 46,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: <Color>[
            Color(0xFFFFE7D6),
            Color(0xFFF4D7BF),
          ],
        ),
      ),
      alignment: Alignment.center,
      child: const Icon(
        Icons.draw_outlined,
        color: CustomColor.textPrimary,
      ),
    );
  }
}
