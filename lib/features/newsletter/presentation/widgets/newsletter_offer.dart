import 'package:flutter/material.dart';
import 'package:my_portfolio/features/newsletter/presentation/controllers/newsletter_controller.dart';
import 'package:my_portfolio/features/newsletter/presentation/widgets/newsletter_highlights.dart';
import 'package:my_portfolio/features/newsletter/presentation/widgets/newsletter_subscribe_widget.dart';

/// Lays out the value highlights and the subscribe form side by side on wide
/// screens, stacking them vertically once there is no longer room.
class NewsletterOffer extends StatelessWidget {
  const NewsletterOffer({required this.controller, super.key});

  final NewsletterController controller;

  static const double _rowBreakpoint = 820;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        const highlights = NewsletterHighlights();
        final subscribe = NewsletterSubscribeWidget(
          controller: controller,
          title: 'Read it from the inside',
          description:
              'One email when there is something genuinely worth your time. '
              'No spam, no schedule to keep up with, unsubscribe any time.',
        );

        if (constraints.maxWidth < _rowBreakpoint) {
          return Column(
            children: <Widget>[
              highlights,
              const SizedBox(height: 44),
              subscribe,
            ],
          );
        }

        return Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            const Expanded(child: highlights),
            const SizedBox(width: 28),
            Expanded(child: subscribe),
          ],
        );
      },
    );
  }
}
