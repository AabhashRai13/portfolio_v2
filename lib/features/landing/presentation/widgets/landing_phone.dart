import 'dart:async';
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/physics.dart';
import 'package:my_portfolio/core/resources/styles/home_palette.dart';

/// Desktop frame for the live widget grid. It floats at rest, neutralises its
/// tilt on hover, follows pointer drags, then springs home on release.
class LandingPhone extends StatefulWidget {
  const LandingPhone({
    required this.child,
    required this.motionEnabled,
    super.key,
  });

  final Widget child;
  final bool motionEnabled;

  static const Key motionKey = ValueKey<String>('landing-phone-motion');

  @override
  State<LandingPhone> createState() => _LandingPhoneState();
}

class _LandingPhoneState extends State<LandingPhone>
    with TickerProviderStateMixin {
  static const _restingRotation = -0.045;
  static const double _maxRotation = 8 * math.pi / 180;
  static const _spring = SpringDescription(
    mass: 1,
    stiffness: 170,
    damping: 17,
  );

  late final AnimationController _floatController = AnimationController(
    vsync: this,
    duration: const Duration(seconds: 6),
  )..addListener(_rebuild);
  late final AnimationController _xController = AnimationController.unbounded(
    vsync: this,
  )..addListener(_rebuild);
  late final AnimationController _yController = AnimationController.unbounded(
    vsync: this,
  )..addListener(_rebuild);

  bool _hovered = false;
  bool _dragging = false;
  double _dragRotation = 0;

  bool get _motionEnabled =>
      widget.motionEnabled &&
      !MediaQuery.of(context).disableAnimations &&
      TickerMode.valuesOf(context).enabled;

  void _rebuild() {
    if (mounted) setState(() {});
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _syncFloat();
  }

  @override
  void didUpdateWidget(LandingPhone oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.motionEnabled != widget.motionEnabled) _syncFloat();
  }

  void _syncFloat() {
    if (_motionEnabled) {
      if (!_floatController.isAnimating) _floatController.repeat();
    } else {
      _floatController.stop();
    }
  }

  void _onPanStart(DragStartDetails details) {
    if (!_motionEnabled) return;
    _xController.stop();
    _yController.stop();
    setState(() => _dragging = true);
  }

  void _onPanUpdate(DragUpdateDetails details) {
    if (!_motionEnabled) return;
    _xController.value += details.delta.dx;
    _yController.value += details.delta.dy;
    setState(() {
      _dragRotation = (details.delta.dx * math.pi / 60).clamp(
        -_maxRotation,
        _maxRotation,
      );
    });
  }

  void _onPanEnd(DragEndDetails details) {
    if (!_motionEnabled) return;
    setState(() {
      _dragging = false;
      _dragRotation = 0;
    });
    unawaited(
      _xController.animateWith(
        SpringSimulation(
          _spring,
          _xController.value,
          0,
          details.velocity.pixelsPerSecond.dx,
        ),
      ),
    );
    unawaited(
      _yController.animateWith(
        SpringSimulation(
          _spring,
          _yController.value,
          0,
          details.velocity.pixelsPerSecond.dy,
        ),
      ),
    );
  }

  @override
  void dispose() {
    _floatController.dispose();
    _xController.dispose();
    _yController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final palette = Theme.of(context).homePalette;
    final floatOffset = _motionEnabled
        ? math.sin(_floatController.value * math.pi * 2) * 4
        : 0.0;
    final rotation = _dragging
        ? _dragRotation
        : (_motionEnabled && _hovered ? 0.0 : _restingRotation);
    final offset = Offset(
      _motionEnabled ? _xController.value : 0,
      (_motionEnabled ? _yController.value : 0) +
          floatOffset -
          (_hovered && _motionEnabled ? 7 : 0),
    );

    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: GestureDetector(
        behavior: HitTestBehavior.translucent,
        onPanStart: _onPanStart,
        onPanUpdate: _onPanUpdate,
        onPanEnd: _onPanEnd,
        child: TweenAnimationBuilder<double>(
          tween: Tween<double>(end: rotation),
          duration: Duration(milliseconds: _dragging ? 70 : 420),
          curve: Curves.easeOutCubic,
          builder: (context, angle, child) => Transform.translate(
            key: LandingPhone.motionKey,
            offset: offset,
            child: Transform.rotate(
              angle: angle,
              child: AnimatedScale(
                scale: _hovered && _motionEnabled ? 1.02 : 1,
                duration: const Duration(milliseconds: 240),
                curve: Curves.easeOutCubic,
                child: child,
              ),
            ),
          ),
          child: Container(
            width: 292,
            height: 420,
            padding: const EdgeInsets.fromLTRB(11, 28, 11, 12),
            decoration: BoxDecoration(
              color: palette.textStrong,
              borderRadius: BorderRadius.circular(44),
              boxShadow: [
                BoxShadow(
                  color: palette.shadowColor.withValues(alpha: 0.22),
                  blurRadius: 30,
                  offset: const Offset(0, 18),
                ),
              ],
            ),
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                Positioned.fill(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(32),
                    child: ColoredBox(
                      color: palette.sectionBackground,
                      child: Padding(
                        padding: const EdgeInsets.all(8),
                        child: widget.child,
                      ),
                    ),
                  ),
                ),
                Positioned(
                  top: -17,
                  left: 88,
                  right: 88,
                  child: Container(
                    height: 7,
                    decoration: BoxDecoration(
                      color: palette.sectionBackground,
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
