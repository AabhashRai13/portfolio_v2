import 'package:flutter/material.dart';
import 'package:my_portfolio/core/resources/styles/home_palette.dart';
import 'package:my_portfolio/features/landing/presentation/controllers/landing_phone_motion_controller.dart';

/// Desktop frame for the live widget grid.
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

/// The state object is only a ticker lifecycle adapter. Motion state and policy
/// belong to [LandingPhoneMotionController].
class _LandingPhoneState extends State<LandingPhone>
    with TickerProviderStateMixin {
  late final LandingPhoneMotionController _motion =
      LandingPhoneMotionController(vsync: this);

  bool get _motionEnabled =>
      widget.motionEnabled &&
      !MediaQuery.of(context).disableAnimations &&
      TickerMode.valuesOf(context).enabled;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _syncMotion();
  }

  @override
  void didUpdateWidget(LandingPhone oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.motionEnabled != widget.motionEnabled) _syncMotion();
  }

  void _syncMotion() {
    _motion
      ..setEnabled(isEnabled: _motionEnabled)
      ..start();
  }

  @override
  void dispose() {
    _motion.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: _motion,
      child: widget.child,
      builder: (context, child) => _LandingPhoneView(
        motion: _motion,
        child: child!,
      ),
    );
  }
}

/// Stateless phone renderer. All values and event decisions come from the
/// presentation controller.
class _LandingPhoneView extends StatelessWidget {
  const _LandingPhoneView({required this.motion, required this.child});

  final LandingPhoneMotionController motion;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final palette = Theme.of(context).homePalette;

    return MouseRegion(
      onEnter: (_) => motion.setHovered(isHovered: true),
      onExit: (_) => motion.setHovered(isHovered: false),
      child: GestureDetector(
        behavior: HitTestBehavior.translucent,
        onPanStart: motion.onPanStart,
        onPanUpdate: motion.onPanUpdate,
        onPanEnd: motion.onPanEnd,
        child: TweenAnimationBuilder<double>(
          tween: Tween<double>(end: motion.rotation),
          duration: Duration(milliseconds: motion.dragging ? 70 : 420),
          curve: Curves.easeOutCubic,
          builder: (context, angle, framedChild) => Transform.translate(
            key: LandingPhone.motionKey,
            offset: motion.offset,
            child: Transform.rotate(
              angle: angle,
              child: AnimatedScale(
                scale: motion.hovered && motion.enabled ? 1.02 : 1,
                duration: const Duration(milliseconds: 240),
                curve: Curves.easeOutCubic,
                child: framedChild,
              ),
            ),
          ),
          child: Container(
            width: 248,
            height: 420,
            padding: const EdgeInsets.fromLTRB(11, 28, 11, 12),
            decoration: BoxDecoration(
              color: palette.shadowColor,
              borderRadius: BorderRadius.circular(38),
              border: Border.all(
                color: palette.primaryAccent.withValues(alpha: 0.7),
                width: 1.5,
              ),
              boxShadow: [
                BoxShadow(
                  color: palette.shadowColor.withValues(alpha: 0.52),
                  blurRadius: 46,
                  offset: const Offset(0, 24),
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
                      color: palette.shadowColor,
                      child: Padding(
                        padding: const EdgeInsets.all(6),
                        child: child,
                      ),
                    ),
                  ),
                ),
                Positioned(
                  top: -17,
                  left: 72,
                  right: 72,
                  child: Container(
                    height: 5,
                    decoration: BoxDecoration(
                      color: palette.primaryAccent.withValues(alpha: 0.45),
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
