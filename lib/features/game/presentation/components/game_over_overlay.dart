import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:my_portfolio/core/resources/styles/home_palette.dart';

class GameOverOverlay extends StatelessWidget {
  const GameOverOverlay({
    required this.score,
    required this.onRestart,
    super.key,
  });
  final int score;
  final VoidCallback onRestart;

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
                'Game Over',
                style: GoogleFonts.poppins(
                  fontWeight: FontWeight.bold,
                  fontSize: 28,
                  color: palette.textStrong,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                'Score: $score',
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
                onPressed: onRestart,
                icon: const Icon(Icons.refresh),
                label: const Text('Restart'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
