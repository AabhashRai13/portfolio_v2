import 'package:flutter/material.dart';
import 'package:my_portfolio/app/navigation/site_navigation.dart';
import 'package:my_portfolio/app/navigation/site_top_bar.dart';
import 'package:my_portfolio/constants/breakpoints.dart';
import 'package:my_portfolio/core/resources/styles/home_palette.dart';
import 'package:my_portfolio/core/resources/styles/site_text.dart';

/// Shared scaffold for inner pages: top bar, big title, content.
class SitePage extends StatelessWidget {
  const SitePage({
    required this.title,
    required this.child,
    this.intro,
    this.section,
    this.showTitle = true,
    this.background,
    this.fillViewport = false,
    this.contentMaxWidth,
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

  /// Painted behind the whole viewport instead of the flat page colour.
  final Gradient? background;

  /// For a page composed as one screen: the page is at least the window's
  /// height and [child] sits centred in the space under the top bar, instead
  /// of leaving the window's bottom empty. Taller content still scrolls.
  /// The page draws its own heading: [showTitle] and [intro] are ignored.
  final bool fillViewport;

  /// Narrows the title and content into a centred column under the
  /// full-width top bar; null keeps them at the top bar's width.
  final double? contentMaxWidth;

  @override
  Widget build(BuildContext context) {
    final palette = Theme.of(context).homePalette;
    final isNarrow = MediaQuery.sizeOf(context).width < Breakpoints.smallTablet;

    return Scaffold(
      backgroundColor: palette.sectionBackground,
      body: DecoratedBox(
        decoration: BoxDecoration(gradient: background),
        // Fill the screen: the scroll view alone shrinks to short content,
        // which would end the gradient mid-screen.
        child: SizedBox.expand(
          child: SafeArea(
            child: LayoutBuilder(
              builder: (context, viewport) => SingleChildScrollView(
                child: Column(
                  children: [
                    Center(
                      child: ConstrainedBox(
                        constraints: const BoxConstraints(maxWidth: 1080),
                        child: Padding(
                          padding: _padding,
                          child: fillViewport
                              ? _filled(viewport.maxHeight)
                              : _stacked(palette, isNarrow: isNarrow),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  EdgeInsets get _padding =>
      EdgeInsets.fromLTRB(24, 12, 24, fillViewport ? 24 : 64);

  /// Top bar at the top, [child] centred in the rest of the window.
  Widget _filled(double viewportHeight) => ConstrainedBox(
    constraints: BoxConstraints(
      minHeight: viewportHeight - _padding.vertical,
    ),
    child: Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SiteTopBar(current: section),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 16),
          child: child,
        ),
        const SizedBox.shrink(),
      ],
    ),
  );

  /// Top bar, optional title and intro, then [child], top to bottom.
  Widget _stacked(HomePalette palette, {required bool isNarrow}) {
    final content = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
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
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SiteTopBar(current: section),
        SizedBox(height: isNarrow ? 32 : 56),
        if (contentMaxWidth case final maxWidth?)
          Center(
            child: ConstrainedBox(
              constraints: BoxConstraints(maxWidth: maxWidth),
              child: SizedBox(width: double.infinity, child: content),
            ),
          )
        else
          content,
      ],
    );
  }
}
