import 'package:candy_man/src/elements/bubble.dart';
import 'package:candy_man/src/elements/player_model.dart';
import 'package:candy_man/src/game/candy_man_game.dart';
import 'package:candy_man/src/joy_stick/action_controller.dart';
import 'package:flame/components.dart';

const playerSpriteMap = {"m1": "Male 01-1.png"};

class Player extends SpriteAnimationComponent with HasGameRef<CandyManGame> {
  static const _animationFrameAmount = 3;
  static const _animationStepTime = 0.1;
  static const _animationPerRow = 3;

  final _spriteSize = Vector2.all(32.0);

  late SpriteAnimation _idleAnimation;

  late SpriteAnimation _walkUpAnimation;

  late SpriteAnimation _walkDownAnimation;

  late SpriteAnimation _walkLeftAnimation;

  late SpriteAnimation _walkRightAnimation;

  ActionType? _previousAction;

  final bool debugMode;
  final String character;
  final ActionController actionController;
  final Vector2 gridSize;

  late PlayerModel playerModel;

  Player(
      {required this.character,
      required this.actionController,
      required this.gridSize,
      Vector2? position,
      this.debugMode = false})
      : assert(playerSpriteMap.containsKey(character)) {
    super.priority = 100;

    playerModel = PlayerModel(
        position: position ?? Vector2.zero(),
        onMovementStateChange: (playerMovementState) =>
            _onMovementStateChange(playerMovementState));
  }

  @override
  Future<void> onLoad() async {
    super.onLoad();

    _loadAnimations();

    actionController.onFire.listen((event) {
      if (_previousAction == event.actionType) return;

      _previousAction = event.actionType;
      switch (event.actionType) {
        case ActionType.moveUp:
          playerModel.walkUp();
          return;
        case ActionType.moveDown:
          playerModel.walkDown();
          return;
        case ActionType.moveLeft:
          playerModel.walkLeft();
          return;
        case ActionType.moveRight:
          playerModel.walkRight();
          return;
        case ActionType.idle:
          playerModel.idle();
          return;
        case ActionType.dropBubble:
          gameRef.gameWorld.dropBubble(Bubble.dropByPlayer(
              player: this, gridSize: gridSize, debugMode: debugMode));
          return;
        default:
          playerModel.idle();
          return;
      }
    });
  }

  @override
  void update(double dt) {
    super.update(dt);

    var toPosition = this.position +
        playerModel.moveDirection.normalized() * playerModel.speed * dt;
    if (canMoveTo(toPosition)) {
      this.position = toPosition;
    }
  }

  @override
  void onGameResize(Vector2 size) {
    super.onGameResize(size);

    this.size = gridSize;
  }

  bool canMoveTo(Vector2 position) {
    return position.x >= 0 &&
        position.x <= gameRef.worldSize.x - gameRef.gridSize.x &&
        position.y >= 0 &&
        position.y <= gameRef.worldSize.y - gameRef.gridSize.y;
  }

  void _onMovementStateChange(PlayerMovementState playerMovementState) {
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
