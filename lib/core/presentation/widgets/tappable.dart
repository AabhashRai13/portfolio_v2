import 'package:flutter/material.dart';
import 'package:my_portfolio/core/presentation/widgets/press_scale.dart';
import 'package:my_portfolio/core/services/tap_feedback.dart';

/// A card-sized tap target that behaves the same everywhere: read out as a
/// button named [label], a hand cursor on hover, a slight shrink while
/// pressed and [tapFeedback] on tap.
class Tappable extends StatelessWidget {
  const Tappable({
    required this.label,
    required this.onTap,
    required this.child,
    super.key,
  });

  final String label;
  final VoidCallback onTap;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      label: label,
      excludeSemantics: true,
      child: GestureDetector(
        onTap: () {
          tapFeedback();
          onTap();
        },
        child: MouseRegion(
          cursor: SystemMouseCursors.click,
          child: PressScale(pressedScale: 0.97, child: child),
        ),
      ),
    );
  }
}
