import 'package:flutter/material.dart';
import 'package:my_portfolio/core/services/theme_preference_store.dart';

class AppThemeController extends ChangeNotifier {
  AppThemeController({required ThemePreferenceStore store})
      : _store = store,
        _mode = store.read();

  final ThemePreferenceStore _store;
  ThemeMode _mode;

  ThemeMode get mode => _mode;

  void setMode(ThemeMode mode) {
    if (_mode == mode) return;
    _mode = mode;
    _store.write(mode);
    notifyListeners();
  }
}
