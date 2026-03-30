import 'dart:ui';

import 'package:flutter/material.dart';

class HomeWheelScrollCoordinator {
  HomeWheelScrollCoordinator({
    this.wheelDeltaMultiplier = 1.15,
    this.minimumDeltaThreshold = 4,
    this.burstWindow = const Duration(milliseconds: 140),
    this.minDuration = const Duration(milliseconds: 120),
    this.maxDuration = const Duration(milliseconds: 260),
    this.curve = Curves.easeOutCubic,
    DateTime Function()? clock,
  }) : _clock = clock ?? DateTime.now;

  final double wheelDeltaMultiplier;
  final double minimumDeltaThreshold;
  final Duration burstWindow;
  final Duration minDuration;
  final Duration maxDuration;
  final Curve curve;
  final DateTime Function() _clock;

  double? _targetOffset;
  DateTime? _lastWheelEventAt;

  double updateTargetOffset({
    required double currentOffset,
    required double minOffset,
    required double maxOffset,
    required double scrollDelta,
  }) {
    final adjustedDelta = scrollDelta * wheelDeltaMultiplier;
    if (adjustedDelta.abs() < minimumDeltaThreshold) {
      return currentOffset;
    }

    final now = _clock();
    final isBurstActive =
        _lastWheelEventAt != null &&
        now.difference(_lastWheelEventAt!) <= burstWindow;

    if (!isBurstActive || _targetOffset == null) {
      _targetOffset = currentOffset;
    }

    _lastWheelEventAt = now;
    _targetOffset = clampDouble(
      _targetOffset! + adjustedDelta,
      minOffset,
      maxOffset,
    );

    return _targetOffset!;
  }

  Duration animationDurationFor({
    required double currentOffset,
    required double targetOffset,
  }) {
    final distance = (targetOffset - currentOffset).abs();
    final ratio = (distance / 480).clamp(0.0, 1.0);
    final milliseconds =
        lerpDouble(
          minDuration.inMilliseconds.toDouble(),
          maxDuration.inMilliseconds.toDouble(),
          ratio,
        )!
            .round();

    return Duration(milliseconds: milliseconds);
  }

  void reset({double? currentOffset}) {
    _targetOffset = currentOffset;
    _lastWheelEventAt = null;
  }
}

class HomeSmoothScrollController extends ScrollController {
  HomeSmoothScrollController({
    HomeWheelScrollCoordinator? coordinator,
    bool smoothWheelEnabled = false,
  }) : _coordinator = coordinator ?? HomeWheelScrollCoordinator(),
       _smoothWheelEnabled = smoothWheelEnabled;

  final HomeWheelScrollCoordinator _coordinator;
  bool _smoothWheelEnabled;

  bool get smoothWheelEnabled => _smoothWheelEnabled;

  set smoothWheelEnabled(bool value) {
    if (_smoothWheelEnabled == value) {
      return;
    }

    _smoothWheelEnabled = value;
    resetWheelTarget();
  }

  void resetWheelTarget() {
    _coordinator.reset(currentOffset: hasClients ? position.pixels : null);
  }

  @override
  ScrollPosition createScrollPosition(
    ScrollPhysics physics,
    ScrollContext context,
    ScrollPosition? oldPosition,
  ) {
    return _HomeSmoothScrollPosition(
      physics: physics,
      context: context,
      oldPosition: oldPosition,
      keepScrollOffset: keepScrollOffset,
      initialPixels: initialScrollOffset,
      debugLabel: debugLabel,
      coordinator: _coordinator,
      isSmoothWheelEnabled: () => _smoothWheelEnabled,
    );
  }
}

class _HomeSmoothScrollPosition extends ScrollPositionWithSingleContext {
  _HomeSmoothScrollPosition({
    required super.physics,
    required super.context,
    required HomeWheelScrollCoordinator coordinator,
    required bool Function() isSmoothWheelEnabled,
    super.initialPixels,
    super.keepScrollOffset,
    super.oldPosition,
    super.debugLabel,
  }) : _coordinator = coordinator,
       _isSmoothWheelEnabled = isSmoothWheelEnabled;

  final HomeWheelScrollCoordinator _coordinator;
  final bool Function() _isSmoothWheelEnabled;

  @override
  void pointerScroll(double delta) {
    if (!_isSmoothWheelEnabled() || delta == 0) {
      super.pointerScroll(delta);
      return;
    }

    final targetOffset = _coordinator.updateTargetOffset(
      currentOffset: pixels,
      minOffset: minScrollExtent,
      maxOffset: maxScrollExtent,
      scrollDelta: delta,
    );

    if (targetOffset == pixels) {
      return;
    }

    final duration = _coordinator.animationDurationFor(
      currentOffset: pixels,
      targetOffset: targetOffset,
    );

    animateTo(
      targetOffset,
      duration: duration,
      curve: _coordinator.curve,
    );
  }
}
