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
      _y = AnimationController.unbounded(vsync: vsync),
      _dragRotation = AnimationController.unbounded(vsync: vsync),
      _hover = AnimationController(
        vsync: vsync,
        duration: const Duration(milliseconds: 420),
        reverseDuration: const Duration(milliseconds: 320),
      ) {
    emphasis = _hover;
    textScale = emphasis.drive(Tween<double>(begin: 1, end: 0.84));
    _float.addListener(notifyListeners);
    _x.addListener(notifyListeners);
    _y.addListener(notifyListeners);
    _dragRotation.addListener(notifyListeners);
    _hover.addListener(notifyListeners);
  }

  static const double _restingRotation = -5 * math.pi / 180;
  static const double _maxRotation = 8 * math.pi / 180;
  static const _spring = SpringDescription(
    mass: 1,
    stiffness: 170,
    damping: 17,
  );

  final AnimationController _float;
  final AnimationController _x;
  final AnimationController _y;
  final AnimationController _dragRotation;
  final AnimationController _hover;
  late final Animation<double> emphasis;
  late final Animation<double> textScale;

  bool _enabled = true;
  bool _hovered = false;
  bool _dragging = false;
  Offset _lastDragPosition = Offset.zero;

  bool get enabled => _enabled;
  bool get hovered => _hovered;
  bool get dragging => _dragging;

  Matrix4 get transform {
    final scale = 1 + (0.22 * emphasis.value);
    final restingPose = 1 - emphasis.value;
    final pose = Matrix4.identity()
      ..setEntry(3, 2, 0.0008)
      // A negative X pitch brings the lower edge toward the viewer.
      // Hover removes every resting rotation so the live screen faces forward.
      ..rotateX(-4 * math.pi / 180 * restingPose)
      ..rotateY(0.025 * restingPose)
      ..rotateZ((_restingRotation * restingPose) + _dragRotation.value)
      ..scaleByDouble(scale, scale, scale, 1);
    return Matrix4.translationValues(offset.dx, offset.dy, 0)..multiply(pose);
  }

  Offset get offset {
    final floatOffset = _enabled
        ? math.sin(_float.value * math.pi * 2) * 4 * (1 - emphasis.value)
        : 0.0;
    return Offset(
      _enabled ? _x.value : 0,
      (_enabled ? _y.value : 0) + floatOffset,
    );
  }

  void setEnabled({required bool isEnabled}) {
    if (_enabled == isEnabled) return;
    _enabled = isEnabled;
    if (isEnabled) {
      _float.repeat();
    } else {
      _hovered = false;
      _dragging = false;
      _float.stop();
      _x
        ..stop()
        ..value = 0;
      _y
        ..stop()
        ..value = 0;
      _hover
        ..stop()
        ..value = 0;
      _dragRotation
        ..stop()
        ..value = 0;
    }
    notifyListeners();
  }

  void start() {
    if (_enabled && !_float.isAnimating) _float.repeat();
  }

  void setHovered({required bool isHovered}) {
    if (_hovered == isHovered) return;
    _hovered = isHovered;
    if (!_enabled) return;
    unawaited(
      _hover.animateTo(
        isHovered ? 1 : 0,
        duration: Duration(milliseconds: isHovered ? 420 : 320),
        curve: Curves.easeOutCubic,
      ),
    );
  }

  void onPanStart(DragStartDetails details) {
    if (!_enabled) return;
    _x.stop();
    _y.stop();
    _lastDragPosition = details.globalPosition;
    _dragging = true;
    notifyListeners();
  }

  void onPanUpdate(DragUpdateDetails details) {
    if (!_enabled) return;
    // Global movement keeps the phone attached to the pointer as it scales.
    final delta = details.globalPosition - _lastDragPosition;
    _lastDragPosition = details.globalPosition;
    _x.value += delta.dx;
    _y.value += delta.dy;
    final rotation = (delta.dx * math.pi / 60).clamp(
      -_maxRotation,
      _maxRotation,
    );
    unawaited(
      _dragRotation.animateTo(
        rotation,
        duration: const Duration(milliseconds: 70),
        curve: Curves.easeOutCubic,
      ),
    );
  }

  void onPanEnd(DragEndDetails details) {
    if (!_enabled) return;
    _dragging = false;
    unawaited(
      _dragRotation.animateTo(
        0,
        duration: const Duration(milliseconds: 420),
        curve: Curves.easeOutCubic,
      ),
    );
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
    _dragRotation.dispose();
    _hover.dispose();
    super.dispose();
  }
}
