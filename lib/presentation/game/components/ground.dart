import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:my_portfolio/presentation/game/flappy_game.dart';
import 'package:my_portfolio/presentation/game/game_constants.dart';

class Ground extends SpriteComponent with HasGameReference<FlappyGame> , 
CollisionCallbacks{
  Ground() : super(
   
  );

  @override
  Future<void> onLoad() async {
    super.onLoad();
    size = Vector2( 2 *game.size.x, groundHeight);
    position = Vector2(0, game.size.y - groundHeight);
    sprite = await Sprite.load('ground.png');
    add(RectangleHitbox());
  }

  @override
  void update(double dt) {
    super.update(dt);
    position.x -= groundScrollSpeed * dt;

    if (position.x + size.x /2 <=0) {
      position.x = 0;
    }
  }
} 
