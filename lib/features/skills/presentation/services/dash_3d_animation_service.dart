import 'dart:developer';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_3d_controller/flutter_3d_controller.dart';

class Dash3DAnimationService {
  Dash3DAnimationService();

  Flutter3DController _controller = Flutter3DController();
  bool _isModelLoaded = false;

  static const double _initialCameraTheta = 0;
  static const double _initialCameraPhi = 80;
  static const double _initialCameraRadius =
      100; // Dash might appear small with this radius

  static const double _yawSensitivity = 90;
  static const double _pitchSensitivity = 80;
  static const double _maxPitchDeviationFromHorizontal = 80;

  Flutter3DController get controller => _controller;

  /// The package disposes `onModelLoaded` inside the viewer's own dispose,
  /// so each mount must start with a fresh controller instance.
  void resetController() {
    _controller = Flutter3DController();
    _isModelLoaded = false;
  }

  void handleModelLoaded() {
    if (_isModelLoaded) {
      return;
    }

    _isModelLoaded = true;

    controller.setCameraOrbit(
      _initialCameraTheta,
      _initialCameraPhi,
      _initialCameraRadius,
    );

    controller
        .getAvailableAnimations()
        .then((animations) {
          if (animations.isNotEmpty) {
            final animationToPlay = animations.firstWhere(
              (name) => name.toLowerCase().contains('idle'),
              orElse: () => animations.first,
            );
            controller.playAnimation(animationName: animationToPlay);
          }
        })
        .catchError((Object e) {
          log('Dash3DAnimationService: Error getting animations: $e');
        });
  }

  void handleViewerDisposed() {
    _isModelLoaded = false;
  }

  /// Handles mouse movement to orbit the camera.
  /// Requires [event] and the [context] of the MouseRegion widget.
  void handleMouseMove(PointerEvent event, BuildContext context) {
    if (!_isModelLoaded) {
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

    final targetTheta = _initialCameraTheta - (centerX * _yawSensitivity);
    final phiOffset = -centerY * _pitchSensitivity;
    final targetPhi = _initialCameraPhi + phiOffset;

    const minPhi = 90.0 - _maxPitchDeviationFromHorizontal;
    const maxPhi = 90.0 + _maxPitchDeviationFromHorizontal;
    final clampedPhi = targetPhi.clamp(minPhi, maxPhi);

    controller.setCameraOrbit(targetTheta, clampedPhi, _initialCameraRadius);
  }

  /// Resets the camera to its initial orbit when the mouse exits the region.
  void handleMouseExit(PointerExitEvent event) {
    if (!_isModelLoaded) {
      return;
    }
    controller.setCameraOrbit(
      _initialCameraTheta,
      _initialCameraPhi,
      _initialCameraRadius,
    );
  }

  void dispose() {
    _isModelLoaded = false;
  }
}
