import 'package:flutter/material.dart';
import 'package:my_portfolio/app/navigation/site_navigation.dart';
import 'package:my_portfolio/features/landing/presentation/views/landing_view.dart';
import 'package:my_portfolio/features/landing/presentation/widgets/landing_entrance.dart';

/// Landing composition boundary. Rendering and animation lifecycle live in
/// dedicated components; this page only wires user intent to navigation.
class LandingPage extends StatelessWidget {
  const LandingPage({super.key});

  static const Key tickerModeKey = ValueKey<String>('landing-ticker-mode');

  @override
  Widget build(BuildContext context) {
    final routeActive = ModalRoute.of(context)?.isCurrent ?? true;

    return TickerMode(
      key: tickerModeKey,
      enabled: routeActive,
      child: LandingEntrance(
        routeActive: routeActive,
        builder: (context, entrance, {required motionEnabled}) => LandingView(
          entrance: entrance,
          motionEnabled: motionEnabled,
          onOpenWidget: (section, origin) => openSiteSection(
            context,
            section,
            origin: origin,
          ),
          onOpenLink: (section) => openSiteSection(context, section),
        ),
      ),
    );
  }
}
