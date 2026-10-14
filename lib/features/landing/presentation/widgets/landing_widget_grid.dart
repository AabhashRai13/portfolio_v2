import 'package:flutter/material.dart';
import 'package:my_portfolio/app/navigation/site_navigation.dart';
import 'package:my_portfolio/features/landing/presentation/controllers/landing_grid_view_model.dart';
import 'package:my_portfolio/features/landing/presentation/widgets/landing_tile.dart';

class LandingWidgetGrid extends StatefulWidget {
  const LandingWidgetGrid({
    required this.onOpen,
    this.entrance,
    super.key,
  });

  final ValueChanged<SiteSection> onOpen;
  final Animation<double>? entrance;

  static Key keyFor(SiteSection section) =>
      ValueKey<String>('landing-widget-${section.name}');

  @override
  State<LandingWidgetGrid> createState() => _LandingWidgetGridState();
}

/// Owns the view model's lifetime and keeps it in step with the widget.
class _LandingWidgetGridState extends State<LandingWidgetGrid> {
  late final _viewModel = LandingGridViewModel(onOpen: widget.onOpen);

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _viewModel.reduceMotion = MediaQuery.disableAnimationsOf(context);
  }

  @override
  void didUpdateWidget(LandingWidgetGrid oldWidget) {
    super.didUpdateWidget(oldWidget);
    _viewModel.onOpen = widget.onOpen;
  }

  @override
  void dispose() {
    _viewModel.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final reduceMotion = MediaQuery.disableAnimationsOf(context);
    return LayoutBuilder(
      builder: (context, constraints) {
        const gap = 8.0;
        final tileWidth = (constraints.maxWidth - gap) / 2;
        final tileHeight = (constraints.maxHeight - gap) / 2;

        return GridView.builder(
          padding: EdgeInsets.zero,
          clipBehavior: Clip.none,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: gap,
            mainAxisSpacing: gap,
            childAspectRatio: tileWidth / tileHeight,
          ),
          itemCount: SiteSection.values.length,
          itemBuilder: (context, index) {
            final section = SiteSection.values[index];
            final scale = widget.entrance == null
                ? const AlwaysStoppedAnimation<double>(1)
                : CurvedAnimation(
                    parent: widget.entrance!,
                    curve: Interval(
                      0.2 + (index * 0.04),
                      0.72 + (index * 0.04),
                      curve: Curves.elasticOut,
                    ),
                  );

            return ScaleTransition(
              scale: scale,
              child: ListenableBuilder(
                listenable: _viewModel,
                builder: (context, _) {
                  final pressed = _viewModel.isPressed(section);
                  return AnimatedScale(
                    scale: _viewModel.hoverScaleFor(section),
                    duration: reduceMotion
                        ? Duration.zero
                        : const Duration(milliseconds: 200),
                    curve: Curves.easeOutCubic,
                    // Sinks fast on press; springs back with a little
                    // overshoot on release.
                    child: AnimatedScale(
                      scale: _viewModel.pressScaleFor(section),
                      duration: reduceMotion
                          ? Duration.zero
                          : Duration(milliseconds: pressed ? 90 : 320),
                      curve: pressed ? Curves.easeOutCubic : Curves.easeOutBack,
                      child: Listener(
                        onPointerDown: (event) => _viewModel.pointerDown(
                          section,
                          position: event.position,
                          buttons: event.buttons,
                        ),
                        onPointerMove: (event) =>
                            _viewModel.pointerMove(section, event.position),
                        onPointerUp: (_) => _viewModel.pointerUp(section),
                        onPointerCancel: (_) =>
                            _viewModel.pointerCancel(section),
                        child: LandingTile(
                          key: LandingWidgetGrid.keyFor(section),
                          section: section,
                          active: _viewModel.isActive(section),
                          focused: _viewModel.isFocused(section),
                          onHover: (value) =>
                              _viewModel.setHovered(section, isHovered: value),
                          onFocusChange: (value) =>
                              _viewModel.setFocused(section, isFocused: value),
                          onTap: () => _viewModel.activate(section),
                        ),
                      ),
                    ),
                  );
                },
              ),
            );
          },
        );
      },
    );
  }
}
