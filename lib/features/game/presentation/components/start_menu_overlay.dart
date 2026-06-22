import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:my_portfolio/core/resources/styles/home_palette.dart';

class StartMenuOverlay extends StatelessWidget {
  const StartMenuOverlay({
    required this.onStart,
    super.key,
  });
  final VoidCallback onStart;

  @override
  Widget build(BuildContext context) {
    final palette = Theme.of(context).homePalette;
    return Center(
      child: Card(
        elevation: 16,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(32),
          side: BorderSide(
            color: palette.secondaryAccent.withValues(alpha: 0.5),
            width: 2,
          ),
        ),
        color: palette.surfaceCard,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 36),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.flutter_dash,
                color: palette.secondaryAccent,
                size: 56,
              ),
              const SizedBox(height: 16),
              Text(
                'Flappy Bird',
                style: GoogleFonts.poppins(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: palette.textStrong,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                'Tap to start!',
                style: GoogleFonts.poppins(
                  fontSize: 20,
                  color: palette.textStrong,
                ),
              ),
              const SizedBox(height: 24),
              ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: palette.secondaryAccent,
                  foregroundColor: palette.onAccent,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 32,
                    vertical: 14,
                  ),
                  textStyle: GoogleFonts.poppins(
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
                  ),
                ),
                onPressed: onStart,
                icon: const Icon(Icons.play_arrow),
                label: const Text('Start Game'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
