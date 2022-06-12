import 'package:candy_man/src/elements/player_model.dart';
import 'package:candy_man/src/game/candy_man_game.dart';
import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:logging/logging.dart';

const playerSpriteMap = {"m1": "Male 01-1.png"};

class PlayerAnimation extends SpriteAnimationComponent
    with HasGameRef<CandyManGame> {
  static final _log = Logger('PlayerAnimation');

  static const _animationFrameAmount = 3;
  static const _animationStepTime = 0.1;
  static const _animationPerRow = 3;
  static const _playerPriority = 100;

  final _spriteSize = Vector2.all(32.0);

  late SpriteAnimation _idleAnimation;

  late SpriteAnimation _walkUpAnimation;

  late SpriteAnimation _walkDownAnimation;

  late SpriteAnimation _walkLeftAnimation;

  late SpriteAnimation _walkRightAnimation;

  final bool debugMode;

  final String character;

  PlayerAnimation({required this.character, this.debugMode = false})
      : assert(playerSpriteMap.containsKey(character));

  @override
  Future<void> onLoad() async {
    _log.info('Loading player animiation');
    super.onLoad();
    anchor = Anchor.center;
    super.priority = _playerPriority;

    await _loadAnimations();
  }

  @override
  void update(double dt) {
    super.update(dt);

//    position = playerModel.moveFor(dt);
  }

  @override
  void onGameResize(Vector2 size) {
    super.onGameResize(size);

    this.size = gameRef.gridSize;
  }

//
//  @override
//  void onCollisionStart(Set<Vector2> points, PositionComponent other) {
//    super.onCollisionStart(points, other);
//    print('start');
//    print(points);
//    if (other is ScreenHitbox) {
//      //...
//    } else if (other is BubbleComponent) {
//      playerModel.collisionStart(other.bubbleModel);
//    }
//  }
//
//  @override
//  void onCollisionEnd(PositionComponent other) {
//    super.onCollisionEnd(other);
//    print('end');
//    if (other is BubbleComponent) {
//      playerModel.stepOutOfBubble(other);
//      playerModel.collisionEnd(other.bubbleModel);
//    }
//  }

  void updateMovementState(PlayerMovementState playerMovementState) {
    switch (playerMovementState) {
      case PlayerMovementState.movingUp:
        animation = _walkUpAnimation;
        return;
      case PlayerMovementState.movingDown:
        animation = _walkDownAnimation;
        return;
      case PlayerMovementState.movingLeft:
        animation = _walkLeftAnimation;
        return;
      case PlayerMovementState.movingRight:
        animation = _walkRightAnimation;
        return;
      case PlayerMovementState.idle:
      default:
        animation = _idleAnimation;
        return;
    }
  }

  Future<void> _loadAnimations() async {
    // 0 = idle
    // 0 - 3 = run down
    // 4 - 6 = run left
    // 7 - 9 = run right
    // 10 - 12 = run up

    final spriteSheet = await gameRef.images.load(playerSpriteMap[character]!);
    _idleAnimation = SpriteAnimation.fromFrameData(
        spriteSheet,
        SpriteAnimationData.sequenced(
            textureSize: _spriteSize,
            amount: 1,
            stepTime: _animationStepTime,
            amountPerRow: 1,
            texturePosition: Vector2(0, 0)));

    _walkUpAnimation = SpriteAnimation.fromFrameData(
        spriteSheet,
        SpriteAnimationData.sequenced(
            textureSize: _spriteSize,
            amount: _animationFrameAmount,
            stepTime: _animationStepTime,
            amountPerRow: _animationPerRow,
            texturePosition: Vector2(0, 96)));
    _walkDownAnimation = SpriteAnimation.fromFrameData(
        spriteSheet,
        SpriteAnimationData.sequenced(
            textureSize: _spriteSize,
            amount: _animationFrameAmount,
            stepTime: _animationStepTime,
            amountPerRow: _animationPerRow,
            texturePosition: Vector2(0, 0)));
    _walkLeftAnimation = SpriteAnimation.fromFrameData(
        spriteSheet,
        SpriteAnimationData.sequenced(
            textureSize: _spriteSize,
            amount: _animationFrameAmount,
            stepTime: _animationStepTime,
            amountPerRow: _animationPerRow,
            texturePosition: Vector2(0, 32)));
    _walkRightAnimation = SpriteAnimation.fromFrameData(
        spriteSheet,
        SpriteAnimationData.sequenced(
            textureSize: _spriteSize,
            amount: _animationFrameAmount,
            stepTime: _animationStepTime,
            amountPerRow: _animationPerRow,
            texturePosition: Vector2(0, 64)));

    this.animation = _idleAnimation;
  }
}
