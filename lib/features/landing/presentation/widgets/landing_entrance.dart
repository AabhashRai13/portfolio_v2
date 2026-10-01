import 'package:flutter/material.dart';
import 'package:my_portfolio/constants/size.dart';
import 'package:my_portfolio/features/landing/presentation/controllers/landing_entrance_controller.dart';
import 'package:my_portfolio/features/landing/presentation/controllers/landing_phone_motion_controller.dart';

typedef LandingEntranceBuilder =
    Widget Function(
      BuildContext context,
      Animation<double> animation, {
      required LandingPhoneMotionController phoneMotion,
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
    with TickerProviderStateMixin {
  late final LandingEntranceController _controller = LandingEntranceController(
    vsync: this,
  );
  late final LandingPhoneMotionController _phoneMotion =
      LandingPhoneMotionController(vsync: this);

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

  void _sync() {
    _controller.sync(
      routeActive: widget.routeActive,
      reduceMotion: _reduceMotion,
    );
    _phoneMotion
      ..setEnabled(
        isEnabled:
            widget.routeActive &&
            !_reduceMotion &&
            MediaQuery.sizeOf(context).width >= kSiteDesktopBreakpoint,
      )
      ..start();
  }

  @override
  void dispose() {
    _controller.dispose();
    _phoneMotion.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => widget.builder(
    context,
    _controller.animation,
    phoneMotion: _phoneMotion,
  );
}
