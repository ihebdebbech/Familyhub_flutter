import 'package:flutter_application_1/flame_game/components/floatingground.dart';
import 'package:flutter_application_1/flame_game/components/obstaclelevel2.dart';
import 'package:flutter_application_1/flame_game/components/teleportation.dart';
import 'package:flutter_application_1/flame_game/game_screen.dart';
import 'package:flutter_application_1/level_selection/levels.dart';
import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flutter/animation.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:logging/logging.dart';

import '../../audio/sounds.dart';
import '../endless_runner.dart';
import '../endless_world.dart';
import '../effects/hurt_effect.dart';
import '../effects/jump_effect.dart';
import 'obstacle.dart';
import 'point.dart';

/// The [Player] is the component that the physical player of the game is
/// controlling.
class Player extends SpriteAnimationGroupComponent<PlayerState>
    with
        CollisionCallbacks,
        HasWorldReference<EndlessWorld>,
        HasGameReference<EndlessRunner> {
  Player(
      {required this.addScore,
      required this.resetScore,
      super.position,
      required this.level,
      required this.newgroundlevel})
      : super(size: Vector2.all(150), anchor: Anchor.center, priority: 1);

  final void Function({int amount}) addScore;
  final VoidCallback resetScore;
  bool roundended = false;
  GameLevel level;

  // The current velocity that the player has that comes from being affected by
  // the gravity. Defined in virtual pixels/s².
  double _gravityVelocity = 0;

  // The maximum length that the player can jump. Defined in virtual pixels.
  final double _jumpLength = 700;

  // Whether the player is currently in the air, this can be used to restrict
  // movement for example.
  double newgroundlevel;
  bool get inAir => (position.y + size.y / 2) < newgroundlevel;

  // Used to store the last position of the player, so that we later can
  // determine which direction that the player is moving.
  final Vector2 _lastPosition = Vector2.zero();

  // When the player has velocity pointing downwards it is counted as falling,
  // this is used to set the correct animation for the player.
  bool get isFalling => _lastPosition.y < position.y;

  @override
  Future<void> onLoad() async {
    if (level.number == 1) {
      // This defines the different animation states that the player can be in.
      animations = {
        PlayerState.running: await game.loadSpriteAnimation(
          'dash/dash_running.png',
          SpriteAnimationData.sequenced(
            amount: 4,
            textureSize: Vector2.all(16),
            stepTime: 0.15,
          ),
        ), // Placeholder for conditional assignment
        PlayerState.jumping: SpriteAnimation.spriteList(
          [await game.loadSprite('dash/dash_jumping.png')],
          stepTime: double.infinity,
        ),
        PlayerState.falling: SpriteAnimation.spriteList(
          [await game.loadSprite('dash/dash_falling.png')],
          stepTime: double.infinity,
        ),
      };
    } else {
      size = Vector2.all(180);
      animations = {
        PlayerState.running: await game.loadSpriteAnimation(
          'dash/runningwitch.png',
          SpriteAnimationData.sequenced(
            amount: 8,
            textureSize: Vector2.all(32),
            stepTime: 0.09,
          ),
        ), // Placeholder for conditional assignment
        PlayerState.jumping: await game.loadSpriteAnimation(
          'dash/jumpingwitch.png',
          SpriteAnimationData.sequenced(
            amount: 4,
            textureSize: Vector2.all(31),
            stepTime: 0.09,
          ),
        ),
        PlayerState.falling: await game.loadSpriteAnimation(
          'dash/fallingwitch.png',
          SpriteAnimationData.sequenced(
            amount: 4,
            textureSize: Vector2.all(31),
            stepTime: 0.15,
          ),
        ),
      };
    }

    // Load animations based on level number

    // The starting state will be that the player is running.
    current = PlayerState.running;
    position.y -= 50;
    //     _lastPosition.setFrom(position);
    _lastPosition.setFrom(position);

    // When adding a CircleHitbox without any arguments it automatically
    // fills up the size of the component as much as it can without overflowing
    // it.
    add(CircleHitbox());
  }

  @override
  void update(double dt) {
    super.update(dt);
    // When we are in the air the gravity should affect our position and pull
    // us closer to the ground.
    if (inAir) {
      _gravityVelocity += world.gravity * dt;
      position.y += _gravityVelocity;
      if (isFalling) {
        current = PlayerState.falling;
      }
    }
    if (roundended) {
      _gravityVelocity += world.gravity + 5 * dt;
      position.y -= _gravityVelocity;
      current = PlayerState.jumping;
      if (position.y <= (world.groundLevel - 900)) {
        game.pauseEngine();
        game.overlays.add(GameScreen.winDialogKey);
      
        /* Future.delayed(
            const Duration(seconds: 6),
            () => {
                  print('Delivered after a delay of 2 seconds'),
                  game.buildContext?.go('/play/session/${level.number + 1}')
                });
        */
      }

      // final jumpEffect = JumpEffect(towards);
    }
    //  position.y -= 50;
    //  _lastPosition.setFrom(position);
    // _lastPosition.setValues(position.x, position.y + 20);
    final belowGround = position.y + size.y / 2 > newgroundlevel;
    // If the player's new position would overshoot the ground level after
    // updating its position we need to move the player up to the ground level
    // again.
    if (belowGround) {
      position.y = newgroundlevel - size.y / 2;

      _gravityVelocity = 0;
      current = PlayerState.running;
    }

    _lastPosition.setFrom(position);
  }

  @override
  void onCollisionStart(
    Set<Vector2> intersectionPoints,
    PositionComponent other,
  ) {
    super.onCollisionStart(intersectionPoints, other);
    // When the player collides with an obstacle it should lose all its points.
    if (other is Obstacle) {
      game.audioController.playSfx(SfxType.damage);
      resetScore();
      // print(other.height);
      //newgroundlevel = other.height;
      //  position.y -= 50;
      // _lastPosition.setFrom(position);
      add(HurtEffect());
    } else if (other is floatingground) {
      game.audioController.playSfx(SfxType.doubleJump);
      //  resetScore();
      //print(other.height);
      newgroundlevel = other.height - 220;

      //  position.y -= 50;
      //    _lastPosition.setFrom(position);
      //current = PlayerState.running;
      // add(HurtEffect());
    } else if (other is Point) {
      // When the player collides with a point it should gain a point and remove
      // the `Point` from the game.
      game.audioController.playSfx(SfxType.score);
      other.removeFromParent();
      addScore();
    } else if (other is Teleportation) {
      // game.pauseEngine();
      //world.speed = 0;
      // newgroundlevel = other.height - 120;
      roundended = true;
      //game.overlays.add(GameScreen.winDialogKey);
    }
    else if(other is Obstaclelevel2){
game.audioController.playSfx(SfxType.damage);
      resetScore();
      // print(other.height);
      //newgroundlevel = other.height;
      //  position.y -= 50;
      // _lastPosition.setFrom(position);
      add(HurtEffect());
    }
  }

  @override
  void onCollisionEnd(PositionComponent other) {
    newgroundlevel = world.groundLevel;
  }

  /// [towards] should be a normalized vector that points in the direction that
  /// the player should jump.
  void jump(Vector2 towards) {
    if (towards.x.isNegative) {
      print(towards..setValues(towards.x - 200, -(towards.y + 500)));
    } else {
      print(towards..setValues(towards.x + 200, -(towards.y + 500)));
    }
    current = PlayerState.jumping;
    // Since `towards` is normalized we need to scale (multiply) that vector by
    // the length that we want the jump to have.
    //  final jumpEffect = JumpEffect(towards..scaleTo(_jumpLength));
    final jumpEffect = JumpEffect(towards);
    print(towards);
    // We only allow jumps when the player isn't already in the air.
    //if (!inAir) {
    game.audioController.playSfx(SfxType.jump);
    add(jumpEffect);
    // }
  }
}

enum PlayerState {
  running,
  jumping,
  falling,
}
