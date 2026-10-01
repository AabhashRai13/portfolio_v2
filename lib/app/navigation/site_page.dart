import 'package:flutter/material.dart';
import 'package:my_portfolio/app/navigation/site_footer.dart';
import 'package:my_portfolio/app/navigation/site_top_bar.dart';
import 'package:my_portfolio/core/resources/styles/home_palette.dart';
import 'package:my_portfolio/core/resources/styles/site_text.dart';

/// Shared scaffold for inner pages: top bar, big title, content, footer.
class SitePage extends StatelessWidget {
  const SitePage({
    required this.title,
    required this.child,
    this.intro,
    super.key,
  });

  static const Key titleKey = ValueKey<String>('site-page-title');

  final String title;
  final String? intro;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final palette = Theme.of(context).homePalette;
    final isNarrow = MediaQuery.sizeOf(context).width < 600;

    return Scaffold(
      backgroundColor: palette.sectionBackground,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 1080),
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(24, 12, 24, 64),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SiteTopBar(),
                        SizedBox(height: isNarrow ? 32 : 56),
                        Semantics(
                          header: true,
                          child: Text(
                            title.toUpperCase(),
                            key: titleKey,
                            style: SiteText.display(
                              palette.textStrong,
                              size: isNarrow ? 64 : 104,
                            ),
                          ),
                        ),
                        if (intro != null) ...[
                          const SizedBox(height: 16),
                          Text(
                            intro!,
                            style: SiteText.body(palette.textSecondary),
                          ),
                        ],
                        SizedBox(height: isNarrow ? 32 : 48),
                        child,
                      ],
                    ),
                  ),
                ),
              ),
              const SiteFooter(),
            ],
          ),
        ),
      ),
    );
  }
}
