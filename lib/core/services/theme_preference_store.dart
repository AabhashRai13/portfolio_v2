import 'package:flutter/material.dart';
import 'package:universal_html/html.dart' as html;

class ThemePreferenceStore {
  static const String _themeModeKey = 'app.themeMode';

  ThemeMode read() {
    final raw = html.window.localStorage[_themeModeKey];
    switch (raw) {
      case 'light':
        return ThemeMode.light;
      case 'dark':
        return ThemeMode.dark;
      case 'system':
      case null:
      case '':
        return ThemeMode.system;
      default:
        return ThemeMode.system;
    }
  }

  void write(ThemeMode mode) {
    html.window.localStorage[_themeModeKey] = _encode(mode);
  }

  String _encode(ThemeMode mode) {
    switch (mode) {
      case ThemeMode.light:
        return 'light';
      case ThemeMode.dark:
        return 'dark';
      case ThemeMode.system:
        return 'system';
    }
  }
}
