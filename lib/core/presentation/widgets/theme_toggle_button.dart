import 'package:flutter/material.dart';
import 'package:my_portfolio/app/di/service_locator.dart';
import 'package:my_portfolio/core/controllers/app_theme_controller.dart';

class ThemeToggleButton extends StatelessWidget {
  const ThemeToggleButton({this.iconColor, super.key});

  final Color? iconColor;

  @override
  Widget build(BuildContext context) {
    final controller = getIt<AppThemeController>();

    return ListenableBuilder(
      listenable: controller,
      builder: (context, _) {
        final mode = controller.mode;
        final resolvedIconColor =
            iconColor ?? Theme.of(context).colorScheme.onSurface;

        return PopupMenuButton<ThemeMode>(
          tooltip: 'Theme',
          initialValue: mode,
          onSelected: controller.setMode,
          icon: Icon(_iconFor(mode), color: resolvedIconColor),
          itemBuilder: (context) => <PopupMenuEntry<ThemeMode>>[
            _menuItem(
              ThemeMode.light,
              Icons.light_mode_outlined,
              'Light',
              mode,
            ),
            _menuItem(
              ThemeMode.dark,
              Icons.dark_mode_outlined,
              'Dark',
              mode,
            ),
            _menuItem(
              ThemeMode.system,
              Icons.brightness_medium,
              'System',
              mode,
            ),
          ],
        );
      },
    );
  }

  IconData _iconFor(ThemeMode mode) {
    switch (mode) {
      case ThemeMode.light:
        return Icons.light_mode_outlined;
      case ThemeMode.dark:
        return Icons.dark_mode_outlined;
      case ThemeMode.system:
        return Icons.brightness_auto_outlined;
    }
  }

  PopupMenuItem<ThemeMode> _menuItem(
    ThemeMode value,
    IconData icon,
    String label,
    ThemeMode current,
  ) {
    final isSelected = value == current;
    return PopupMenuItem<ThemeMode>(
      value: value,
      child: Row(
        children: <Widget>[
          Icon(icon, size: 18),
          const SizedBox(width: 12),
          Text(label),
          if (isSelected) ...<Widget>[
            const Spacer(),
            const Icon(Icons.check_rounded, size: 16),
          ],
        ],
      ),
    );
  }
}
