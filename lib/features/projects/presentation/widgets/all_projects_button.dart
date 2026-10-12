import 'package:flutter/material.dart';
import 'package:my_portfolio/core/presentation/widgets/press_scale.dart';
import 'package:my_portfolio/core/resources/styles/home_palette.dart';
import 'package:my_portfolio/core/resources/styles/site_text.dart';
import 'package:my_portfolio/core/services/tap_feedback.dart';

/// The way from the carousel to every project: a glass pill cut from the
/// same stuff as the stage above it. The arrow is an icon, not a typed
/// glyph, so it never falls back to an emoji. On hover or focus the pill
/// turns rose and the arrow steps forward.
class AllProjectsButton extends StatefulWidget {
  const AllProjectsButton({required this.onTap, super.key});

  static const String label = 'Explore all projects';

  final VoidCallback onTap;

  @override
  State<AllProjectsButton> createState() => _AllProjectsButtonState();
}

class _AllProjectsButtonState extends State<AllProjectsButton> {
  bool _active = false;

  void _setActive(bool value) {
    if (value != _active) setState(() => _active = value);
  }

  @override
  Widget build(BuildContext context) {
    final palette = Theme.of(context).homePalette;
    final reduceMotion = MediaQuery.disableAnimationsOf(context);

    return Semantics(
      link: true,
      label: AllProjectsButton.label,
      excludeSemantics: true,
      child: PressScale(
        pressedScale: 0.96,
        child: InkWell(
          onTap: () {
            tapFeedback();
            widget.onTap();
          },
          onHover: _setActive,
          onFocusChange: _setActive,
          customBorder: const StadiumBorder(),
          hoverColor: Colors.transparent,
          splashColor: Colors.transparent,
          highlightColor: Colors.transparent,
          child: TweenAnimationBuilder<double>(
            tween: Tween(end: _active ? 1 : 0),
            duration: reduceMotion
                ? Duration.zero
                : const Duration(milliseconds: 220),
            curve: Curves.easeOutCubic,
            builder: (context, t, _) {
              final color = Color.lerp(
                palette.textStrong,
                palette.linkActive,
                t,
              )!;
              return DecoratedBox(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(999),
                  color: Color.lerp(
                    palette.glassFill,
                    palette.glassHighlightStrong,
                    t,
                  ),
                  border: Border.all(
                    color: Color.lerp(
                      palette.textStrong.withValues(alpha: 0.18),
                      palette.linkActive,
                      t,
                    )!,
                    width: 1.2,
                  ),
                ),
                child: ConstrainedBox(
                  constraints: const BoxConstraints(minHeight: 48),
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(26, 12, 22, 12),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Flexible(
                          child: Text(
                            AllProjectsButton.label,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: SiteText.body(color, size: 16).copyWith(
                              height: 1.2,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Transform.translate(
                          offset: Offset(4 * t, 0),
                          child: Icon(
                            Icons.arrow_forward_rounded,
                            size: 18,
                            color: color,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
