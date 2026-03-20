import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:my_portfolio/constants/colors.dart';

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
    return Center(
      child: Card(
        elevation: 16,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(32),
          side: BorderSide(
            color: CustomColor.pastelRed.withValues(alpha: 0.5),
            width: 2,
          ),
        ),
        color: CustomColor.bgLight1,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 36),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
             const Icon(Icons.flutter_dash, color: CustomColor.pastelRed, 
             size: 56,),
              const SizedBox(height: 16),
              Text(
                'Game Over',
                style: GoogleFonts.poppins(
                  fontWeight: FontWeight.bold,
                  fontSize: 28,
                  color: CustomColor.textPrimary,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                'Score: $score',
                style: GoogleFonts.poppins(
                  fontSize: 20,
                  color: CustomColor.textPrimary,
                ),
              ),
              const SizedBox(height: 24),
              ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: CustomColor.pastelRed,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 32, vertical: 14),
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
