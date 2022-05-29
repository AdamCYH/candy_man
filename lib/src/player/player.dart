import 'package:candy_man/src/game/candy_man_game.dart';
import 'package:candy_man/src/joy_stick/joy_stick_controller.dart';
import 'package:flame/components.dart';

class Player extends SpriteAnimationComponent with HasGameRef<CandyManGame> {
  static const _animationFrameAmount = 3;
  static const _animationStepTime = 0.1;
  static const _animationPerRow = 3;

  static const playerSpriteMap = {"m1": "Male 01-1.png"};

  final String character;
  final JoystickController joystickController;

  final _spriteSize = Vector2.all(32.0);
  double _speed = 300;

  late SpriteAnimation _idleAnimation;

  late SpriteAnimation _walkUpAnimation;

  late SpriteAnimation _walkDownAnimation;

  late SpriteAnimation _walkLeftAnimation;

  late SpriteAnimation _walkRightAnimation;

  Vector2 _moveDirection = Vector2.zero();
  PlayerState _playerState = PlayerState.idle;

  Player(
      {required this.character,
      required this.joystickController,
      bool debugMode = false})
      : assert(playerSpriteMap.containsKey(character)) {
    super.debugMode = debugMode;
  }

  @override
  Future<void> onLoad() async {
    _loadAnimations();

    joystickController.onFire.listen((event) {
      switch (event.direction) {
        case Direction.up:
          walkUp();
          return;
        case Direction.down:
          walkDown();
          return;
        case Direction.left:
          walkLeft();
          return;
        case Direction.right:
          walkRight();
          return;
        case Direction.idle:
          idle();
          return;
      }
    });
  }

  @override
  void update(double dt) {
    super.update(dt);

    if (_playerState == PlayerState.idle) {
      animation = _idleAnimation;
      return;
    }

    this.position += _moveDirection.normalized() * _speed * dt;
  }

  void walkUp() {
    _playerState = PlayerState.moving;
    _moveDirection = Vector2(0, -1);
    this.animation = _walkUpAnimation;
  }

  void walkDown() {
    _moveDirection = Vector2(0, 1);
    _playerState = PlayerState.moving;
    this.animation = _walkDownAnimation;
  }

  void walkLeft() {
    _playerState = PlayerState.moving;
    _moveDirection = Vector2(-1, 0);
    this.animation = _walkLeftAnimation;
  }

  void walkRight() {
    _playerState = PlayerState.moving;
    _moveDirection = Vector2(1, 0);
    this.animation = _walkRightAnimation;
  }

  void idle() {
    _playerState = PlayerState.idle;
    _moveDirection = Vector2(0, 0);
    this.animation = _idleAnimation;
  }

  @override
  void onGameResize(Vector2 size) {
    super.onGameResize(size);

    this.width = 100;
    this.height = 100;
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
  }
}

enum PlayerState { moving, idle }
