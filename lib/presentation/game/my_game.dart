import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:my_portfolio/presentation/game/components/game_over_overlay.dart';
import 'package:my_portfolio/presentation/game/components/start_menu_overlay.dart';
import 'package:my_portfolio/presentation/game/flappy_game.dart';

void main() {
  runApp(const MyGame());
}

class MyGame extends StatelessWidget {
  const MyGame({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: GameWidget(
        game: FlappyGame(),
        overlayBuilderMap: {
          'startMenu': (context, game) {
            final flappyGame = game! as FlappyGame;
            return StartMenuOverlay(
              onStart: flappyGame.startGame,
            );
          },
          'gameOver': (context, game) {
            final flappyGame = game! as FlappyGame;
            return GameOverOverlay(
              score: flappyGame.score,
              onRestart: flappyGame.restartGame,
            );
          },
        },
      ),
    );
  }
}
