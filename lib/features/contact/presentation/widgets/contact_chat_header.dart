import 'package:flutter/material.dart';
import 'package:my_portfolio/core/resources/styles/home_palette.dart';

/// Chat-style header for the contact form: who the visitor is writing to,
/// plus the host's back (landing phone) or close (contact panel) action.
class ContactChatHeader extends StatelessWidget {
  const ContactChatHeader({this.onBack, this.onClose, super.key});

  final VoidCallback? onBack;
  final VoidCallback? onClose;

  static const String _avatar = 'assets/images/intro_video_thumb.jpg';

  @override
  Widget build(BuildContext context) {
    final palette = Theme.of(context).homePalette;

    return DecoratedBox(
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: palette.primaryAccent.withValues(alpha: 0.2),
          ),
        ),
      ),
      child: Padding(
        padding: EdgeInsets.fromLTRB(
          onBack == null ? 20 : 4,
          8,
          onClose == null ? 20 : 4,
          8,
        ),
        child: Row(
          children: [
            if (onBack != null)
              IconButton(
                tooltip: 'Back to widgets',
                icon: Icon(
                  Icons.arrow_back_ios_new_rounded,
                  size: 18,
                  color: palette.textStrong,
                ),
                onPressed: onBack,
              ),
            ExcludeSemantics(
              child: ClipOval(
                child: Image.asset(
                  _avatar,
                  width: 36,
                  height: 36,
                  fit: BoxFit.cover,
                  alignment: const Alignment(0.1, -0.3),
                ),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Aabhash Rai',
                    style: TextStyle(
                      color: palette.textStrong,
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  Text(
                    'usually replies within a day',
                    style: TextStyle(
                      color: palette.textSecondary,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
            if (onClose != null)
              IconButton(
                tooltip: 'Close',
                icon: Icon(Icons.close_rounded, color: palette.textSecondary),
                onPressed: onClose,
              ),
          ],
        ),
      ),
    );
  }
}
