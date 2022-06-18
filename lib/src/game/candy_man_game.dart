import 'package:candy_man/src/elements/bubble_model.dart';
import 'package:candy_man/src/elements/game_element.dart';
import 'package:candy_man/src/elements/player_model.dart';
import 'package:candy_man/src/game_world/boundaries.dart';
import 'package:candy_man/src/game_world/game_world.dart';
import 'package:candy_man/src/joy_stick/action_buttons.dart';
import 'package:candy_man/src/joy_stick/action_controller.dart';
import 'package:candy_man/src/joy_stick/joy_stick.dart';
import 'package:flame/game.dart';
import 'package:flame_forge2d/flame_forge2d.dart';
import 'package:flutter/material.dart';
import 'package:logging/logging.dart';

import '../style/palette.dart';

class CandyManGame extends Forge2DGame
    with HasTappables, HasDraggables, HasCollisionDetection {
  static final _log = Logger('CandyManGame');

  final Vector2 gameGridLayout = Vector2(16, 12);
  final Palette color;
  bool debugMode;
  late Vector2 worldSize;

  late Vector2 gridSize;

  late GameWorld gameWorld;

  late List<Wall> boundaries;

  CandyManGame({required this.color, this.debugMode = false})
      : super(zoom: 5, gravity: Vector2.zero());

  @override
  Future<void> onLoad() async {
    await super.onLoad();

    _log.info("Start loading the game");

    boundaries = createBoundaries(this);
    boundaries.forEach(add);

    gameWorld = GameWorld(tileMap: _createTestTileMap());

    add(gameWorld);

    var actionController = ActionController();

    add(Joystick(actionController: actionController, debugMode: debugMode));
    add(ActionButtons(
        actionController: actionController, debugMode: debugMode));

    var playerModel = PlayerModel(
        character: 'm1',
        actionController: actionController,
        position: Vector2.zero(),
        debugMode: debugMode);

    var myPlayer = await playerModel.create();
    add(myPlayer);

    add(await BubbleModel(player: playerModel, position: Vector2(400, 190))
        .create());

    myPlayer.mounted.whenComplete(() => camera.followBodyComponent(myPlayer,
        worldBounds: Rect.fromLTRB(0 - cameraSafeZone, 0 - cameraSafeZone,
            worldSize.x + cameraSafeZone, worldSize.y + cameraSafeZone)));
  }

  @override
  Color backgroundColor() => color.backgroundPlaySession;

  @override
  void onGameResize(Vector2 size) {
    super.onGameResize(size);

    worldSize = Vector2(camera.gameSize.x,
        camera.gameSize.x / gameGridLayout.x * gameGridLayout.y);
    gridSize =
        Vector2(worldSize.x / gameGridLayout.x, worldSize.y / gameGridLayout.y);

    print('==========');
    print('World size: ' + worldSize.toString());
    print('Canvas size: ' + canvasSize.toString());
    print('on gamre resize:' + size.toString());
    print('Size: ' + this.size.toString());
    print('Camera game size: ' + camera.gameSize.toString());
    print(
        'Viewport effective size: ' + camera.viewport.effectiveSize.toString());
  }

  List<List<GameElement?>> _createTestTileMap() {
    var tileMap = <List<GameElement?>>[];
    for (int i = 0; i < gameGridLayout.x; i++) {
      var row = <GameElement?>[];
      for (int j = 0; j < gameGridLayout.y; j++) {
        row.add(null);
      }
      tileMap.add(row);
    }

    return tileMap;
  }
}
