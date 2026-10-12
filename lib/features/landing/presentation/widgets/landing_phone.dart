import 'package:flutter/material.dart';
import 'package:my_portfolio/core/resources/styles/home_palette.dart';
import 'package:my_portfolio/features/landing/presentation/controllers/landing_phone_motion_controller.dart';

/// Desktop hardware and live screen, rendered from shared motion state.
class LandingPhone extends StatelessWidget {
  const LandingPhone({
    required this.child,
    required this.motion,
    this.interactive = true,
    super.key,
  });

  final Widget child;
  final LandingPhoneMotionController motion;

  /// False while the screen is in use (e.g. the contact form): the phone
  /// drops its drag recognizer so it cannot steal scrolling or text selection.
  final bool interactive;

  static const Key motionKey = ValueKey<String>('landing-phone-motion');

  // Measured outside the motion transform, so only the fit-to-screen scale
  // counts and a drag keeps the phone under the pointer.
  static double _screenScale(BuildContext context) {
    final box = context.findRenderObject()! as RenderBox;
    final unit =
        box.localToGlobal(const Offset(100, 0)) -
        box.localToGlobal(Offset.zero);
    return unit.distance / 100;
  }

  @override
  Widget build(BuildContext context) {
    final palette = Theme.of(context).homePalette;
    final rimDark = Color.lerp(
      palette.shadowColor,
      palette.primaryAccent,
      0.4,
    )!;
    final rimMid = Color.lerp(
      palette.shadowColor,
      palette.primaryAccent,
      0.58,
    )!;
    final rimLight = Color.lerp(
      palette.primaryAccent,
      palette.mediaForeground,
      0.16,
    )!;

    return ListenableBuilder(
      listenable: motion,
      builder: (context, frame) => Transform(
        key: motionKey,
        alignment: Alignment.center,
        transform: motion.transform,
        child: frame,
      ),
      child: MouseRegion(
        onEnter: (_) => motion.setHovered(isHovered: true),
        onHover: (_) => motion.setHovered(isHovered: true),
        onExit: (_) => motion.setHovered(isHovered: false),
        child: GestureDetector(
          behavior: HitTestBehavior.translucent,
          onPanStart: interactive
              ? (details) => motion.onPanStart(
                  details,
                  screenScale: _screenScale(context),
                )
              : null,
          onPanUpdate: interactive ? motion.onPanUpdate : null,
          onPanEnd: interactive ? motion.onPanEnd : null,
          child: SizedBox(
            width: 300,
            height: 550,
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                // A narrow rear lip gives the left side depth without changing
                // the rounded front face or separating the side buttons.
                Positioned(
                  left: -2.5,
                  right: 0,
                  top: 1,
                  bottom: -0.5,
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(40),
                      gradient: LinearGradient(
                        colors: [rimDark, palette.shadowColor, rimDark],
                        stops: const [0, 0.08, 1],
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: palette.shadowColor.withValues(alpha: 0.35),
                          blurRadius: 32,
                          offset: const Offset(5, 20),
                        ),
                      ],
                    ),
                  ),
                ),
                Positioned.fill(
                  child: Container(
                    padding: const EdgeInsets.all(1.5),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          rimMid,
                          rimLight,
                          rimDark,
                          rimMid,
                        ],
                        stops: const [0, 0.12, 0.65, 1],
                      ),
                      borderRadius: BorderRadius.circular(40),
                    ),
                    child: Container(
                      padding: const EdgeInsets.fromLTRB(9, 34, 9, 14),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [
                            Color.lerp(
                              palette.shadowColor,
                              palette.mediaForeground,
                              0.075,
                            )!,
                            Color.lerp(
                              palette.shadowColor,
                              palette.mediaForeground,
                              0.035,
                            )!,
                          ],
                        ),
                        borderRadius: BorderRadius.circular(38.5),
                      ),
                      child: Stack(
                        clipBehavior: Clip.none,
                        children: [
                          Positioned.fill(
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(24),
                              child: Padding(
                                padding: const EdgeInsets.all(6),
                                child: child,
                              ),
                            ),
                          ),
                          Positioned(
                            top: -21,
                            left: 116,
                            right: 116,
                            child: Container(
                              height: 5,
                              decoration: BoxDecoration(
                                color: palette.primaryAccent.withValues(
                                  alpha: 0.45,
                                ),
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                          ),
                          Positioned(
                            top: -21,
                            right: 94,
                            child: Container(
                              width: 5,
                              height: 5,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: palette.textSecondary.withValues(
                                  alpha: 0.35,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                Positioned(
                  left: -3.5,
                  top: 90,
                  child: Column(
                    children: [
                      _sideButton(palette, 20),
                      const SizedBox(height: 9),
                      _sideButton(palette, 36),
                      const SizedBox(height: 7),
                      _sideButton(palette, 36),
                    ],
                  ),
                ),
                Positioned(
                  right: -2,
                  top: 130,
                  child: _sideButton(palette, 43),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _sideButton(HomePalette palette, double height) => Container(
    width: 3,
    height: height,
    decoration: BoxDecoration(
      gradient: LinearGradient(
        colors: [
          Color.lerp(palette.primaryAccent, palette.mediaForeground, 0.2)!,
          Color.lerp(palette.shadowColor, palette.primaryAccent, 0.4)!,
        ],
      ),
      borderRadius: BorderRadius.circular(2),
      border: Border.all(
        color: palette.shadowColor.withValues(alpha: 0.55),
        width: 0.5,
      ),
    ),
  );
}
