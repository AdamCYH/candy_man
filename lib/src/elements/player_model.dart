import 'package:candy_man/src/elements/game_element.dart';
import 'package:candy_man/src/elements/player_component.dart';
import 'package:candy_man/src/joy_stick/action_controller.dart';
import 'package:flame/components.dart';
import 'package:logging/logging.dart';
import 'package:vector_math/vector_math_64.dart';

class PlayerModel extends GameElement with MovableMixin {
  static final _log = Logger('CandyManGame');

  final String character;
  final ActionController actionController;

  PlayerMovementState _playerMovementState;

  Vector2 _moveDirection = Vector2.zero();

  bool debugMode;
  Vector2 position;
  bool collidable;
  double speed;

  Vector2? boundary;

  PlayerComponent? player;

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
    player = PlayerComponent(playerModel: this, debugMode: debugMode);
    return player!;
  }

  @override
  Vector2 moveTo(Vector2 newPosition) {
    throw UnsupportedError("moveTo should not be called in player model.");
  }

  @override
  Vector2 moveFor(double dt) {
    var toPosition = position + moveDirection.normalized() * speed * dt;

    if (_canMoveTo(toPosition)) {
      position = toPosition;
    }

    return position;
  }

  bool _canMoveTo(Vector2 position) {
    if (boundary == null) return true;
    return position.x >= 0 &&
        position.x <= boundary!.x &&
        position.y >= 0 &&
        position.y <= boundary!.y;
  }

  PlayerMovementState get playerMovementState => _playerMovementState;

  Vector2 get moveDirection => _moveDirection;

  void walkUp() {
    _playerMovementState = PlayerMovementState.movingUp;
    _moveDirection = Vector2(0, -1);
    player?.updateMovementState(_playerMovementState);
  }

  void walkDown() {
    _playerMovementState = PlayerMovementState.movingDown;
    _moveDirection = Vector2(0, 1);
    player?.updateMovementState(_playerMovementState);
  }

  void walkLeft() {
    _playerMovementState = PlayerMovementState.movingLeft;
    _moveDirection = Vector2(-1, 0);
    player?.updateMovementState(_playerMovementState);
  }

  void walkRight() {
    _playerMovementState = PlayerMovementState.movingRight;
    _moveDirection = Vector2(1, 0);
    player?.updateMovementState(_playerMovementState);
  }

  void idle() {
    _playerMovementState = PlayerMovementState.idle;
    _moveDirection = Vector2(0, 0);
    player?.updateMovementState(_playerMovementState);
  }

  void dropBubble() {}
}

enum PlayerMovementState { movingUp, movingDown, movingLeft, movingRight, idle }
