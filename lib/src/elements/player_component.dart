import 'package:candy_man/src/elements/player_animation.dart';
import 'package:candy_man/src/elements/player_model.dart';
import 'package:candy_man/src/game/candy_man_game.dart';
import 'package:candy_man/src/game_world/game_world.dart';
import 'package:candy_man/src/joy_stick/action_controller.dart';
import 'package:flame_forge2d/flame_forge2d.dart';

class PlayerComponent extends BodyComponent<CandyManGame> {
  final PlayerModel playerModel;

  late final PlayerAnimation animation;

  IndexPosition indexPosition;

  ActionType? _previousAction;

  late BodyDef bodyDef;

  PlayerComponent({
    required this.playerModel,
    this.indexPosition = const IndexPosition(0, 0),
    debugMode = false,
  }) {
    print('Initiate player component');
    this.debugMode = debugMode;
    renderBody = false;

    animation = PlayerAnimation(character: playerModel.character);
  }

  @override
  Future<void> onLoad() async {
    super.onLoad();
    print('Loading player component');

    add(animation);

    playerModel.actionController.onFire.listen((event) {
      if (_previousAction == event.actionType) return;
      print('trigger joystick ' + event.actionType.toString());
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
//          playerModel.dropBubble(gameRef.gameWorld);
          return;
        default:
          playerModel.idle();
          return;
      }
    });
  }

  @override
  Body createBody() {
    print('Creating player body');
    final shape = CircleShape()..radius = animation.size.x / 2;
    final fixtureDef = FixtureDef(
      shape,
      userData: playerModel, // To be able to determine object in collision
      restitution: 0,
      density: 0,
      friction: 1,
    );

    bodyDef = BodyDef(
      position: _toPixelPosition(indexPosition),
      linearVelocity: Vector2.zero(),
      type: BodyType.dynamic,
    );

    return world.createBody(bodyDef)..createFixture(fixtureDef);
  }

  Vector2 _toPixelPosition(IndexPosition index) {
    return Vector2(index.x * gameRef.gridSize.x + gameRef.gridSize.x / 2,
        index.y * gameRef.gridSize.y + gameRef.gridSize.y / 2);
  }
}
