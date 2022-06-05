import 'package:candy_man/src/elements/game_element.dart';
import 'package:vector_math/vector_math_64.dart';

typedef void OnMovementStateChange(PlayerMovementState bubbleState);

class PlayerModel extends GameElement with MovableMixin {
  PlayerMovementState _playerMovementState;

  OnMovementStateChange? _onMovementStateChange;

  Vector2 _moveDirection = Vector2.zero();

  Vector2 position;
  bool collidable;
  double speed;

  PlayerModel(
      {required this.position,
      OnMovementStateChange? onMovementStateChange,
      this.speed = 300,
      this.collidable = true})
      : _playerMovementState = PlayerMovementState.idle,
        _onMovementStateChange = onMovementStateChange;

  @override
  final ElementType elementType = ElementType.player;

  @override
  Vector2 moveTo(Vector2 newPosition) {
    position = newPosition;
    return newPosition;
  }

  PlayerMovementState get playerMovementState => _playerMovementState;

  Vector2 get moveDirection => _moveDirection;

  void walkUp() {
    _playerMovementState = PlayerMovementState.movingUp;
    _moveDirection = Vector2(0, -1);
    _onMovementStateChange?.call(_playerMovementState);
  }

  void walkDown() {
    _playerMovementState = PlayerMovementState.movingDown;
    _moveDirection = Vector2(0, 1);
    _onMovementStateChange?.call(_playerMovementState);
  }

  void walkLeft() {
    _playerMovementState = PlayerMovementState.movingLeft;
    _moveDirection = Vector2(-1, 0);
    _onMovementStateChange?.call(_playerMovementState);
  }

  void walkRight() {
    _playerMovementState = PlayerMovementState.movingRight;
    _moveDirection = Vector2(1, 0);
    _onMovementStateChange?.call(_playerMovementState);
  }

  void idle() {
    _playerMovementState = PlayerMovementState.idle;
    _moveDirection = Vector2(0, 0);
    _onMovementStateChange?.call(_playerMovementState);
  }
}

enum PlayerMovementState { movingUp, movingDown, movingLeft, movingRight, idle }
