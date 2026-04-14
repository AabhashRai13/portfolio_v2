import 'dart:ui';

import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:my_portfolio/constants/size.dart';

/// A [ScrollBehavior] that enables mouse-drag scrolling on web and uses
/// clamping physics (no overscroll bounce) across all platforms.
///
/// Trackpad is intentionally excluded from [dragDevices] — trackpad scroll
/// events are handled via [PointerScrollEvent] only. Including trackpad in
/// both drag and pointer-scroll paths causes double-processing and bounce.
class PortfolioScrollBehavior extends MaterialScrollBehavior {
  const PortfolioScrollBehavior();

  @override
  Set<PointerDeviceKind> get dragDevices => <PointerDeviceKind>{
        PointerDeviceKind.touch,
        PointerDeviceKind.mouse,
        PointerDeviceKind.stylus,
        PointerDeviceKind.unknown,
      };

  @override
  ScrollPhysics getScrollPhysics(BuildContext context) =>
      const ClampingScrollPhysics();
}

/// Wraps a scrollable child and intercepts pointer-scroll signals to provide
/// smooth wheel scrolling on desktop. Trackpad events are passed through
/// to the default scroll behavior (the OS handles trackpad momentum).
///
/// This widget detects device kind from the raw [PointerSignalEvent], avoiding
/// the unreliable delta-magnitude heuristic.
class SmoothScrollWrapper extends StatefulWidget {
  const SmoothScrollWrapper({
    required this.controller,
    required this.enabled,
    required this.child,
    super.key,
  });

  final SmoothWheelScrollController controller;
  final bool enabled;
  final Widget child;

  @override
  State<SmoothScrollWrapper> createState() => _SmoothScrollWrapperState();
}

class _SmoothScrollWrapperState extends State<SmoothScrollWrapper>
    with SingleTickerProviderStateMixin {
  late final Ticker _ticker;
  double _targetOffset = 0;
  bool _chasing = false;

  static const _wheelDeltaMultiplier = 2;
  static const _lerpFactor = 0.18;
  static const _snapThreshold = 0.5;

  @override
  void initState() {
    super.initState();
    _ticker = createTicker(_onTick);
    widget.controller._wrapper = this;
  }

  @override
  void didUpdateWidget(SmoothScrollWrapper oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.controller != widget.controller) {
      oldWidget.controller._wrapper = null;
      widget.controller._wrapper = this;
    }
  }

  @override
  void dispose() {
    widget.controller._wrapper = null;
    _ticker.dispose();
    super.dispose();
  }

  void _handlePointerSignal(PointerSignalEvent event) {
    if (!widget.enabled) return;
    if (event is! PointerScrollEvent) return;
    if (event.scrollDelta.dy == 0) return;

    final isTrackpad = event.kind == PointerDeviceKind.trackpad;

    if (isTrackpad) {
      // Let the default scroll behavior handle trackpad events.
      // The OS provides its own momentum smoothing.
      return;
    }

    // Mouse wheel: intercept and handle with smooth chase animation.
    // We must stop the event from reaching the default handler.
    GestureBinding.instance.pointerSignalResolver
        .register(event, _handleMouseWheel);
  }

  void _handleMouseWheel(PointerSignalEvent event) {
    if (event is! PointerScrollEvent) return;

    final controller = widget.controller;
    if (!controller.hasClients) return;

    final position = controller.position;
    final delta = event.scrollDelta.dy;

    if (!_chasing) {
      _targetOffset = position.pixels;
    }

    final adjusted = delta * _wheelDeltaMultiplier;
    _targetOffset = clampDouble(
      _targetOffset + adjusted,
      position.minScrollExtent,
      position.maxScrollExtent,
    );

    if (!_chasing) {
      _chasing = true;
      _ticker.start();
    }
  }

  void _onTick(Duration elapsed) {
    final controller = widget.controller;
    if (!controller.hasClients || !controller.position.hasPixels) {
      _stopChasing();
      return;
    }

    final position = controller.position;
    final diff = _targetOffset - position.pixels;
    if (diff.abs() < _snapThreshold) {
      position.jumpTo(_targetOffset);
      _stopChasing();
      return;
    }

    position.jumpTo(position.pixels + diff * _lerpFactor);
  }

  void _stopChasing() {
    if (_ticker.isActive) _ticker.stop();
    _chasing = false;
  }

  void cancelChase() {
    _stopChasing();
    final controller = widget.controller;
    if (controller.hasClients && controller.position.hasPixels) {
      _targetOffset = controller.position.pixels;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Listener(
      onPointerSignal: _handlePointerSignal,
      child: widget.child,
    );
  }
}

class SmoothWheelScrollController extends ScrollController {
  _SmoothScrollWrapperState? _wrapper;

  void resetWheelTarget() {
    _wrapper?.cancelChase();
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
    TargetPlatform.linux =>
      true,
    _ => false,
  };
}
