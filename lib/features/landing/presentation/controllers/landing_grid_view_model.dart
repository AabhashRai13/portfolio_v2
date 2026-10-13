import 'dart:async';
import 'dart:math' as math;

import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:my_portfolio/app/navigation/site_navigation.dart';
import 'package:my_portfolio/core/services/tap_feedback.dart';

/// Plays the tap sound and haptic tick, shifted by [pitch].
typedef TapFeedback = void Function({double pitch});

/// Everything the landing tiles decide: which one is hovered, focused or
/// pressed, and what a tap does. The grid only renders these answers.
///
/// Owned by the grid (built in `initState`, disposed in `dispose`). A tap
/// plays the tile's note, squishes it if a key rather than a finger pressed
/// it, and opens its page [openDelay] later, or straight away with
/// [reduceMotion].
class LandingGridViewModel extends ChangeNotifier {
  LandingGridViewModel({
    required this.onOpen,
    TapFeedback feedback = tapFeedback,
  }) : _feedback = feedback;

  /// The beat between a tap and its page: long enough to see the tile
  /// spring back from the press, short enough to read as instant.
  static const Duration openDelay = Duration(milliseconds: 120);

  /// How long a keyboard press, which has no pointer down or up, holds the
  /// tile squished.
  static const Duration keyPressHold = Duration(milliseconds: 90);

  /// How far a pressed tile sinks.
  static const double pressedScale = 0.95;

  /// Each tile plays the shared tap sound on its own note of a major
  /// pentatonic scale, rising from Contact (the Work carousel arrows' own
  /// note) to Work, so the grid sounds like one instrument.
  static double pitchFor(SiteSection section) {
    final semitones = switch (section) {
      SiteSection.work => 7,
      SiteSection.about => 4,
      SiteSection.writing => 2,
      SiteSection.contact => 0,
    };
    return math.pow(2, semitones / 12).toDouble();
  }

  /// Opens a tile's page. The grid keeps it current as its widget changes.
  ValueChanged<SiteSection> onOpen;

  /// Set from the platform's reduced-motion setting.
  bool reduceMotion = false;

  final TapFeedback _feedback;
  SiteSection? _hovered;
  SiteSection? _focused;
  SiteSection? _pressed;
  Timer? _open;
  Timer? _keyRelease;
  Offset? _downAt;
  bool _pointerPress = false;

  bool isActive(SiteSection section) => section == (_hovered ?? _focused);

  bool isFocused(SiteSection section) => section == _focused;

  /// A finger or mouse button is down on [section], or a key just
  /// activated it.
  bool isPressed(SiteSection section) => section == _pressed;

  /// Hover or focus grows one tile and steps the rest back.
  double hoverScaleFor(SiteSection section) {
    if (_hovered == null && _focused == null) return 1;
    return isActive(section) ? 1.04 : 0.94;
  }

  /// The press squish, applied on top of [hoverScaleFor].
  double pressScaleFor(SiteSection section) =>
      isPressed(section) ? pressedScale : 1;

  void setHovered(SiteSection section, {required bool isHovered}) {
    if (!isHovered && _hovered != section) return;
    final next = isHovered ? section : null;
    if (_hovered == next) return;
    _hovered = next;
    notifyListeners();
  }

  void setFocused(SiteSection section, {required bool isFocused}) {
    if (!isFocused && _focused != section) return;
    final next = isFocused ? section : null;
    if (_focused == next) return;
    _focused = next;
    notifyListeners();
  }

  /// Fed the raw pointer, not the tap gesture: inside the desktop phone the
  /// drag recogniser holds a tap back until the finger lifts, which would
  /// hide the squish on a quick click.
  void pointerDown(
    SiteSection section, {
    required Offset position,
    required int buttons,
  }) {
    if (buttons != kPrimaryButton) return;
    _downAt = position;
    _pointerPress = true;
    _setPressed(section, isPressed: true);
  }

  /// A press that moves past the touch slop is dragging the phone, not
  /// pressing a tile.
  void pointerMove(SiteSection section, Offset position) {
    final downAt = _downAt;
    if (downAt != null && (position - downAt).distance > kTouchSlop) {
      pointerCancel(section);
    }
  }

  void pointerUp(SiteSection section) => _release(section);

  /// The pointer left without a tap: a drag, or the system took it.
  void pointerCancel(SiteSection section) {
    _pointerPress = false;
    _release(section);
  }

  /// A tap, click, Enter or Space on [section].
  void activate(SiteSection section) {
    // One page per tap: ignore taps while the last one is on its way.
    if (_open?.isActive ?? false) return;
    _feedback(pitch: pitchFor(section));
    if (!_pointerPress) {
      // A key: give it the same squish a finger gets.
      _setPressed(section, isPressed: true);
      _keyRelease?.cancel();
      _keyRelease = Timer(keyPressHold, () => _release(section));
    }
    _pointerPress = false;
    if (reduceMotion) {
      onOpen(section);
      return;
    }
    _open = Timer(openDelay, () => onOpen(section));
  }

  void _release(SiteSection section) {
    _downAt = null;
    _setPressed(section, isPressed: false);
  }

  void _setPressed(SiteSection section, {required bool isPressed}) {
    if (!isPressed && _pressed != section) return;
    final next = isPressed ? section : null;
    if (_pressed == next) return;
    _pressed = next;
    notifyListeners();
  }

  @override
  void dispose() {
    _open?.cancel();
    _keyRelease?.cancel();
    super.dispose();
  }
}
