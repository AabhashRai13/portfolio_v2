import 'dart:async';
import 'dart:math' as math;

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:my_portfolio/constants/breakpoints.dart';
import 'package:my_portfolio/core/presentation/widgets/glass_panel.dart';
import 'package:my_portfolio/features/projects/domain/models/project_summary.dart';
import 'package:my_portfolio/features/projects/presentation/controllers/project_carousel_controller.dart';
import 'package:my_portfolio/features/projects/presentation/widgets/carousel/carousel_arrow.dart';
import 'package:my_portfolio/features/projects/presentation/widgets/carousel/carousel_caption.dart';
import 'package:my_portfolio/features/projects/presentation/widgets/carousel/carousel_pills.dart';
import 'package:my_portfolio/features/projects/presentation/widgets/carousel/carousel_slide.dart';
import 'package:my_portfolio/features/projects/presentation/widgets/carousel/stage_glow.dart';
import 'package:my_portfolio/features/projects/presentation/widgets/project_poster.dart';

class ProjectCarousel extends StatefulWidget {
  const ProjectCarousel({
    required this.projects,
    required this.onOpen,
    this.maxCardHeight = double.infinity,
    super.key,
  });

  static const Key previousKey = ValueKey<String>('project-carousel-previous');
  static const Key nextKey = ValueKey<String>('project-carousel-next');
  static const Duration autoplayInterval =
      ProjectCarouselController.autoplayInterval;

  final List<FeaturedProject> projects;
  final Future<void> Function(FeaturedProject project, Rect origin) onOpen;
  final double maxCardHeight;

  @override
  State<ProjectCarousel> createState() => _ProjectCarouselState();
}

class _ProjectCarouselState extends State<ProjectCarousel> {
  static const double _arrowSize = 40;
  static const double _arrowTarget = 48;

  final FocusNode _focus = FocusNode(skipTraversal: true);
  late final _carousel = ProjectCarouselController(
    projects: widget.projects,
    onOpen: widget.onOpen,
  );

  bool get _isPhone => _carousel.layout == CarouselLayout.phone;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _carousel.sync(
      layout: MediaQuery.sizeOf(context).width < Breakpoints.tablet
          ? CarouselLayout.phone
          : CarouselLayout.desktop,
      reduceMotion: MediaQuery.disableAnimationsOf(context),
    );
  }

  @override
  void didUpdateWidget(ProjectCarousel oldWidget) {
    super.didUpdateWidget(oldWidget);
    _carousel
      ..projects = widget.projects
      ..onOpen = widget.onOpen;
  }

  @override
  void dispose() {
    _carousel.dispose();
    _focus.dispose();
    super.dispose();
  }

  void _onPointerSignal(PointerSignalEvent event) {
    if (event is! PointerScrollEvent) return;
    if (!_carousel.claimsScroll(event.scrollDelta)) return;
    GestureBinding.instance.pointerSignalResolver.register(
      event,
      (_) => _carousel.wheel(event.scrollDelta.dx),
    );
  }

  void _openFrom(BuildContext card, FeaturedProject project) {
    final box = card.findRenderObject()! as RenderBox;
    unawaited(
      _carousel.open(project, box.localToGlobal(Offset.zero) & box.size),
    );
  }

  @override
  Widget build(BuildContext context) {
    return CallbackShortcuts(
      bindings: {
        const SingleActivator(LogicalKeyboardKey.arrowLeft): _carousel.previous,
        const SingleActivator(LogicalKeyboardKey.arrowRight): _carousel.next,
      },
      child: Focus(
        focusNode: _focus,
        includeSemantics: false,
        child: Listener(
          onPointerDown: (_) {
            _focus.requestFocus();
            _carousel.pressed = true;
          },
          onPointerUp: (_) => _carousel.pressed = false,
          onPointerCancel: (_) => _carousel.pressed = false,
          child: MouseRegion(
            onEnter: (_) => _carousel.hovering = true,
            onExit: (_) => _carousel.hovering = false,
            child: AnimatedBuilder(
              animation: _carousel.pageController,
              builder: (context, _) => Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  LayoutBuilder(
                    builder: (context, constraints) =>
                        _stage(constraints.maxWidth),
                  ),
                  SizedBox(height: _isPhone ? 20 : 24),
                  CarouselCaption(
                    project: widget.projects[_carousel.selected],
                    opacity: _carousel.captionOpacity,
                    compact: _isPhone,
                  ),
                  const SizedBox(height: 12),
                  CarouselPills(
                    projects: widget.projects,
                    selected: _carousel.selected,
                    onSelect: _carousel.goToProject,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _stage(double width) {
    final layout = _carousel.layout;
    final arrowRoom = _isPhone ? 0.0 : _arrowTarget / 2;
    final pad = EdgeInsets.symmetric(
      horizontal: _isPhone ? 10 : 20,
      vertical: 32,
    );
    final pageWidth = math.min(
      (width - arrowRoom * 2 - pad.horizontal) * layout.fraction,
      widget.maxCardHeight * kPosterAspect / layout.centerScale,
    );

    return Center(
      child: SizedBox(
        width: pageWidth / layout.fraction + pad.horizontal + arrowRoom * 2,
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            const Positioned.fill(
              left: -160,
              right: -160,
              top: -120,
              bottom: -120,
              child: StageGlow(),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: arrowRoom),
              child: GlassPanel(
                radius: 36,
                // Posters slide past the glass's edges.
                clip: true,
                child: Padding(
                  padding: pad,
                  child: SizedBox(
                    height: pageWidth * layout.centerScale / kPosterAspect,
                    child: Stack(
                      children: [
                        Positioned.fill(child: _pages(pageWidth)),
                        // Above the PageView so it claims wheel events first.
                        Positioned.fill(
                          child: Listener(
                            behavior: HitTestBehavior.translucent,
                            onPointerSignal: _onPointerSignal,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            // Phones swipe; arrows there would sit on the poster.
            if (!_isPhone) ...[
              Positioned(
                left: 0,
                top: 0,
                bottom: 0,
                child: Center(
                  child: CarouselArrow(
                    key: ProjectCarousel.previousKey,
                    size: _arrowSize,
                    icon: Icons.chevron_left_rounded,
                    tooltip: 'Previous project',
                    onPressed: _carousel.previous,
                  ),
                ),
              ),
              Positioned(
                right: 0,
                top: 0,
                bottom: 0,
                child: Center(
                  child: CarouselArrow(
                    key: ProjectCarousel.nextKey,
                    size: _arrowSize,
                    icon: Icons.chevron_right_rounded,
                    tooltip: 'Next project',
                    onPressed: _carousel.next,
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _pages(double pageWidth) {
    return PageView.builder(
      // A fresh scroll position per layout: reusing the old one makes the new
      // controller change its viewport fraction mid-build.
      key: ValueKey(_carousel.layout),
      controller: _carousel.pageController,
      // The glass clips instead, past the card shadows.
      clipBehavior: Clip.none,
      itemCount: _carousel.count > 1 ? null : 1,
      itemBuilder: (context, index) {
        final project = widget.projects[index % _carousel.count];
        final isCurrent = index == _carousel.index;
        return CarouselSlide(
          project: project,
          pageWidth: pageWidth,
          scale: _carousel.scaleOf(index),
          distance: _carousel.distanceOf(index),
          label: isCurrent ? 'Open ${project.title}' : 'Show ${project.title}',
          onTap: (card) =>
              isCurrent ? _openFrom(card, project) : _carousel.goToPage(index),
        );
      },
    );
  }
}
