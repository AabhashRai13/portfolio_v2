import 'package:flutter/widgets.dart';

/// Shrinks [child] slightly while a finger or mouse button is down on it,
/// so a press reads as a press before anything else happens.
class PressScale extends StatefulWidget {
  const PressScale({required this.child, this.pressedScale = 0.92, super.key});

  final Widget child;
  final double pressedScale;

  @override
  State<PressScale> createState() => _PressScaleState();
}

class _PressScaleState extends State<PressScale> {
  bool _down = false;

  void _set({required bool down}) {
    if (down != _down) setState(() => _down = down);
  }

  @override
  Widget build(BuildContext context) {
    return Listener(
      onPointerDown: (_) => _set(down: true),
      onPointerUp: (_) => _set(down: false),
      onPointerCancel: (_) => _set(down: false),
      child: AnimatedScale(
        scale: _down ? widget.pressedScale : 1,
        duration: const Duration(milliseconds: 120),
        curve: Curves.easeOut,
        child: widget.child,
      ),
    );
  }
}
