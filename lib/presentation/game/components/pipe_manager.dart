import 'dart:math';

import 'package:flame/components.dart';
import 'package:my_portfolio/presentation/game/components/pipe.dart';
import 'package:my_portfolio/presentation/game/flappy_game.dart';
import 'package:my_portfolio/presentation/game/game_constants.dart';

class PipeManager extends Component with HasGameReference<FlappyGame> {
  double pipeSpawnTime = 0;

  @override
  void update(double dt) {
    super.update(dt);
    pipeSpawnTime += dt;
    const double pipeSpawnInterval = 2;
    if (pipeSpawnTime > pipeSpawnInterval) {
      pipeSpawnTime = 0;
      spawnPipe();
    }
  }

  void spawnPipe() {
    final screenHeight = game.size.y;
    const pipeGap = 150.0;
    const minPipeHeight = 50.0;
    const pipeWidth = 60.0;

    final maxPipeHeight = screenHeight - groundHeight - pipeGap - minPipeHeight;

    final bottomPipeHeight =
        minPipeHeight + Random().nextDouble() * (maxPipeHeight - minPipeHeight);
    final topPipeHeight = screenHeight - groundHeight 
    - pipeGap - bottomPipeHeight;

    final bottomPipe = Pipe(
      Vector2(game.size.x, screenHeight - groundHeight - bottomPipeHeight),
      Vector2(pipeWidth, bottomPipeHeight),
      isTopPipe: false,
    );

    final topPipe = Pipe(
      Vector2(game.size.x, 0),
      Vector2(pipeWidth, topPipeHeight),
      isTopPipe: true,
    );

    add(bottomPipe);
    add(topPipe);
  }
}
