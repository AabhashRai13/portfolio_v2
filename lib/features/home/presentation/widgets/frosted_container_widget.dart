import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:my_portfolio/core/resources/styles/home_palette.dart';

class FrostedGlassContainer extends StatelessWidget {
  const FrostedGlassContainer({
    required this.height,
    required this.width,
    required this.child,
    super.key,
  });

  final double height;
  final double width;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final palette = Theme.of(context).homePalette;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 40),
      child: Center(
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: Stack(
            children: [
              // Backdrop and glass effect
              BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 25, sigmaY: 25),
                child: Container(
                  height: height,
                  width: width,
                  decoration: BoxDecoration(
                    color: palette.glassFill,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: palette.glassBorder,
                      width: 1.2,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: palette.shadowColor.withValues(alpha: 0.02),
                        blurRadius: 30,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: child,
                ),
              ),

              // // Optional: Add a subtle noise texture overlay
              Positioned.fill(
                child: IgnorePointer(
                  child: Container(
                    height: height,
                    width: width,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          palette.glassHighlightStrong,
                          palette.glassHighlightSoft,
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
