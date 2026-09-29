import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';
import 'package:my_portfolio/app/di/service_locator.dart';
import 'package:my_portfolio/app/router/app_routes.dart';
import 'package:my_portfolio/constants/sns_links.dart';
import 'package:my_portfolio/core/services/app_launch_service.dart';
import 'package:my_portfolio/features/contact/presentation/views/contact_panel.dart';

/// The landing hub's destinations, in display order.
enum SiteSection {
  work('Work', AppRoutes.work),
  about('About', AppRoutes.about),
  writing('Writing', AppRoutes.blog),
  contact('Contact', AppRoutes.contact);

  const SiteSection(this.label, this.route);

  final String label;
  final String route;
}

/// Contact opens as a panel over the current page; the rest are routes.
void openSiteSection(BuildContext context, SiteSection section) {
  if (section == SiteSection.contact) {
    unawaited(showContactPanel(context));
    return;
  }
  context.go(section.route);
}

Future<void> openResume() => openExternal(SnsLinks.resume);

Future<void> openExternal(String url) =>
    getIt<AppLaunchService>().openExternalUrl(url);
