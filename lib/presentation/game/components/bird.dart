import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:my_portfolio/presentation/game/components/ground.dart';
import 'package:my_portfolio/presentation/game/components/pipe.dart';
import 'package:my_portfolio/presentation/game/flappy_game.dart';
import 'package:my_portfolio/presentation/game/game_constants.dart';

class Bird extends SpriteComponent with CollisionCallbacks {
  Bird()
      : super(
          size: Vector2(birdWidth, birdHeight),
          position: Vector2(birdStartX, birdStartY),
        );

  double velocity = 0;

  @override
  Future<void> onLoad() async {
    super.onLoad();
    sprite = await Sprite.load('bird.png');
    add(RectangleHitbox());
  }

  void flap() {
    velocity = jumpStrength;
  }

  @override
  void update(double dt) {
    super.update(dt);
    if (position.y < 0) {
      position.y = 0;
      velocity = 0;
    } else {
      // apply gravity
      velocity += gravity * dt;
      // update position of bird
      position.y += velocity * dt;
    }
  }

  // collision with other objects
  @override
  void onCollision(Set<Vector2> intersectionPoints, PositionComponent other) {
    super.onCollision(intersectionPoints, other);
    if (other is Ground) {
      (parent! as FlappyGame).gameOver();
    }

    if (other is Pipe) {
      (parent! as FlappyGame).gameOver();
    }
  }
}
