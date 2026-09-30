import 'dart:async';
import 'dart:math' as math;

import 'package:flutter/animation.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/physics.dart';

/// Presentation state and motion policy for the draggable landing phone.
class LandingPhoneMotionController extends ChangeNotifier {
  LandingPhoneMotionController({required TickerProvider vsync})
    : _float = AnimationController(
        vsync: vsync,
        duration: const Duration(seconds: 6),
      ),
      _x = AnimationController.unbounded(vsync: vsync),
      _y = AnimationController.unbounded(vsync: vsync) {
    _float.addListener(notifyListeners);
    _x.addListener(notifyListeners);
    _y.addListener(notifyListeners);
  }

  static const _restingRotation = -0.045;
  static const double _maxRotation = 8 * math.pi / 180;
  static const _spring = SpringDescription(
    mass: 1,
    stiffness: 170,
    damping: 17,
  );

  final AnimationController _float;
  final AnimationController _x;
  final AnimationController _y;

  bool _enabled = true;
  bool _hovered = false;
  bool _dragging = false;
  double _dragRotation = 0;

  bool get enabled => _enabled;
  bool get hovered => _hovered;
  bool get dragging => _dragging;

  double get rotation =>
      _dragging ? _dragRotation : (_enabled && _hovered ? 0 : _restingRotation);

  Offset get offset {
    final floatOffset = _enabled
        ? math.sin(_float.value * math.pi * 2) * 4
        : 0.0;
    return Offset(
      _enabled ? _x.value : 0,
      (_enabled ? _y.value : 0) + floatOffset - (_enabled && _hovered ? 7 : 0),
    );
  }

  void setEnabled({required bool isEnabled}) {
    if (_enabled == isEnabled) return;
    _enabled = isEnabled;
    if (isEnabled) {
      _float.repeat();
    } else {
      _float.stop();
    }
    notifyListeners();
  }

  void start() {
    if (_enabled && !_float.isAnimating) _float.repeat();
  }

  void setHovered({required bool isHovered}) {
    if (_hovered == isHovered) return;
    _hovered = isHovered;
    notifyListeners();
  }

  void onPanStart(DragStartDetails details) {
    if (!_enabled) return;
    _x.stop();
    _y.stop();
    _dragging = true;
    notifyListeners();
  }

  void onPanUpdate(DragUpdateDetails details) {
    if (!_enabled) return;
    _x.value += details.delta.dx;
    _y.value += details.delta.dy;
    _dragRotation = (details.delta.dx * math.pi / 60).clamp(
      -_maxRotation,
      _maxRotation,
    );
    notifyListeners();
  }

  void onPanEnd(DragEndDetails details) {
    if (!_enabled) return;
    _dragging = false;
    _dragRotation = 0;
    notifyListeners();
    unawaited(
      _x.animateWith(
        SpringSimulation(
          _spring,
          _x.value,
          0,
          details.velocity.pixelsPerSecond.dx,
        ),
      ),
    );
    unawaited(
      _y.animateWith(
        SpringSimulation(
          _spring,
          _y.value,
          0,
          details.velocity.pixelsPerSecond.dy,
        ),
      ),
    );
  }

  @override
  void dispose() {
    _float.dispose();
    _x.dispose();
    _y.dispose();
    super.dispose();
  }
}
