import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:my_portfolio/app/navigation/site_navigation.dart';
import 'package:my_portfolio/core/resources/styles/home_palette.dart';
import 'package:my_portfolio/core/resources/styles/site_text.dart';
import 'package:my_portfolio/features/landing/presentation/controllers/landing_preview_controller.dart';
import 'package:my_portfolio/features/landing/presentation/controllers/landing_tile_interaction_controller.dart';

typedef LandingWidgetOpen = void Function(SiteSection section, Rect origin);

/// The four live previews used both inside the desktop phone and as the
/// full-width mobile landing surface.
class LandingWidgetGrid extends StatefulWidget {
  const LandingWidgetGrid({
    required this.onOpen,
    this.entrance,
    super.key,
  });

  final LandingWidgetOpen onOpen;
  final Animation<double>? entrance;

  static Key keyFor(SiteSection section) =>
      ValueKey<String>('landing-widget-${section.name}');

  @override
  State<LandingWidgetGrid> createState() => _LandingWidgetGridState();
}

/// Owns controller lifetime; tile interaction policy stays in the controller.
class _LandingWidgetGridState extends State<LandingWidgetGrid> {
  final _interaction = LandingTileInteractionController();

  @override
  void dispose() {
    _interaction.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
                listenable: _interaction,
                builder: (context, _) => AnimatedScale(
                  scale: _interaction.scaleFor(section),
                  duration: MediaQuery.disableAnimationsOf(context)
                      ? Duration.zero
                      : const Duration(milliseconds: 200),
                  curve: Curves.easeOutCubic,
                  child: _LandingTile(
                    key: LandingWidgetGrid.keyFor(section),
                    section: section,
                    active: _interaction.isActive(section),
                    focused: _interaction.isFocused(section),
                    onHover: (value) => _interaction.setHovered(
                      section,
                      isHovered: value,
                    ),
                    onFocusChange: (value) => _interaction.setFocused(
                      section,
                      isFocused: value,
                    ),
                    onTap: (origin) => widget.onOpen(section, origin),
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }
}

class _LandingTile extends StatelessWidget {
  const _LandingTile({
    required this.section,
    required this.active,
    required this.focused,
    required this.onHover,
    required this.onFocusChange,
    required this.onTap,
    super.key,
  });

  final SiteSection section;
  final bool active;
  final bool focused;
  final ValueChanged<bool> onHover;
  final ValueChanged<bool> onFocusChange;
  final ValueChanged<Rect> onTap;

  void _open(BuildContext context) {
    final box = context.findRenderObject()! as RenderBox;
    onTap(
      MatrixUtils.transformRect(
        box.getTransformTo(null),
        Offset.zero & box.size,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final (background, foreground) = _colors(context, section);

    return RepaintBoundary(
      child: Semantics(
        button: true,
        label: 'Open ${section.label}',
        child: AnimatedContainer(
          duration: MediaQuery.disableAnimationsOf(context)
              ? Duration.zero
              : const Duration(milliseconds: 160),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(18),
            border: Border.all(
              color: focused
                  ? foreground.withValues(alpha: 0.85)
                  : Colors.transparent,
              width: 3,
            ),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(15),
            child: Material(
              color: background,
              child: InkWell(
                onTap: () => _open(context),
                onHover: onHover,
                onFocusChange: onFocusChange,
                hoverColor: Colors.transparent,
                focusColor: Colors.transparent,
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    ExcludeSemantics(
                      child: _Preview(
                        section: section,
                        foreground: foreground,
                      ),
                    ),
                    Positioned(
                      left: 12,
                      top: 10,
                      child: Text(
                        section.label.toUpperCase(),
                        style: SiteText.label(foreground, size: 11),
                      ),
                    ),
                    if (active)
                      Positioned(
                        right: 10,
                        bottom: 8,
                        child: Text(
                          'OPEN →',
                          style: SiteText.label(foreground, size: 10),
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  (Color, Color) _colors(BuildContext context, SiteSection section) {
    final palette = Theme.of(context).homePalette;
    return switch (section) {
      SiteSection.work => (palette.secondaryAccent, palette.textStrong),
      SiteSection.about => (palette.textStrong, palette.mediaForeground),
      SiteSection.writing => (palette.textStrong, palette.sectionBackground),
      SiteSection.contact => (
        palette.primaryAccent,
        Theme.of(context).brightness == Brightness.dark
            ? palette.sectionBackground
            : palette.textStrong,
      ),
    };
  }
}

class _Preview extends StatelessWidget {
  const _Preview({required this.section, required this.foreground});

  final SiteSection section;
  final Color foreground;

  @override
  Widget build(BuildContext context) {
    return switch (section) {
      SiteSection.work => _LoopingPreview(
        duration: const Duration(seconds: 5),
        builder: (context, animation) => CustomPaint(
          painter: _WorkPreviewPainter(
            progress: animation.value,
            color: foreground,
          ),
        ),
      ),
      SiteSection.about => _LoopingPreview(
        duration: const Duration(seconds: 6),
        builder: (context, animation) {
          final zoom =
              1 +
              (0.05 * (0.5 - (0.5 * math.cos(animation.value * math.pi * 2))));
          return Stack(
            fit: StackFit.expand,
            children: [
              Transform.scale(
                scale: zoom,
                child: Image.asset(
                  'assets/images/intro_video_thumb.jpg',
                  fit: BoxFit.cover,
                ),
              ),
              ColoredBox(
                color: Theme.of(
                  context,
                ).homePalette.shadowColor.withValues(alpha: 0.22),
              ),
              Center(
                child: Icon(
                  Icons.play_circle_fill_rounded,
                  size: 46,
                  color: foreground,
                ),
              ),
            ],
          );
        },
      ),
      SiteSection.writing => _LoopingPreview(
        duration: const Duration(seconds: 4),
        builder: (context, animation) => _WritingPreview(
          progress: animation.value,
          color: foreground,
        ),
      ),
      SiteSection.contact => _LoopingPreview(
        duration: const Duration(seconds: 4),
        builder: (context, animation) => _ContactPreview(
          progress: animation.value,
          color: foreground,
        ),
      ),
    };
  }
}

class _LoopingPreview extends StatefulWidget {
  const _LoopingPreview({required this.duration, required this.builder});

  final Duration duration;
  final Widget Function(BuildContext, Animation<double>) builder;

  @override
  State<_LoopingPreview> createState() => _LoopingPreviewState();
}

class _LoopingPreviewState extends State<_LoopingPreview>
    with SingleTickerProviderStateMixin {
  late final LandingPreviewController _motion;

  @override
  void initState() {
    super.initState();
    _motion = LandingPreviewController(
      vsync: this,
      duration: widget.duration,
    );
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final motionDisabled = MediaQuery.of(context).disableAnimations;
    final tickerEnabled = TickerMode.valuesOf(context).enabled;

    _motion.sync(
      tickerEnabled: tickerEnabled,
      reduceMotion: motionDisabled,
    );
  }

  @override
  void didUpdateWidget(_LoopingPreview oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.duration != widget.duration) {
      _motion.duration = widget.duration;
    }
  }

  @override
  void dispose() {
    _motion.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _motion.animation,
      builder: (context, _) => widget.builder(context, _motion.animation),
    );
  }
}

class _WorkPreviewPainter extends CustomPainter {
  const _WorkPreviewPainter({required this.progress, required this.color});

  final double progress;
  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = color;
    final outline = Paint()
      ..color = color.withValues(alpha: 0.48)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;
    final reveal = Curves.easeInOutCubic.transform(
      (progress / 0.72).clamp(0.0, 1.0),
    );

    final screen = RRect.fromRectAndRadius(
      Rect.fromLTWH(
        size.width * 0.2,
        size.height * 0.25,
        size.width * 0.6,
        size.height * 0.58,
      ),
      const Radius.circular(9),
    );
    canvas.drawRRect(screen, outline);

    final blocks = <Rect>[
      Rect.fromLTWH(
        size.width * 0.27,
        size.height * 0.34,
        size.width * 0.46,
        size.height * 0.11,
      ),
      Rect.fromLTWH(
        size.width * 0.27,
        size.height * 0.5,
        size.width * 0.2,
        size.height * 0.2,
      ),
      Rect.fromLTWH(
        size.width * 0.52,
        size.height * 0.5,
        size.width * 0.21,
        size.height * 0.2,
      ),
    ];

    for (var i = 0; i < blocks.length; i++) {
      final amount = ((reveal * blocks.length) - i).clamp(0.0, 1.0);
      final rect = blocks[i];
      canvas.drawRRect(
        RRect.fromRectAndRadius(
          Rect.fromLTWH(rect.left, rect.top, rect.width * amount, rect.height),
          const Radius.circular(5),
        ),
        paint..color = color.withValues(alpha: 0.28 + (amount * 0.54)),
      );
    }
  }

  @override
  bool shouldRepaint(_WorkPreviewPainter oldDelegate) =>
      progress != oldDelegate.progress || color != oldDelegate.color;
}

class _WritingPreview extends StatelessWidget {
  const _WritingPreview({required this.progress, required this.color});

  final double progress;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 42, 16, 18),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          for (var i = 0; i < 4; i++) ...[
            FractionallySizedBox(
              widthFactor:
                  (((progress * 1.45) - (i * 0.14)).clamp(0.0, 1.0)) *
                  (i == 3 ? 0.58 : 1),
              child: Container(
                height: i == 0 ? 9 : 5,
                decoration: BoxDecoration(
                  color: color.withValues(alpha: i == 0 ? 0.95 : 0.62),
                  borderRadius: BorderRadius.circular(5),
                ),
              ),
            ),
            const SizedBox(height: 8),
          ],
        ],
      ),
    );
  }
}

class _ContactPreview extends StatelessWidget {
  const _ContactPreview({required this.progress, required this.color});

  static const message = "Hi Aabhash, we're building…";

  final double progress;
  final Color color;

  @override
  Widget build(BuildContext context) {
    final visible = ((progress / 0.72) * message.length).floor().clamp(
      0,
      message.length,
    );
    final dotCount = progress < 0.72 ? 0 : 1 + ((progress * 12).floor() % 3);

    return Padding(
      padding: const EdgeInsets.fromLTRB(10, 44, 10, 18),
      child: Align(
        alignment: Alignment.centerLeft,
        child: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.12),
            border: Border.all(color: color.withValues(alpha: 0.42)),
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(14),
              topRight: Radius.circular(14),
              bottomRight: Radius.circular(14),
              bottomLeft: Radius.circular(3),
            ),
          ),
          child: Text(
            visible < message.length
                ? message.substring(0, visible)
                : '$message${'.' * dotCount}',
            style: SiteText.body(color, size: 11).copyWith(height: 1.3),
          ),
        ),
      ),
    );
  }
}
