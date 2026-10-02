import 'dart:async';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:my_portfolio/app/navigation/site_navigation.dart';
import 'package:my_portfolio/app/navigation/site_text_link.dart';
import 'package:my_portfolio/app/router/app_routes.dart';
import 'package:my_portfolio/constants/size.dart';
import 'package:my_portfolio/core/presentation/widgets/theme_toggle_button.dart';
import 'package:my_portfolio/core/resources/styles/home_palette.dart';
import 'package:my_portfolio/core/resources/styles/site_text.dart';

/// Slim bar for inner pages: name (home), destinations, résumé, theme.
/// Below [kSiteDesktopBreakpoint] the links move into a bottom-sheet menu.
class SiteTopBar extends StatelessWidget {
  const SiteTopBar({this.current, super.key});

  /// Highlighted as the page you are on.
  final SiteSection? current;

  static const String _resumeChoice = 'resume';

  @override
  Widget build(BuildContext context) {
    final palette = Theme.of(context).homePalette;
    final isDesktop =
        MediaQuery.sizeOf(context).width >= kSiteDesktopBreakpoint;

    return Row(
      children: [
        // Scales the name down at very narrow widths or large text scale
        // instead of overflowing.
        Expanded(
          child: FittedBox(
            fit: BoxFit.scaleDown,
            alignment: Alignment.centerLeft,
            child: Semantics(
              link: true,
              label: 'Home',
              child: InkWell(
                onTap: () => context.go(AppRoutes.home),
                borderRadius: BorderRadius.circular(6),
                child: ConstrainedBox(
                  constraints: const BoxConstraints(minHeight: 48),
                  child: Center(
                    widthFactor: 1,
                    child: Text(
                      'AABHASH RAI',
                      style: SiteText.display(palette.textStrong, size: 28),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
        if (isDesktop) ...[
          for (final section in SiteSection.values)
            Padding(
              padding: const EdgeInsets.only(left: 12),
              child: SiteTextLink(
                label: section.label,
                plain: true,
                fontSize: 16,
                selected: section == current,
                onTap: () => openSiteSection(context, section),
              ),
            ),
          Padding(
            padding: const EdgeInsets.only(left: 12, right: 8),
            child: SiteTextLink(
              label: 'Résumé',
              plain: true,
              fontSize: 16,
              onTap: () => unawaited(openResume()),
            ),
          ),
        ],
        ThemeToggleButton(iconColor: palette.textSecondary),
        if (!isDesktop)
          IconButton(
            tooltip: 'Menu',
            icon: Icon(Icons.menu_rounded, color: palette.textStrong),
            onPressed: () => unawaited(_showMenu(context)),
          ),
      ],
    );
  }

  Future<void> _showMenu(BuildContext context) async {
    final palette = Theme.of(context).homePalette;
    final choice = await showModalBottomSheet<Object>(
      context: context,
      backgroundColor: palette.sectionBackground,
      showDragHandle: true,
      builder: (sheetContext) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(24, 0, 24, 16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              for (final section in SiteSection.values)
                SiteTextLink(
                  label: section.label,
                  plain: true,
                  fontSize: 18,
                  selected: section == current,
                  onTap: () => Navigator.of(sheetContext).pop(section),
                ),
              SiteTextLink(
                label: 'Résumé',
                plain: true,
                fontSize: 18,
                onTap: () => Navigator.of(sheetContext).pop(_resumeChoice),
              ),
            ],
          ),
        ),
      ),
    );

    // Act after the sheet closes, from the page's context.
    if (!context.mounted) return;
    if (choice is SiteSection) openSiteSection(context, choice);
    if (choice == _resumeChoice) await openResume();
  }
}
