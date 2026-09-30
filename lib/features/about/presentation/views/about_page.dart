import 'dart:async';

import 'package:flutter/material.dart';
import 'package:my_portfolio/app/navigation/site_navigation.dart';
import 'package:my_portfolio/app/navigation/site_page.dart';
import 'package:my_portfolio/app/navigation/site_text_link.dart';
import 'package:my_portfolio/core/resources/styles/home_palette.dart';
import 'package:my_portfolio/core/resources/styles/site_text.dart';
import 'package:my_portfolio/features/about/data/about_content.dart';
import 'package:my_portfolio/features/about/presentation/widgets/intro_video.dart';

class AboutPage extends StatelessWidget {
  const AboutPage({super.key});

  @override
  Widget build(BuildContext context) {
    final palette = Theme.of(context).homePalette;

    return SitePage(
      title: 'About',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const IntroVideo(),
          const SizedBox(height: 40),
          ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 720),
            child: Text(
              aboutBio,
              style: SiteText.body(palette.textStrong, size: 20),
            ),
          ),
          const SizedBox(height: 56),
          const _Heading('Skills'),
          for (final group in skillGroups) ...[
            Text(
              group.title.toUpperCase(),
              style: SiteText.label(palette.textSecondary),
            ),
            const SizedBox(height: 4),
            Text(group.items, style: SiteText.body(palette.textStrong)),
            const SizedBox(height: 20),
          ],
          const SizedBox(height: 36),
          const _Heading('Experience'),
          for (final job in experience) _JobRow(job: job),
          const SizedBox(height: 40),
          SiteTextLink(
            label: 'Download résumé ↗',
            fontSize: 15,
            onTap: () => unawaited(openResume()),
          ),
        ],
      ),
    );
  }
}

class _Heading extends StatelessWidget {
  const _Heading(this.text);

  final String text;

  @override
  Widget build(BuildContext context) {
    final palette = Theme.of(context).homePalette;
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Semantics(
        header: true,
        child: Text(
          text.toUpperCase(),
          style: SiteText.display(palette.textStrong, size: 48),
        ),
      ),
    );
  }
}

class _JobRow extends StatelessWidget {
  const _JobRow({required this.job});

  final Job job;

  @override
  Widget build(BuildContext context) {
    final palette = Theme.of(context).homePalette;
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16),
      decoration: BoxDecoration(
        border: Border(
          top: BorderSide(
            color: palette.primaryAccent.withValues(alpha: 0.3),
          ),
        ),
      ),
      child: Wrap(
        alignment: WrapAlignment.spaceBetween,
        crossAxisAlignment: WrapCrossAlignment.center,
        runSpacing: 6,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                job.company,
                style: SiteText.body(
                  palette.textStrong,
                ).copyWith(fontWeight: FontWeight.w700),
              ),
              Text(
                '${job.role} · ${job.location}',
                style: SiteText.body(palette.textSecondary, size: 15),
              ),
            ],
          ),
          Text(job.period, style: SiteText.label(palette.textSecondary)),
        ],
      ),
    );
  }
}
