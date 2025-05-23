import 'dart:developer';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_3d_controller/flutter_3d_controller.dart';

class MousePointerAnimation {
  static final MousePointerAnimation _instance =
      MousePointerAnimation._internal();
  factory MousePointerAnimation() {
    return _instance;
  }
  MousePointerAnimation._internal();

  Flutter3DController? controller = Flutter3DController();
  bool _isModelLoaded = false;

  static const double _initialCameraTheta = 0.0;
  static const double _initialCameraPhi = 80.0;
  static const double _initialCameraRadius =
      100.0; // Dash might appear small with this radius

  static const double _yawSensitivity = 90.0;
  static const double _pitchSensitivity = 80.0;
  static const double _maxPitchDeviationFromHorizontal = 80.0;

  /// Initializes the animation service with the 3D controller.
  /// Sets up listeners for model loading and initial camera/animation.
  void initialize() {
    if (controller!.onModelLoaded.value) {
      _onModelLoadedCallback();
    } else {
      controller!.onModelLoaded.addListener(_onModelLoadedCallback);
    }
  }

  void _onModelLoadedCallback() {
    // Ensure controller is not null and model is truly loaded
    if (controller != null && controller!.onModelLoaded.value) {
      if (_isModelLoaded) return; // Already processed this load event

      _isModelLoaded = true;

      // Set initial camera orbit
      controller!.setCameraOrbit(
          _initialCameraTheta, _initialCameraPhi, _initialCameraRadius);

      // Play animation
      controller!.getAvailableAnimations().then((animations) {
        if (animations.isNotEmpty) {
          String animationToPlay = animations.firstWhere(
              (name) => name.toLowerCase().contains('idle'),
              orElse: () => animations.first);
          controller!.playAnimation(animationName: animationToPlay);
        } else {}
      }).catchError((e) {
        log("MousePointerAnimation: Error getting animations: $e");
      });
    }
    controller?.onModelLoaded.removeListener(_onModelLoadedCallback);
  }

  /// Handles mouse movement to orbit the camera.
  /// Requires [event] and the [context] of the MouseRegion widget.
  void handleMouseMove(PointerEvent event, BuildContext context) {
    if (!_isModelLoaded || controller == null) {
      return;
    }

    final renderBox = context.findRenderObject() as RenderBox?;
    if (renderBox == null || !renderBox.hasSize) {
      return;
    }
    final size = renderBox.size;

    final normX = event.localPosition.dx / size.width;
    final normY = event.localPosition.dy / size.height;

    final centerX = normX - 0.5;
    final centerY = normY - 0.5;

    final double targetTheta =
        _initialCameraTheta - (centerX * _yawSensitivity);
    final double phiOffset = -centerY * _pitchSensitivity;
    final double targetPhi = _initialCameraPhi + phiOffset;

    const double minPhi = 90.0 - _maxPitchDeviationFromHorizontal;
    const double maxPhi = 90.0 + _maxPitchDeviationFromHorizontal;
    final double clampedPhi = targetPhi.clamp(minPhi, maxPhi);

    controller!.setCameraOrbit(targetTheta, clampedPhi, _initialCameraRadius);
  }

  /// Resets the camera to its initial orbit when the mouse exits the region.
  void handleMouseExit(PointerExitEvent event) {
    if (!_isModelLoaded || controller == null) {
      return;
    }
    controller!.setCameraOrbit(
        _initialCameraTheta, _initialCameraPhi, _initialCameraRadius);
  }

  void dispose() {
    controller?.onModelLoaded.removeListener(_onModelLoadedCallback);
  }
}
