import 'dart:ui';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:my_portfolio/constants/size.dart';

/// A [ScrollBehavior] that enables mouse-drag scrolling on web and uses
/// smooth clamping physics across all platforms.
class PortfolioScrollBehavior extends MaterialScrollBehavior {
  const PortfolioScrollBehavior();

  @override
  Set<PointerDeviceKind> get dragDevices => <PointerDeviceKind>{
        PointerDeviceKind.touch,
        PointerDeviceKind.mouse,
        PointerDeviceKind.trackpad,
        PointerDeviceKind.stylus,
        PointerDeviceKind.unknown,
      };
}

class SmoothWheelScrollController extends ScrollController {
  SmoothWheelScrollController({
    this.wheelDeltaMultiplier = 2.0,
    this.trackpadDeltaMultiplier = 1.0,
    this.smallDeltaThreshold = 20.0,
    this.lerpFactor = 0.18,
    this.snapThreshold = 0.5,
    bool smoothWheelEnabled = false,
  }) : _smoothWheelEnabled = smoothWheelEnabled;

  /// Multiplier for discrete mouse-wheel deltas.
  final double wheelDeltaMultiplier;

  /// Multiplier for trackpad / high-frequency small deltas.
  final double trackpadDeltaMultiplier;

  /// Deltas below this absolute value are treated as trackpad events.
  final double smallDeltaThreshold;

  /// Per-frame interpolation factor (0–1). Higher = snappier.
  final double lerpFactor;

  /// When within this many pixels of target, snap and stop the ticker.
  final double snapThreshold;

  bool _smoothWheelEnabled;

  bool get smoothWheelEnabled => _smoothWheelEnabled;

  set smoothWheelEnabled(bool value) {
    if (_smoothWheelEnabled == value) return;
    _smoothWheelEnabled = value;
    resetWheelTarget();
  }

  void resetWheelTarget() {
    if (!hasClients) return;
    final pos = position;
    if (pos is _SmoothWheelScrollPosition) {
      pos.cancelChase();
    }
  }

  @override
  ScrollPosition createScrollPosition(
    ScrollPhysics physics,
    ScrollContext context,
    ScrollPosition? oldPosition,
  ) {
    return _SmoothWheelScrollPosition(
      physics: physics,
      context: context,
      oldPosition: oldPosition,
      keepScrollOffset: keepScrollOffset,
      initialPixels: initialScrollOffset,
      debugLabel: debugLabel,
      controller: this,
    );
  }
}

class _SmoothWheelScrollPosition extends ScrollPositionWithSingleContext {
  _SmoothWheelScrollPosition({
    required super.physics,
    required super.context,
    required SmoothWheelScrollController controller,
    super.initialPixels,
    super.keepScrollOffset,
    super.oldPosition,
    super.debugLabel,
  }) : _controller = controller;

  final SmoothWheelScrollController _controller;

  Ticker? _ticker;
  double _targetOffset = 0;
  bool _chasing = false;

  @override
  void pointerScroll(double delta) {
    if (!_controller.smoothWheelEnabled || delta == 0) {
      super.pointerScroll(delta);
      return;
    }

    final isTrackpad = delta.abs() < _controller.smallDeltaThreshold;

    // Trackpad: OS already does momentum smoothing, apply directly.
    if (isTrackpad) {
      final adjusted = delta * _controller.trackpadDeltaMultiplier;
      final target = clampDouble(
        pixels + adjusted,
        minScrollExtent,
        maxScrollExtent,
      );
      if (target != pixels) {
        jumpTo(target);
      }
      return;
    }

    // Mouse wheel: accumulate target and let the ticker chase it smoothly.
    if (!_chasing) {
      _targetOffset = pixels;
    }

    final adjusted = delta * _controller.wheelDeltaMultiplier;
    _targetOffset = clampDouble(
      _targetOffset + adjusted,
      minScrollExtent,
      maxScrollExtent,
    );

    if (!_chasing) {
      _startChasing();
    }
  }

  void _startChasing() {
    _chasing = true;
    _ticker ??= context.vsync.createTicker(_onTick);
    if (!_ticker!.isActive) {
      _ticker!.start();
    }
  }

  void _onTick(Duration elapsed) {
    if (!hasPixels) {
      _stopChasing();
      return;
    }

    final diff = _targetOffset - pixels;
    if (diff.abs() < _controller.snapThreshold) {
      jumpTo(_targetOffset);
      _stopChasing();
      return;
    }

    // Exponential interpolation: move a fixed fraction toward
    // target each frame for smooth deceleration.
    jumpTo(pixels + diff * _controller.lerpFactor);
  }

  void _stopChasing() {
    _ticker?.stop();
    _chasing = false;
  }

  void cancelChase() {
    _stopChasing();
    _targetOffset = hasPixels ? pixels : 0;
  }

  @override
  void beginActivity(ScrollActivity? newActivity) {
    // If the user starts dragging, cancel any active chase so we don't fight.
    if (_chasing && newActivity is DragScrollActivity) {
      cancelChase();
    }
    super.beginActivity(newActivity);
  }

  @override
  void dispose() {
    _ticker?.dispose();
    _ticker = null;
    super.dispose();
  }
}

bool shouldEnableSmoothWheelScroll(double width) {
  if (width < kMinDesktopWidth) {
    return false;
  }

  if (kIsWeb) {
    return defaultTargetPlatform != TargetPlatform.android &&
        defaultTargetPlatform != TargetPlatform.iOS;
  }

  return switch (defaultTargetPlatform) {
    TargetPlatform.macOS ||
    TargetPlatform.windows ||
    TargetPlatform.linux => true,
    _ => false,
  };
}
