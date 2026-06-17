import 'package:flutter/material.dart';
import 'package:my_portfolio/core/resources/styles/blog_palette.dart';

/// Card listing what a subscriber gets, as a set of icon + title + body rows.
class NewsletterHighlights extends StatelessWidget {
  const NewsletterHighlights({super.key});

  static const List<({IconData icon, String title, String body})> _items = [
    (
      icon: Icons.auto_stories_outlined,
      title: 'Stories from the inside',
      body: 'Real moments from building real software, not polished case '
          'studies written after the fact.',
    ),
    (
      icon: Icons.query_stats_outlined,
      title: 'Checked against data',
      body: 'Every claim is held up against what actually happened. '
          'Conclusions earned, not vibes.',
    ),
    (
      icon: Icons.balance_outlined,
      title: 'Honest and ruthless',
      body: 'Honest about how the work feels, ruthless about what the facts '
          'say. Both, every time.',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final palette = Theme.of(context).blogPalette;

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 28, horizontal: 28),
      decoration: BoxDecoration(
        color: palette.surfaceSubtle,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: palette.borderSoft),
      ),
      child: Column(
        children: <Widget>[
          for (var i = 0; i < _items.length; i++) ...<Widget>[
            if (i > 0) ...<Widget>[
              const SizedBox(height: 20),
              Divider(height: 1, thickness: 1, color: palette.dividerSoft),
              const SizedBox(height: 20),
            ],
            _HighlightRow(item: _items[i], palette: palette),
          ],
        ],
      ),
    );
  }
}

class _HighlightRow extends StatelessWidget {
  const _HighlightRow({required this.item, required this.palette});

  final ({IconData icon, String title, String body}) item;
  final BlogPalette palette;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: palette.tagChipBackground,
            borderRadius: BorderRadius.circular(14),
          ),
          child: Icon(item.icon, size: 22, color: palette.metaAccent),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                item.title,
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w700,
                  color: palette.textStrong,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                item.body,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: palette.textSecondary,
                  height: 1.5,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
