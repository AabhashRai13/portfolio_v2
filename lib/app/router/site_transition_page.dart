import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

@immutable
class SiteTransitionOrigin {
  const SiteTransitionOrigin(this.rect);

  final Rect rect;
}

/// A route page that grows from a tapped landing widget when an origin is
/// available, and otherwise uses the site's subtle fade-and-rise fallback.
class SiteTransitionPage extends CustomTransitionPage<void> {
  SiteTransitionPage({
    required LocalKey key,
    required super.child,
    SiteTransitionOrigin? origin,
  }) : super(
         key: key,
         transitionDuration: const Duration(milliseconds: 450),
         reverseTransitionDuration: const Duration(milliseconds: 450),
         transitionsBuilder: (context, animation, _, child) =>
             SiteRouteTransition(
               animation: animation,
               origin: origin,
               child: child,
             ),
       );
}

class SiteRouteTransition extends StatelessWidget {
  const SiteRouteTransition({
    required this.animation,
    required this.child,
    this.origin,
    super.key,
  });

  static const Key expandKey = ValueKey<String>('site-route-expand');
  static const Key fallbackKey = ValueKey<String>('site-route-fallback');

  final Animation<double> animation;
  final SiteTransitionOrigin? origin;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    if (MediaQuery.of(context).disableAnimations) return child;

    final curved = CurvedAnimation(
      parent: animation,
      curve: Curves.easeInOutCubicEmphasized,
      reverseCurve: Curves.easeInOutCubicEmphasized.flipped,
    );
    final transitionOrigin = origin;
    if (transitionOrigin == null) {
      return AnimatedBuilder(
        key: fallbackKey,
        animation: curved,
        child: child,
        builder: (context, child) => Opacity(
          opacity: curved.value,
          child: Transform.translate(
            offset: Offset(0, 12 * (1 - curved.value)),
            child: child,
          ),
        ),
      );
    }

    final viewport = MediaQuery.sizeOf(context);
    final target = Offset.zero & viewport;
    return AnimatedBuilder(
      key: expandKey,
      animation: curved,
      child: child,
      builder: (context, child) {
        final value = curved.value;
        final rect = Rect.lerp(transitionOrigin.rect, target, value)!;
        final pageOpacity = ((value - 0.08) / 0.42).clamp(0.0, 1.0);

        return Stack(
          fit: StackFit.expand,
          children: [
            Positioned.fromRect(
              rect: rect,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(18 * (1 - value)),
                child: Opacity(
                  opacity: pageOpacity,
                  child: FittedBox(
                    fit: BoxFit.fill,
                    alignment: Alignment.topLeft,
                    child: SizedBox.fromSize(size: viewport, child: child),
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
