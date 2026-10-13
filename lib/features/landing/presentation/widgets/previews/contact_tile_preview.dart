import 'package:flutter/material.dart';
import 'package:my_portfolio/core/resources/styles/site_text.dart';

/// Contact tile: a chat bubble typing a first message, then the dots.
class ContactTilePreview extends StatelessWidget {
  const ContactTilePreview({
    required this.progress,
    required this.color,
    super.key,
  });

  static const message = "Hi Aabhash, we're building…";

  final double progress;
  final Color color;

  @override
  Widget build(BuildContext context) {
    final visible = ((progress / 0.72) * message.length).floor().clamp(
      0,
      message.length,
    );
    final dotCount = progress < 0.72 ? 0 : 1 + ((progress * 12).floor() % 3);

    return Padding(
      padding: const EdgeInsets.fromLTRB(10, 44, 10, 18),
      child: Align(
        alignment: Alignment.centerLeft,
        child: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.12),
            border: Border.all(color: color.withValues(alpha: 0.42)),
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(14),
              topRight: Radius.circular(14),
              bottomRight: Radius.circular(14),
              bottomLeft: Radius.circular(3),
            ),
          ),
          child: Text(
            visible < message.length
                ? message.substring(0, visible)
                : '$message${'.' * dotCount}',
            style: SiteText.body(color, size: 11).copyWith(height: 1.3),
          ),
        ),
      ),
    );
  }
}
