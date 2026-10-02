import 'package:flutter/material.dart';
import 'package:my_portfolio/app/navigation/site_footer.dart';
import 'package:my_portfolio/app/navigation/site_navigation.dart';
import 'package:my_portfolio/app/navigation/site_top_bar.dart';
import 'package:my_portfolio/core/resources/styles/home_palette.dart';
import 'package:my_portfolio/core/resources/styles/site_text.dart';

/// Shared scaffold for inner pages: top bar, big title, content, footer.
class SitePage extends StatelessWidget {
  const SitePage({
    required this.title,
    required this.child,
    this.intro,
    this.section,
    this.showTitle = true,
    super.key,
  });

  static const Key titleKey = ValueKey<String>('site-page-title');

  final String title;
  final String? intro;
  final Widget child;

  /// Highlighted in the top bar.
  final SiteSection? section;

  /// False when the top bar highlight already says where you are. The intro
  /// then serves as the page heading for screen readers.
  final bool showTitle;

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
                        SiteTopBar(current: section),
                        SizedBox(height: isNarrow ? 32 : 56),
                        if (showTitle) ...[
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
                          if (intro != null) const SizedBox(height: 16),
                        ],
                        if (intro != null)
                          Semantics(
                            header: !showTitle,
                            child: Text(
                              intro!,
                              style: SiteText.body(palette.textSecondary),
                            ),
                          ),
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
