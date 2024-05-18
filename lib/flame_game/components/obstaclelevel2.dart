import 'dart:math';

import 'package:flutter_application_1/flame_game/endless_runner.dart';

import '../endless_world.dart';
import 'package:flame/collisions.dart';
import 'package:flame/components.dart';

/// The [Point] components are the components that the [Player] should collect
/// to finish a level. The points are represented by Flame's mascot; Ember.
class Obstaclelevel2 extends SpriteAnimationComponent
    with HasGameReference, HasWorldReference<EndlessWorld> {
  Obstaclelevel2({required this.teleportpos})
      : super(size: spriteSize, anchor: Anchor.bottomCenter);

  static final Vector2 spriteSize = Vector2.all(150);
  final speed = 180;
  Vector2 teleportpos;
  @override
  Future<void> onLoad() async {
    position = teleportpos;
    const names = [
      'enemies/firespritesheet.png',
      'enemies/spritesheetexplosion5.png'
    ];
    Random random = new Random();
    int randomIndex = random.nextInt(names.length);
    String randomElement = names[randomIndex];

    switch (randomElement) {
      case 'enemies/firespritesheet.png':
        animation = await game.loadSpriteAnimation(
          'enemies/firespritesheet.png',
          SpriteAnimationData.sequenced(
            amount: 6,
            textureSize: Vector2.all(404),
            stepTime: 0.12,
          ),
        );
        position.y -= 60.0;
        size = Vector2.all(200);
      case 'enemies/spritesheetexplosion5.png':
        animation = await game.loadSpriteAnimation(
          'enemies/spritesheetexplosion5.png',
          SpriteAnimationData.sequenced(
            amount: 10,
            textureSize: Vector2.all(330),
            stepTime: 0.10,
          ),
        );
        size = Vector2.all(250);
    }

    //  print(position);
    // Since the original Ember sprite is looking to the right we have to flip
    // it, so that it is facing the player instead.
    // flipHorizontallyAroundCenter();

    // When adding a CircleHitbox without any arguments it automatically
    // fills up the size of the component as much as it can without overflowing
    // it.
    add(CircleHitbox());
  }

  @override
  void update(double dt) {
    super.update(dt);
    // We need to move the component to the left together with the speed that we
    // have set for the world plus the speed set for the point, so that it
    // is visually moving to the left in the world.
    // `dt` here stands for delta time and it is the time, in seconds, since the
    // last update ran. We need to multiply the speed by `dt` to make sure that
    // the speed of the obstacles are the same no matter the refresh rate/speed
    // of your device.
    position.x -= (world.speed + speed) * dt;

    // When the component is no longer visible on the screen anymore, we
    // remove it.
    // The position is defined from the upper left corner of the component (the
    // anchor) and the center of the world is in (0, 0), so when the components
    // position plus its size in X-axis is outside of minus half the world size
    // we know that it is no longer visible and it can be removed.
    if (position.x + size.x / 2 < -world.size.x / 2) {
      removeFromParent();
    }
  }
}
