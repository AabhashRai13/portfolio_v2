import 'package:flame/game.dart';
import 'package:flutter/widgets.dart';
import 'package:my_portfolio/features/game/presentation/components/game_over_overlay.dart';
import 'package:my_portfolio/features/game/presentation/components/start_menu_overlay.dart';
import 'package:my_portfolio/features/game/presentation/flappy_game.dart';

class MyGame extends StatelessWidget {
  const MyGame({super.key});

  @override
  Widget build(BuildContext context) {
    return GameWidget(
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
    );
  }
}
