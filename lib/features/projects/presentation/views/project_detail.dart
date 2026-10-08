import 'dart:math' as math;
import 'dart:ui' show lerpDouble;

import 'package:flutter/material.dart';
import 'package:my_portfolio/app/navigation/site_text_link.dart';
import 'package:my_portfolio/constants/size.dart';
import 'package:my_portfolio/core/presentation/widgets/press_scale.dart';
import 'package:my_portfolio/core/resources/styles/home_palette.dart';
import 'package:my_portfolio/core/resources/styles/site_text.dart';
import 'package:my_portfolio/core/services/tap_feedback.dart';
import 'package:my_portfolio/features/projects/domain/models/project_summary.dart';
import 'package:my_portfolio/features/projects/presentation/widgets/project_poster.dart';

/// Opens [project] over the page. The poster grows out of [origin] (the
/// tapped card's global rect) into a panel, the details fade in after it,
/// and closing plays the same thing backwards. Esc, a tap outside or the
/// close button dismisses it. Completes when it closes.
Future<void> showProjectDetail(
  BuildContext context, {
  required FeaturedProject project,
  required Rect origin,
  required ValueChanged<String> onOpenStore,
}) {
  return showGeneralDialog<void>(
    context: context,
    barrierDismissible: true,
    barrierLabel: 'Close ${project.title}',
    barrierColor: Colors.black54,
    transitionDuration: MediaQuery.disableAnimationsOf(context)
        ? Duration.zero
        : const Duration(milliseconds: 450),
    // The page animates its own parts; skip the default whole-page fade.
    transitionBuilder: (context, animation, _, child) => child,
    pageBuilder: (context, animation, _) => _ProjectDetail(
      project: project,
      origin: origin,
      animation: animation,
      onOpenStore: onOpenStore,
    ),
  );
}

class _ProjectDetail extends StatelessWidget {
  const _ProjectDetail({
    required this.project,
    required this.origin,
    required this.animation,
    required this.onOpenStore,
  });

  final FeaturedProject project;
  final Rect origin;
  final Animation<double> animation;
  final ValueChanged<String> onOpenStore;

  @override
  Widget build(BuildContext context) {
    final palette = Theme.of(context).homePalette;
    final size = MediaQuery.sizeOf(context);
    final isNarrow = size.width < kWorkPhoneBreakpoint;
    final (:panel, :poster, :details) = _finalLayout(
      size,
      MediaQuery.paddingOf(context),
      isNarrow: isNarrow,
    );

    final move = CurvedAnimation(
      parent: animation,
      curve: Curves.easeInOutCubic,
    );
    final reveal = CurvedAnimation(
      parent: animation,
      curve: const Interval(0.55, 1, curve: Curves.easeOut),
    );

    // Transparent material: the links and buttons need one for their ink.
    return Material(
      type: MaterialType.transparency,
      child: AnimatedBuilder(
        animation: animation,
        builder: (context, _) {
          final t = move.value;
          return Stack(
            children: [
              // The card's surface grows with the poster, then turns solid.
              Positioned.fromRect(
                rect: Rect.lerp(origin, panel, t)!,
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    color: palette.sectionBackground.withValues(
                      alpha: (t * 2).clamp(0.0, 1.0),
                    ),
                    borderRadius: BorderRadius.circular(
                      lerpDouble(20, isNarrow ? 0 : 24, t)!,
                    ),
                  ),
                ),
              ),
              Positioned.fromRect(
                rect: Rect.lerp(origin, poster, t)!,
                child: ProjectPoster(project: project),
              ),
              Positioned.fromRect(
                rect: details,
                child: Opacity(
                  opacity: reveal.value,
                  child: Transform.translate(
                    offset: Offset(0, 16 * (1 - reveal.value)),
                    child: SingleChildScrollView(
                      child: _Details(
                        project: project,
                        isNarrow: isNarrow,
                        onOpenStore: onOpenStore,
                      ),
                    ),
                  ),
                ),
              ),
              Positioned(
                // Over the poster on phones, the panel's corner elsewhere.
                top: (isNarrow ? poster.top : panel.top) + 10,
                right:
                    size.width - (isNarrow ? poster.right : panel.right) + 10,
                child: Opacity(
                  opacity: reveal.value,
                  child: PressScale(
                    child: IconButton(
                      tooltip: 'Close',
                      onPressed: () {
                        tapFeedback();
                        Navigator.of(context).pop();
                      },
                      icon: const Icon(Icons.close_rounded),
                      style: IconButton.styleFrom(
                        foregroundColor: palette.textStrong,
                        backgroundColor: palette.surfaceCard.withValues(
                          alpha: 0.8,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

/// Where the panel, poster and details end up. Phones: full screen, poster
/// on top, details below. Elsewhere: a centred panel, poster on the left,
/// details beside it. The poster keeps the card's shape so it simply grows
/// into place.
({Rect panel, Rect poster, Rect details}) _finalLayout(
  Size size,
  EdgeInsets safe, {
  required bool isNarrow,
}) {
  const inset = 24.0;
  if (isNarrow) {
    final height = math.min(
      size.height * 0.45,
      (size.width - inset * 2) / kPosterAspect,
    );
    final poster = Rect.fromLTWH(
      (size.width - height * kPosterAspect) / 2,
      safe.top + inset,
      height * kPosterAspect,
      height,
    );
    return (
      panel: Offset.zero & size,
      poster: poster,
      details: Rect.fromLTRB(
        inset,
        poster.bottom + 24,
        size.width - inset,
        size.height - safe.bottom,
      ),
    );
  }
  final panel = Rect.fromCenter(
    center: size.center(Offset.zero),
    width: math.min(980, size.width - 64),
    height: math.min(640, size.height - 64),
  );
  final height = panel.height - inset * 2;
  final poster = Rect.fromLTWH(
    panel.left + inset,
    panel.top + inset,
    height * kPosterAspect,
    height,
  );
  return (
    panel: panel,
    poster: poster,
    details: Rect.fromLTRB(
      poster.right + 36,
      panel.top + inset + 8,
      panel.right - inset,
      panel.bottom - inset,
    ),
  );
}

String _storeName(String link) =>
    link.contains('play.google.com') ? 'Google Play' : 'the App Store';

/// Two type styles only (display for the name, body for the rest) so the
/// eye keeps one rhythm; numbers in the result are bold so the proof leads.
class _Details extends StatelessWidget {
  const _Details({
    required this.project,
    required this.isNarrow,
    required this.onOpenStore,
  });

  final FeaturedProject project;
  final bool isNarrow;
  final ValueChanged<String> onOpenStore;

  @override
  Widget build(BuildContext context) {
    final palette = Theme.of(context).homePalette;
    final body = SiteText.body(palette.textStrong);

    return ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: 640),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Semantics(
            header: true,
            child: Text(
              project.title.toUpperCase(),
              style: SiteText.display(
                palette.textStrong,
                size: isNarrow ? 44 : 56,
              ),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            project.role,
            style: SiteText.body(palette.textSecondary, size: 15),
          ),
          const SizedBox(height: 20),
          _Bullet(TextSpan(text: project.problem), style: body),
          _Bullet(TextSpan(text: project.built), style: body),
          _Bullet(_boldNumbers(project.result), style: body),
          const SizedBox(height: 8),
          Text(
            project.stack,
            style: SiteText.body(palette.textSecondary, size: 15),
          ),
          const SizedBox(height: 16),
          // SiteTextLink pads itself for its focus ring; pull it back so its
          // text lines up with the copy above.
          for (final link in project.links)
            Transform.translate(
              offset: const Offset(-6, 0),
              child: SiteTextLink(
                label: 'View on ${_storeName(link)} ↗',
                onTap: () => onOpenStore(link),
              ),
            ),
        ],
      ),
    );
  }
}

final _startsWithDigit = RegExp('^[0-9]');

/// [text] with every word that starts with a digit in bold, e.g. "60%".
TextSpan _boldNumbers(String text) => TextSpan(
  children: [
    for (final word in text.split(' '))
      TextSpan(
        text: '$word ',
        style: _startsWithDigit.hasMatch(word)
            ? const TextStyle(fontWeight: FontWeight.w700)
            : null,
      ),
  ],
);

class _Bullet extends StatelessWidget {
  const _Bullet(this.text, {required this.style});

  final InlineSpan text;
  final TextStyle style;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.only(bottom: 10),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('•  ', style: style),
        Expanded(child: Text.rich(text, style: style)),
      ],
    ),
  );
}
