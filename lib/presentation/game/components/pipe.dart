import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:my_portfolio/presentation/game/flappy_game.dart';
import 'package:my_portfolio/presentation/game/game_constants.dart';

class Pipe extends SpriteComponent
    with CollisionCallbacks, HasGameReference<FlappyGame> {
  Pipe(Vector2 position, Vector2 size, {required this.isTopPipe})
      : super(position: position, size: size);
  final bool isTopPipe;
  bool scored = false;
  @override
  Future<void> onLoad() async {
    super.onLoad();
    sprite = await Sprite.load(isTopPipe ? 'pipe_top.png' : 'pipe_bottom.png');

    add(RectangleHitbox());
  }

  @override
  void update(double dt) {
    super.update(dt);
    position.x -= groundScrollSpeed * dt;

    if (!scored && position.x + size.x < game.bird.position.x) {
      if (isTopPipe) {
        game.incrementScore();
        scored = true;
      }
    }

    if (position.x + size.x / 2 <= 0) {
      removeFromParent();
    }
  }
}
