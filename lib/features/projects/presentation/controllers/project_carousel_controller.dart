import 'dart:async';
import 'dart:ui' show lerpDouble;

import 'package:flutter/widgets.dart';
import 'package:my_portfolio/features/projects/domain/models/project_summary.dart';

// Desktop fits all three cards edge to edge; on phones the neighbours peek.
enum CarouselLayout {
  desktop(fraction: 0.356, centerScale: 1.075, sideScale: 0.806),
  phone(fraction: 0.74, centerScale: 1, sideScale: 0.85);

  const CarouselLayout({
    required this.fraction,
    required this.centerScale,
    required this.sideScale,
  });

  final double fraction;
  final double centerScale;
  final double sideScale;
}

class ProjectCarouselController {
  ProjectCarouselController({required this.projects, required this.onOpen});

  static const Duration autoplayInterval = Duration(seconds: 5);

  // A trackpad swipe arrives as many small wheel deltas plus a momentum
  // tail: step once per 40 px, then wait for 200 ms of quiet.
  static const double _wheelStep = 40;
  static const Duration _wheelQuiet = Duration(milliseconds: 200);

  List<FeaturedProject> projects;

  // Autoplay holds while the pointer is over the carousel or pressed on it.
  bool hovering = false;
  bool pressed = false;
  Future<void> Function(FeaturedProject project, Rect origin) onOpen;

  PageController? _controller;
  CarouselLayout _layout = CarouselLayout.desktop;
  bool _reduceMotion = false;
  bool _opening = false;
  bool _disposed = false;
  Timer? _autoplay;
  Timer? _wheelIdle;
  double _wheelDx = 0;
  bool _wheelLocked = false;

  PageController get pageController => _controller!;
  CarouselLayout get layout => _layout;
  int get count => projects.length;

  double get page {
    final controller = _controller;
    return controller != null &&
            controller.hasClients &&
            controller.position.hasContentDimensions
        ? controller.page ?? 0
        : controller?.initialPage.toDouble() ?? 0;
  }

  // Raw page: the PageView is endless, so pages repeat the projects.
  int get index => page.round();
  int get selected => index % count;

  double distanceOf(int rawPage) => (rawPage - page).abs().clamp(0.0, 1.0);

  double scaleOf(int rawPage) =>
      lerpDouble(_layout.centerScale, _layout.sideScale, distanceOf(rawPage))!;

  // Fades out as a card leaves the middle and back in as the next arrives.
  double get captionOpacity =>
      (1 - (page - page.round()).abs() * 2).clamp(0.0, 1.0);

  // viewportFraction is fixed per PageController, so a layout change swaps
  // the controller and keeps the current page.
  void sync({required CarouselLayout layout, required bool reduceMotion}) {
    _reduceMotion = reduceMotion;
    if (_controller == null || layout != _layout) {
      final old = _controller;
      _controller = PageController(
        viewportFraction: layout.fraction,
        // Deep in the endless list, so there is room to go back.
        initialPage: old == null ? count * 1000 : index,
      );
      _layout = layout;
      if (old != null) {
        WidgetsBinding.instance.addPostFrameCallback((_) => old.dispose());
      }
    }
    _restartAutoplay();
  }

  void next() => goToPage(index + 1);
  void previous() => goToPage(index - 1);
  void goToProject(int project) => goToPage(nearestPageFor(project));

  // Resets the autoplay clock so it never jumps right after a tap.
  void goToPage(int rawPage) {
    _animateTo(rawPage);
    _restartAutoplay();
  }

  int nearestPageFor(int project) {
    var delta = project - selected;
    if (delta > count / 2) delta -= count;
    if (delta < -count / 2) delta += count;
    return index + delta;
  }

  bool claimsScroll(Offset delta) => delta.dx.abs() > delta.dy.abs();

  // Returns the step taken: -1, 0 or 1.
  int wheel(double dx) {
    _wheelIdle?.cancel();
    _wheelIdle = Timer(_wheelQuiet, () {
      _wheelDx = 0;
      _wheelLocked = false;
    });
    if (_wheelLocked) return 0;
    _wheelDx += dx;
    if (_wheelDx.abs() < _wheelStep) return 0;
    _wheelLocked = true;
    final step = _wheelDx.sign.toInt();
    goToPage(index + step);
    return step;
  }

  // Autoplay holds while the project view is open.
  Future<void> open(FeaturedProject project, Rect origin) async {
    _opening = true;
    await onOpen(project, origin);
    _opening = false;
    _restartAutoplay();
  }

  void _restartAutoplay() {
    _autoplay?.cancel();
    if (_disposed || _reduceMotion || count < 2) return;
    _autoplay = Timer.periodic(autoplayInterval, (_) {
      if (hovering || pressed || _opening) return;
      _animateTo(index + 1);
    });
  }

  void _animateTo(int rawPage) {
    // Unattached while the page sits unbuilt under another route (a direct
    // visit to /work/all); autoplay still fires there.
    final controller = _controller;
    if (controller == null || !controller.hasClients) return;
    unawaited(
      controller.animateToPage(
        rawPage,
        duration: const Duration(milliseconds: 600),
        curve: Curves.easeInOutCubic,
      ),
    );
  }

  void dispose() {
    _disposed = true;
    _autoplay?.cancel();
    _wheelIdle?.cancel();
    _controller?.dispose();
  }
}
