import 'package:flutter/widgets.dart';
import 'package:my_portfolio/features/about/presentation/widgets/viewport_span.dart';

/// Draws [text] dim and brightens it word by word, in reading order, as it
/// scrolls up through the reading band; scrolling back dims it again. Fully
/// lit when the platform asks for less motion.
///
/// It rebuilds only when another word lights, not on every scroll frame.
class ScrollHighlightText extends StatefulWidget {
  const ScrollHighlightText(this.text, {required this.style, super.key});

  /// Opacity of words not reached yet: reads as unlit, but still reads.
  static const double dimAlpha = 0.35;

  final String text;
  final TextStyle style;

  @override
  State<ScrollHighlightText> createState() => _ScrollHighlightTextState();
}

class _ScrollHighlightTextState extends State<ScrollHighlightText> {
  // The text lights while its centre moves between these screen fractions.
  static const double _bandStart = 0.9;
  static const double _bandEnd = 0.5;

  late List<String> _words = _split(widget.text);
  ScrollPosition? _position;
  int _lit = 0;

  static List<String> _split(String text) => [
    for (final match in RegExp(r'\S+\s*').allMatches(text)) match[0]!,
  ];

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // A resized window moves the text within the band.
    MediaQuery.sizeOf(context);
    final position = Scrollable.maybeOf(context)?.position;
    if (MediaQuery.disableAnimationsOf(context) || position == null) {
      _listenTo(null);
      _lit = _words.length;
      return;
    }
    _listenTo(position);
    WidgetsBinding.instance.addPostFrameCallback((_) => _update());
  }

  @override
  void didUpdateWidget(ScrollHighlightText oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.text == widget.text) return;
    _words = _split(widget.text);
    _lit = _position == null ? _words.length : 0;
    WidgetsBinding.instance.addPostFrameCallback((_) => _update());
  }

  void _listenTo(ScrollPosition? position) {
    if (position == _position) return;
    _position?.removeListener(_onScroll);
    _position = position?..addListener(_onScroll);
  }

  void _onScroll() => afterLayout(_update);

  void _update() {
    final position = _position;
    if (!mounted || position == null) return;
    final span = viewportSpan(context);
    if (span == null) return;

    final int lit;
    if (atScrollEnd(position)) {
      // It can't travel any further up, so don't leave it half lit.
      lit = _words.length;
    } else {
      final centre = (span.top + span.bottom) / 2;
      final progress = (_bandStart - centre) / (_bandStart - _bandEnd);
      lit = (progress.clamp(0.0, 1.0) * _words.length).round();
    }
    if (lit != _lit) setState(() => _lit = lit);
  }

  @override
  void dispose() {
    _listenTo(null);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final ink = widget.style.color ?? DefaultTextStyle.of(context).style.color!;
    final dim = ink.withValues(alpha: ink.a * ScrollHighlightText.dimAlpha);
    return Text.rich(
      TextSpan(
        children: [
          for (final (index, word) in _words.indexed)
            TextSpan(
              text: word,
              style: TextStyle(color: index < _lit ? ink : dim),
            ),
        ],
      ),
      style: widget.style,
    );
  }
}
