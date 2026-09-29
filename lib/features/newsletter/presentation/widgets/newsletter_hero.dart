import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:my_portfolio/core/resources/styles/blog_palette.dart';

/// Headline block for the newsletter page: an eyebrow label, the serif
/// headline, and the lead tagline.
class NewsletterHero extends StatelessWidget {
  const NewsletterHero({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final palette = theme.blogPalette;
    final isCompact = MediaQuery.of(context).size.width < 700;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        _Eyebrow(palette: palette),
        const SizedBox(height: 24),
        Text(
          'Software and AI,\nfrom the inside.',
          style: GoogleFonts.lora(
            fontSize: isCompact ? 32 : 44,
            height: 1.12,
            fontWeight: FontWeight.w600,
            color: palette.textStrong,
          ),
        ),
        const SizedBox(height: 20),
        Text(
          'Personal stories checked against actual data. Honest about the '
          'feelings, ruthless about the facts.',
          style: theme.textTheme.titleMedium?.copyWith(
            color: palette.textSecondary,
            height: 1.5,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}

class _Eyebrow extends StatelessWidget {
  const _Eyebrow({required this.palette});

  final BlogPalette palette;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
      decoration: BoxDecoration(
        color: palette.tagChipBackground,
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: palette.tagChipBorder),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Icon(Icons.mail_outline, size: 15, color: palette.tagChipForeground),
          const SizedBox(width: 8),
          Text(
            'THE NEWSLETTER',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w700,
              letterSpacing: 1.4,
              color: palette.tagChipForeground,
            ),
          ),
        ],
      ),
    );
  }
}
