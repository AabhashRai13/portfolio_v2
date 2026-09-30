import 'package:flutter/material.dart';
import 'package:my_portfolio/features/landing/presentation/controllers/landing_entrance_controller.dart';

typedef LandingEntranceBuilder =
    Widget Function(
      BuildContext context,
      Animation<double> animation, {
      required bool motionEnabled,
    });

/// Lifecycle adapter between Flutter's ticker system and the landing view.
class LandingEntrance extends StatefulWidget {
  const LandingEntrance({
    required this.builder,
    required this.routeActive,
    super.key,
  });

  final LandingEntranceBuilder builder;
  final bool routeActive;

  @override
  State<LandingEntrance> createState() => _LandingEntranceState();
}

class _LandingEntranceState extends State<LandingEntrance>
    with SingleTickerProviderStateMixin {
  late final LandingEntranceController _controller = LandingEntranceController(
    vsync: this,
  );

  bool get _reduceMotion => MediaQuery.of(context).disableAnimations;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _sync();
  }

  @override
  void didUpdateWidget(LandingEntrance oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.routeActive != widget.routeActive) _sync();
  }

  void _sync() => _controller.sync(
    routeActive: widget.routeActive,
    reduceMotion: _reduceMotion,
  );

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => widget.builder(
    context,
    _controller.animation,
    motionEnabled: !_reduceMotion && widget.routeActive,
  );
}
