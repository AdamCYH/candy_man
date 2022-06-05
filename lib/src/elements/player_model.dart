import 'package:candy_man/src/elements/bubble_component.dart';
import 'package:candy_man/src/elements/bubble_model.dart';
import 'package:candy_man/src/elements/game_element.dart';
import 'package:candy_man/src/elements/player_component.dart';
import 'package:candy_man/src/game_world/game_world.dart';
import 'package:candy_man/src/joy_stick/action_controller.dart';
import 'package:flame/components.dart';
import 'package:logging/logging.dart';
import 'package:vector_math/vector_math_64.dart';

class PlayerModel extends GameElement with MovableMixin {
  static final _log = Logger('CandyManGame');

  final String character;
  final ActionController actionController;

  PlayerMovementState _playerMovementState;

  Direction _moveDirection = Direction.idle;

  bool debugMode;
  Vector2 position;
  bool collidable;
  double speed;

  Vector2? boundary;

  PlayerComponent? component;

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
  PlayerComponent create() {
    _log.info('Creating player component');
    component = PlayerComponent(playerModel: this, debugMode: debugMode);
    return component!;
  }

  @override
  Vector2 moveTo(Vector2 newPosition) {
    if (_canMoveTo(newPosition)) {
      position = newPosition;
    }
    return position;
  }

  Vector2 moveFor(double dt) {
    if (moveDirection == Direction.idle ||
        _collisions.containsValue(moveDirection)) {
      return position;
    }
    return moveTo(position + moveDirection.vector.normalized() * speed * dt);
  }

  PlayerMovementState get playerMovementState => _playerMovementState;

  Direction get moveDirection => _moveDirection;

  void walkUp() {
    _playerMovementState = PlayerMovementState.movingUp;
    _moveDirection = Direction.up;
    component?.updateMovementState(_playerMovementState);
  }

  void walkDown() {
    _playerMovementState = PlayerMovementState.movingDown;
    _moveDirection = Direction.down;
    component?.updateMovementState(_playerMovementState);
  }

  void walkLeft() {
    _playerMovementState = PlayerMovementState.movingLeft;
    _moveDirection = Direction.left;
    component?.updateMovementState(_playerMovementState);
  }

  void walkRight() {
    _playerMovementState = PlayerMovementState.movingRight;
    _moveDirection = Direction.right;
    component?.updateMovementState(_playerMovementState);
  }

  void idle() {
    _playerMovementState = PlayerMovementState.idle;
    _moveDirection = Direction.idle;
    component?.updateMovementState(_playerMovementState);
  }

  void collisionStart(GameElement model) {
    if (!_onDroppedBubbles.contains(model)) {
      _collisions[model] = moveDirection;
    }
  }

  void collisionEnd(GameElement model) {
    _collisions.remove(model);
  }

  void dropBubble(GameWorld gameWorld) {
    var bubble = gameWorld.dropBubble(this);
    if (bubble != null) {
      _onDroppedBubbles.add(bubble);
    }
  }

  /// Move away from initially dropped bubble, and make that bubble collidable.
  void stepOutOfBubble(BubbleComponent bubbleComponent) {
    _onDroppedBubbles.remove(bubbleComponent.bubbleModel);
  }

  bool _canMoveTo(Vector2 position) {
    if (boundary == null) return true;
    return position.x >= 0 &&
        position.x <= boundary!.x &&
        position.y >= 0 &&
        position.y <= boundary!.y;
  }
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
}

class Movement {
  final double x;
  final double y;

  const Movement(this.x, this.y);
}
