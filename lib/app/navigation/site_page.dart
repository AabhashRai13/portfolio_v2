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
    this.contentMaxWidth,
    super.key,
  });

  static const Key titleKey = ValueKey<String>('site-page-title');

  final String title;
  final String? intro;
  final Widget child;

  /// Narrows the title and content into a centred column under the
  /// full-width top bar; null keeps them at the top bar's width.
  final double? contentMaxWidth;

  @override
  Widget build(BuildContext context) {
    final palette = Theme.of(context).homePalette;
    final isNarrow = MediaQuery.sizeOf(context).width < 600;
    final content = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
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
          Text(intro!, style: SiteText.body(palette.textSecondary)),
        ],
        SizedBox(height: isNarrow ? 32 : 48),
        child,
      ],
    );

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
                        if (contentMaxWidth case final maxWidth?)
                          Center(
                            child: ConstrainedBox(
                              constraints: BoxConstraints(maxWidth: maxWidth),
                              child: SizedBox(
                                width: double.infinity,
                                child: content,
                              ),
                            ),
                          )
                        else
                          content,
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
