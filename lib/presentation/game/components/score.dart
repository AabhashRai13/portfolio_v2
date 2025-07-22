import 'dart:ui';

import 'package:flame/components.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:my_portfolio/presentation/game/flappy_game.dart';

class ScoreText extends TextComponent with HasGameReference<FlappyGame> {
  ScoreText()
      : super(
          text: '0',
          textRenderer: TextPaint(
            style: GoogleFonts.poppins(
              fontSize: 40,
              fontWeight: FontWeight.w600,
            ),
          ),
        );

  @override
  Future<void> onLoad() async {
    super.onLoad();
    position = Vector2((game.size.x - size.x) / 2, game.size.y - size.y - 50);
  }

  @override
  void update(double dt) {
    super.update(dt);
    final newText = game.score.toString();
    if (text != newText) {
      text = newText;
    }
  }
}
