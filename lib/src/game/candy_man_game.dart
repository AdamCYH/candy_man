import 'package:candy_man/src/game_world/game_world.dart';
import 'package:candy_man/src/joy_stick/action_buttons.dart';
import 'package:candy_man/src/joy_stick/action_controller.dart';
import 'package:candy_man/src/joy_stick/joy_stick.dart';
import 'package:candy_man/src/player/player.dart';
import 'package:flame/game.dart';
import 'package:flame/palette.dart';
import 'package:flutter/material.dart';
import 'package:logging/logging.dart';

import '../style/palette.dart';

class CandyManGame extends FlameGame with HasTappables, HasDraggables {
  static final _log = Logger('CandyManGame');

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

    gameWorld = GameWorld();

    add(gameWorld);

    var actionController = ActionController();
    var player = Player(
        character: "m1",
        actionController: actionController,
        gridSize: gridSize,
        debugMode: debugMode);

    gameWorld.addMyPlayer(player);
    add(Joystick(actionController: actionController, debugMode: debugMode));
    add(ActionButtons(
        actionController: actionController, debugMode: debugMode));
  }

  @override
  Color backgroundColor() => color.backgroundPlaySession;

  @override
  void onGameResize(Vector2 size) {
    super.onGameResize(size);

    worldSize = Vector2(size.x, size.x / 4 * 3);
    gridSize = Vector2(worldSize.x / 16, worldSize.y / 12);
  }
}
