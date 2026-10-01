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
      return FadeTransition(
        key: fallbackKey,
        opacity: curved,
        child: SlideTransition(
          position: Tween<Offset>(
            begin: const Offset(0, 0.015),
            end: Offset.zero,
          ).animate(curved),
          child: RepaintBoundary(child: child),
        ),
      );
    }

    // Keep the destination at its final size and animate only a clip layer.
    // Scaling the full page each frame is particularly expensive on web.
    return ClipPath(
      key: expandKey,
      clipper: _ExpandingRouteClipper(
        origin: transitionOrigin.rect,
        progress: curved,
      ),
      child: RepaintBoundary(child: child),
    );
  }
}

class _ExpandingRouteClipper extends CustomClipper<Path> {
  _ExpandingRouteClipper({required this.origin, required this.progress})
    : super(reclip: progress);

  final Rect origin;
  final Animation<double> progress;

  @override
  Path getClip(Size size) {
    final value = progress.value;
    final rect = Rect.lerp(origin, Offset.zero & size, value)!;
    return Path()..addRRect(
      RRect.fromRectAndRadius(
        rect,
        Radius.circular(18 * (1 - value)),
      ),
    );
  }

  @override
  bool shouldReclip(_ExpandingRouteClipper oldClipper) =>
      oldClipper.origin != origin || oldClipper.progress != progress;
}
