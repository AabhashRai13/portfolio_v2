import 'package:flame/events.dart';
import 'package:flame/game.dart';
import 'package:my_portfolio/features/game/presentation/components/background.dart';
import 'package:my_portfolio/features/game/presentation/components/bird.dart';
import 'package:my_portfolio/features/game/presentation/components/game_over_overlay.dart';
import 'package:my_portfolio/features/game/presentation/components/ground.dart';
import 'package:my_portfolio/features/game/presentation/components/pipe_manager.dart';
import 'package:my_portfolio/features/game/presentation/components/score.dart';
import 'package:my_portfolio/features/game/presentation/game_constants.dart';

class FlappyGame extends FlameGame with TapCallbacks, HasCollisionDetection {
  late Bird bird;
  late Background background;
  late Ground ground;
  late PipeManager pipeManager;
  late ScoreText scoreText;
  late GameOverOverlay gameOverOverlay;
  bool isGameStarted = false; // Add this
  @override
  Future<void> onLoad() async {
    super.onLoad();

    background = Background(Vector2(size.x, size.y));
    add(background);
    bird = Bird();
    add(bird);
    ground = Ground();
    add(ground);

    pipeManager = PipeManager();
    add(pipeManager);

    scoreText = ScoreText();
    add(scoreText);

    // Start with paused game
    pauseEngine();
    overlays.add('startMenu');
  }

  int score = 0;
  void incrementScore() {
    score++;
  }

  void startGame() {
    isGameStarted = true;
    overlays.remove('startMenu');
    resumeEngine();
  }

  @override
  void onTapDown(TapDownEvent event) {
    super.onTapDown(event);
    bird.flap();
  }

  bool isGameOver = false;

  void gameOver() {
    if (isGameOver) return;
    isGameOver = true;
    pauseEngine();

    overlays.add(
      'gameOver',
    );
  }

  void restartGame() {
    isGameOver = false;
    isGameStarted = true; // Keep game started when restarting

    bird.position = Vector2(birdStartX, birdStartY);
    bird.velocity = 0;

    /// remove all pipes
    pipeManager.removeAll(pipeManager.children);
    score = 0;
    overlays.remove('gameOver');
    resumeEngine();
  }
}
