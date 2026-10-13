import 'package:flutter/foundation.dart';
import 'package:my_portfolio/app/navigation/site_navigation.dart';

/// Coordinates emphasis across the landing grid without changing its layout.
class LandingTileInteractionController extends ChangeNotifier {
  SiteSection? _hovered;
  SiteSection? _focused;
  SiteSection? _pressed;

  bool isActive(SiteSection section) => section == (_hovered ?? _focused);

  bool isFocused(SiteSection section) => section == _focused;

  /// A finger or mouse button is down on [section] (or a key just
  /// activated it): the tile squishes on top of its hover scale.
  bool isPressed(SiteSection section) => section == _pressed;

  double scaleFor(SiteSection section) {
    if (_hovered == null && _focused == null) return 1;
    return isActive(section) ? 1.04 : 0.94;
  }

  void setHovered(SiteSection section, {required bool isHovered}) {
    if (!isHovered && _hovered != section) return;
    final next = isHovered ? section : null;
    if (_hovered == next) return;
    _hovered = next;
    notifyListeners();
  }

  void setPressed(SiteSection section, {required bool isPressed}) {
    if (!isPressed && _pressed != section) return;
    final next = isPressed ? section : null;
    if (_pressed == next) return;
    _pressed = next;
    notifyListeners();
  }

  void setFocused(SiteSection section, {required bool isFocused}) {
    if (!isFocused && _focused != section) return;
    final next = isFocused ? section : null;
    if (_focused == next) return;
    _focused = next;
    notifyListeners();
  }
}
