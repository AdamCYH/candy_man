import 'package:candy_man/src/elements/direction.dart';
import 'package:candy_man/src/elements/explosion_model.dart';
import 'package:candy_man/src/elements/game_element.dart';
import 'package:candy_man/src/elements/player_component.dart';
import 'package:candy_man/src/game_world/game_world.dart';
import 'package:candy_man/src/joy_stick/action_controller.dart';
import 'package:flame_forge2d/flame_forge2d.dart';
import 'package:logging/logging.dart';

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
  int bubblePower;

  late final PlayerComponent component;

  PlayerModel(
      {required this.character,
      required this.actionController,
      required this.position,
      this.speed = 50,
      this.bubblePower = 3,
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

  Future<void> dropBubble(GameWorld gameWorld) async {
    await gameWorld.dropBubble(this);
  }
}

enum PlayerMovementState { movingUp, movingDown, movingLeft, movingRight, idle }
