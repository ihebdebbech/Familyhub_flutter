import 'dart:math';

import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/extensions.dart';

import '../endless_world.dart';

/// The [floatingground] component can represent three different types of floatinggrounds
/// that the player can run into.
class floatingground extends SpriteComponent
    with HasWorldReference<EndlessWorld> {
  floatingground.small({super.position})
      : _srcSize = Vector2(50, 50),
        _srcPosition = Vector2.zero(),
        super(
          size: Vector2(200, 100),
          anchor: Anchor.bottomLeft,
        );

  floatingground.tall({super.position})
      : _srcSize = Vector2(32, 48),
        _srcPosition = Vector2.zero(),
        super(
          size: Vector2(200, 250),
          anchor: Anchor.bottomLeft,
        );

  floatingground.wide({super.position})
      : _srcSize = Vector2(28, 16),
        _srcPosition = Vector2(48, 32),
        super(
          size: Vector2(200, 100),
          anchor: Anchor.bottomLeft,
        );

  /// Generates a random floatingground of type [floatinggroundType].
  factory floatingground.random({
    Vector2? position,
    Random? random,
    bool canSpawnTall = true,
  }) {
    final values = const [floatinggroundType.smallfloat];

    final floatinggroundtype = values[0];
    switch (floatinggroundtype) {
      case floatinggroundType.smallfloat:
        return floatingground.small(position: position);
    }
  }

  final Vector2 _srcSize;
  final Vector2 _srcPosition;

  @override
  Future<void> onLoad() async {
    if (world.level.number == 1) {
      // Since all the floatinggrounds reside in the same image, srcSize and srcPosition
      // are used to determine what part of the image that should be used.
      sprite = await Sprite.load(
        'scenery/tile105.png',
        srcSize: _srcSize,
        srcPosition: _srcPosition,
      );
    }
    else{
       sprite = await Sprite.load(
        'scenery/Explosion_2_1.png',
        srcSize: _srcSize,
        srcPosition: _srcPosition,
      );
      size =Vector2(200,150);
      
    }
    print("innnn");
    // When adding a RectangleHitbox without any arguments it automatically
    // fills up the size of the component.
    add(RectangleHitbox());
  }

  @override
  void update(double dt) {
    // We need to move the component to the left together with the speed that we
    // have set for the world.
    // `dt` here stands for delta time and it is the time, in seconds, since the
    // last update ran. We need to multiply the speed by `dt` to make sure that
    // the speed of the floatinggrounds are the same no matter the refresh rate/speed
    // of your device.
    position.x -= world.speed * dt;

    // When the component is no longer visible on the screen anymore, we
    // remove it.
    // The position is defined from the upper left corner of the component (the
    // anchor) and the center of the world is in (0, 0), so when the components
    // position plus its size in X-axis is outside of minus half the world size
    // we know that it is no longer visible and it can be removed.
    if (position.x + size.x < -world.size.x / 2) {
      removeFromParent();
    }
  }
}

enum floatinggroundType {
  smallfloat,
}
