import 'package:flame/components.dart';

class Background extends SpriteComponent {
  Background(Vector2 size) : super(
    size: size,
    position: Vector2(0, 0),
  );

  @override
  Future<void> onLoad() async {
    super.onLoad();
    sprite = await Sprite.load('background.png');
  }

}
