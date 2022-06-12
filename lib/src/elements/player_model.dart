import 'package:candy_man/src/elements/bubble_model.dart';
import 'package:candy_man/src/elements/game_element.dart';
import 'package:candy_man/src/elements/player_component.dart';
import 'package:candy_man/src/game_world/game_world.dart';
import 'package:candy_man/src/joy_stick/action_controller.dart';
import 'package:flame/components.dart';
import 'package:logging/logging.dart';
import 'package:vector_math/vector_math_64.dart';

class PlayerModel extends GameElement {
  static final _log = Logger('CandyManGame');

  final String character;
  final ActionController actionController;

  PlayerMovementState _playerMovementState;

  Direction _moveDirection = Direction.idle;

  bool debugMode;
  Vector2 position;
  bool collidable;
  double speed;

  late final PlayerComponent component;

  /// Bubbles initially dropped by user do not collide until user moving out.
  var _onDroppedBubbles = <BubbleModel>{};

  var _collisions = <GameElement, Direction>{};

  PlayerModel(
      {required this.character,
      required this.actionController,
      required this.position,
      this.speed = 300,
      this.collidable = true,
      this.debugMode = false})
      : _playerMovementState = PlayerMovementState.idle;

  @override
  final ElementType elementType = ElementType.player;

  @override
  Future<PlayerComponent> create() async {
    _log.info('Creating player component');
    component = PlayerComponent(playerModel: this, debugMode: debugMode);
    return component;
  }

  PlayerMovementState get playerMovementState => _playerMovementState;

  Direction get moveDirection => _moveDirection;

  void walkUp() {
    _playerMovementState = PlayerMovementState.movingUp;
    _moveDirection = Direction.up;
    component.animation.updateMovementState(_playerMovementState);
    component.body.linearVelocity = moveDirection.vector * speed;
  }

  void walkDown() {
    _playerMovementState = PlayerMovementState.movingDown;
    _moveDirection = Direction.down;
    component.animation.updateMovementState(_playerMovementState);
    component.body.linearVelocity = moveDirection.vector * speed;
  }

  void walkLeft() {
    _playerMovementState = PlayerMovementState.movingLeft;
    _moveDirection = Direction.left;
    component.animation.updateMovementState(_playerMovementState);
    component.body.linearVelocity = moveDirection.vector * speed;
  }

  void walkRight() {
    _playerMovementState = PlayerMovementState.movingRight;
    _moveDirection = Direction.right;
    component.animation.updateMovementState(_playerMovementState);
    component.body.linearVelocity = moveDirection.vector * speed;
  }

  void idle() {
    _playerMovementState = PlayerMovementState.idle;
    _moveDirection = Direction.idle;
    component.animation.updateMovementState(_playerMovementState);
    component.body.linearVelocity = Vector2.zero();
  }

//
//  void collisionStart(GameElement model) {
//    print('in just dropped ' + _onDroppedBubbles.contains(model).toString());
//    if (!_onDroppedBubbles.contains(model)) {
//      _collisions[model] = moveDirection;
//    }
//  }
//
//  void collisionEnd(GameElement model) {
//    _collisions.remove(model);
//  }
//
  Future<void> dropBubble(GameWorld gameWorld) async {
    var bubble = await gameWorld.dropBubble(this);
    if (bubble != null) {
      _onDroppedBubbles.add(bubble);
    }
  }

//  /// Move away from initially dropped bubble, and make that bubble collidable.
//  void stepOutOfBubble(BubbleComponent bubbleComponent) {
//    _onDroppedBubbles.remove(bubbleComponent.bubbleModel);
//  }
}

enum PlayerMovementState { movingUp, movingDown, movingLeft, movingRight, idle }

enum Direction {
  up(Movement(0, -1)),
  down(Movement(0, 1)),
  left(Movement(-1, 0)),
  right(Movement(1, 0)),
  idle(Movement(0, 0));

  final Movement movement;

  const Direction(this.movement);
}

extension DirectionExtension on Direction {
  Vector2 get vector {
    return Vector2(movement.x, movement.y);
  }

  Direction get reverse {
    switch (this) {
      case Direction.up:
        return Direction.down;
      case Direction.down:
        return Direction.up;
      case Direction.left:
        return Direction.right;
      case Direction.right:
        return Direction.left;
      case Direction.idle:
        break;
    }
    return Direction.idle;
  }
}

class Movement {
  final double x;
  final double y;

  const Movement(this.x, this.y);
}
