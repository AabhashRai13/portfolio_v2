import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:my_portfolio/app/navigation/site_navigation.dart';
import 'package:my_portfolio/core/resources/styles/home_palette.dart';
import 'package:my_portfolio/core/resources/styles/site_text.dart';

typedef LandingWidgetOpen = void Function(SiteSection section, Rect origin);

/// The four live previews used both inside the desktop phone and as the
/// full-width mobile landing surface.
class LandingWidgetGrid extends StatelessWidget {
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
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        const gap = 8.0;
        final tileWidth = (constraints.maxWidth - gap) / 2;
        final tileHeight = (constraints.maxHeight - gap) / 2;

        return GridView.builder(
          padding: EdgeInsets.zero,
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
            final scale = entrance == null
                ? const AlwaysStoppedAnimation<double>(1)
                : CurvedAnimation(
                    parent: entrance!,
                    curve: Interval(
                      0.2 + (index * 0.04),
                      0.72 + (index * 0.04),
                      curve: Curves.elasticOut,
                    ),
                  );

            return ScaleTransition(
              scale: scale,
              child: _LandingTile(
                key: keyFor(section),
                section: section,
                onTap: (origin) => onOpen(section, origin),
              ),
            );
          },
        );
      },
    );
  }
}

class _LandingTile extends StatefulWidget {
  const _LandingTile({
    required this.section,
    required this.onTap,
    super.key,
  });

  final SiteSection section;
  final ValueChanged<Rect> onTap;

  @override
  State<_LandingTile> createState() => _LandingTileState();
}

class _LandingTileState extends State<_LandingTile> {
  bool _active = false;

  void _open() {
    final box = context.findRenderObject()! as RenderBox;
    widget.onTap(box.localToGlobal(Offset.zero) & box.size);
  }

  @override
  Widget build(BuildContext context) {
    final palette = Theme.of(context).homePalette;
    final (background, foreground) = _colors(context, widget.section);

    return RepaintBoundary(
      child: Semantics(
        button: true,
        label: 'Open ${widget.section.label}',
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 160),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(18),
            border: Border.all(
              color: _active ? palette.linkActive : Colors.transparent,
              width: 3,
            ),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(15),
            child: Material(
              color: background,
              child: InkWell(
                onTap: _open,
                onHover: (value) => setState(() => _active = value),
                onFocusChange: (value) => setState(() => _active = value),
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    ExcludeSemantics(
                      child: _Preview(
                        section: widget.section,
                        foreground: foreground,
                      ),
                    ),
                    Positioned(
                      left: 12,
                      top: 10,
                      child: Text(
                        widget.section.label.toUpperCase(),
                        style: SiteText.label(foreground, size: 11),
                      ),
                    ),
                    if (_active)
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
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: widget.duration,
  );

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final motionDisabled = MediaQuery.of(context).disableAnimations;
    final tickerEnabled = TickerMode.valuesOf(context).enabled;

    if (motionDisabled) {
      _controller
        ..stop()
        ..value = 1;
    } else if (tickerEnabled && !_controller.isAnimating) {
      _controller.repeat();
    } else if (!tickerEnabled) {
      _controller.stop();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, _) => widget.builder(context, _controller),
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
      padding: const EdgeInsets.fromLTRB(14, 44, 14, 18),
      child: Align(
        alignment: Alignment.centerLeft,
        child: Container(
          padding: const EdgeInsets.all(12),
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
