import 'dart:async';

import 'package:flutter/material.dart';

/// [text] whose letters roll up out of their slots, left to right, while a
/// copy of each rolls in from below, every time [active] turns on (a hover,
/// say). Plain [Text] at rest, and always when the platform asks for less
/// motion.
class RollText extends StatefulWidget {
  const RollText(
    this.text, {
    required this.style,
    required this.active,
    super.key,
  });

  final String text;
  final TextStyle style;
  final bool active;

  /// On the rolling letters, which exist only mid-roll.
  static const Key rollKey = ValueKey<String>('roll-text');

  @override
  State<RollText> createState() => _RollTextState();
}

class _RollTextState extends State<RollText>
    with SingleTickerProviderStateMixin {
  // Each letter rolls over this share of the whole; the rest staggers starts.
  static const double _span = 0.5;

  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 500),
  );

  @override
  void didUpdateWidget(RollText oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.active &&
        !oldWidget.active &&
        !MediaQuery.disableAnimationsOf(context)) {
      unawaited(_controller.forward(from: 0));
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => AnimatedBuilder(
    animation: _controller,
    builder: (context, _) {
      final plain = Text(widget.text, style: widget.style);
      if (!_controller.isAnimating) return plain;
      return Stack(
        children: [
          Opacity(opacity: 0, alwaysIncludeSemantics: true, child: plain),
          Positioned.fill(
            child: ExcludeSemantics(
              // Letters set one by one lose kerning and can run a hair
              // wider than the line; shrink rather than overflow.
              child: FittedBox(
                fit: BoxFit.scaleDown,
                alignment: Alignment.centerLeft,
                child: Row(
                  key: RollText.rollKey,
                  children: _letters(_controller.value),
                ),
              ),
            ),
          ),
        ],
      );
    },
  );

  List<Widget> _letters(double t) {
    final chars = widget.text.characters.toList();
    final step = chars.length > 1 ? (1 - _span) / (chars.length - 1) : 0.0;
    return [
      for (final (i, char) in chars.indexed)
        _letter(
          char,
          Curves.easeInOutCubic.transform(
            ((t - i * step) / _span).clamp(0.0, 1.0),
          ),
        ),
    ];
  }

  Widget _letter(String char, double rolled) {
    final glyph = Text(char, style: widget.style);
    return ClipRect(
      child: Stack(
        children: [
          FractionalTranslation(translation: Offset(0, -rolled), child: glyph),
          FractionalTranslation(
            translation: Offset(0, 1 - rolled),
            child: glyph,
          ),
        ],
      ),
    );
  }
}
