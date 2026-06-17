import 'package:flutter/material.dart';

class EditorialActionButton extends StatefulWidget {
  const EditorialActionButton({
    required this.child,
    this.onPressed,
    this.isActive = false,
    this.expand = false,
    super.key,
  });

  final Widget child;
  final VoidCallback? onPressed;
  final bool isActive;
  final bool expand;

  @override
  State<EditorialActionButton> createState() => _EditorialActionButtonState();
}

class _EditorialActionButtonState extends State<EditorialActionButton> {
  bool _isHovered = false;
  bool _isPressed = false;
  bool _isFocused = false;

  bool get _isInteractive => widget.onPressed != null;

  Color _backgroundColor(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final primary = scheme.primary;
    final secondary = scheme.secondary;

    if (!_isInteractive) {
      return widget.isActive
          ? secondary.withValues(alpha: 0.9)
          : primary.withValues(alpha: 0.46);
    }

    if (_isPressed || widget.isActive) {
      return secondary;
    }

    if (_isHovered || _isFocused) {
      return secondary;
    }

    return primary;
  }

  @override
  Widget build(BuildContext context) {
    final backgroundColor = _backgroundColor(context);

    return AnimatedScale(
      duration: const Duration(milliseconds: 160),
      curve: Curves.easeOutCubic,
      scale: _isPressed && _isInteractive ? 0.98 : 1,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        curve: Curves.easeOutCubic,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(999),
          boxShadow: <BoxShadow>[
            BoxShadow(
              color: backgroundColor.withValues(
                alpha: _isPressed ? 0.14 : 0.22,
              ),
              blurRadius: _isHovered ? 24 : 18,
              offset: Offset(0, _isPressed ? 4 : 10),
            ),
          ],
        ),
        child: Material(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(999),
          child: InkWell(
            onTap: widget.onPressed,
            onHover: (value) => setState(() => _isHovered = value),
            onFocusChange: (value) => setState(() => _isFocused = value),
            onHighlightChanged: (value) => setState(() => _isPressed = value),
            borderRadius: BorderRadius.circular(999),
            splashColor: Colors.white.withValues(alpha: 0.14),
            highlightColor: Colors.white.withValues(alpha: 0.08),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 180),
              curve: Curves.easeOutCubic,
              width: widget.expand ? double.infinity : null,
              padding: EdgeInsets.symmetric(
                horizontal: widget.expand ? 24 : 22,
                vertical: 15,
              ),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(999),
                border: Border.all(
                  color: Colors.white.withValues(
                    alpha: _isHovered || _isFocused ? 0.34 : 0.16,
                  ),
                ),
              ),
              child: DefaultTextStyle(
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 17,
                  fontWeight: FontWeight.w700,
                  letterSpacing: -0.1,
                ),
                child: IconTheme(
                  data: const IconThemeData(
                    color: Colors.white,
                    size: 21,
                  ),
                  child: widget.child,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
