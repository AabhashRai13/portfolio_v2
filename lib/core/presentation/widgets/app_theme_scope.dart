import 'package:flutter/material.dart';
import 'package:my_portfolio/app/di/service_locator.dart';
import 'package:my_portfolio/core/controllers/app_theme_controller.dart';
import 'package:my_portfolio/core/resources/styles/dark_theme.dart';
import 'package:my_portfolio/core/resources/styles/theme.dart';

/// Applies the [AppThemeController]'s resolved theme to [child].
///
/// Wrap a route's subtree with this when you want that surface to honor the
/// user's Light / Dark / System preference. Surfaces that are not wrapped
/// inherit whatever theme the ancestor `MaterialApp` declares.
class AppThemeScope extends StatelessWidget {
  const AppThemeScope({required this.child, super.key});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    final controller = getIt<AppThemeController>();

    return ListenableBuilder(
      listenable: controller,
      builder: (context, _) {
        final brightness = _resolveBrightness(context, controller.mode);
        final data = brightness == Brightness.dark ? kDarkTheme : kLightTheme;
        return Theme(data: data, child: child);
      },
    );
  }

  Brightness _resolveBrightness(BuildContext context, ThemeMode mode) {
    switch (mode) {
      case ThemeMode.light:
        return Brightness.light;
      case ThemeMode.dark:
        return Brightness.dark;
      case ThemeMode.system:
        return MediaQuery.platformBrightnessOf(context);
    }
  }
}
