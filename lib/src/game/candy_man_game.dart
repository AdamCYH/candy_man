import 'package:candy_man/src/elements/game_element.dart';
import 'package:candy_man/src/elements/player_model.dart';
import 'package:candy_man/src/game_world/game_world.dart';
import 'package:candy_man/src/joy_stick/action_buttons.dart';
import 'package:candy_man/src/joy_stick/action_controller.dart';
import 'package:candy_man/src/joy_stick/joy_stick.dart';
import 'package:flame/game.dart';
import 'package:flame/palette.dart';
import 'package:flutter/material.dart';
import 'package:logging/logging.dart';

import '../style/palette.dart';

class CandyManGame extends FlameGame
    with HasTappables, HasDraggables, HasCollisionDetection {
  static final _log = Logger('CandyManGame');

  final Vector2 gameGridLayout = Vector2(16, 12);
  final Palette color;
  bool debugMode;
  late Vector2 worldSize;

  late Vector2 gridSize;

  late GameWorld gameWorld;

  CandyManGame({required this.color, this.debugMode = false});

  @override
  Future<void> onLoad() async {
    await super.onLoad();

    _log.info("Start loading the game");

    onGameResize(this.size);

    gameWorld = GameWorld(tileMap: _createTestTileMap());

    add(gameWorld);

    var actionController = ActionController();

    var player = PlayerModel(
        character: 'm1',
        actionController: actionController,
        position: Vector2.zero(),
        debugMode: true);

    gameWorld.addMyPlayer(player.create());
    add(Joystick(actionController: actionController, debugMode: debugMode));
    add(ActionButtons(
        actionController: actionController, debugMode: debugMode));
  }

  @override
  Color backgroundColor() => color.backgroundPlaySession;

  @override
  void onGameResize(Vector2 size) {
    super.onGameResize(size);

    worldSize = Vector2(size.x, size.x / gameGridLayout.x * gameGridLayout.y);
    gridSize =
        Vector2(worldSize.x / gameGridLayout.x, worldSize.y / gameGridLayout.y);
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
