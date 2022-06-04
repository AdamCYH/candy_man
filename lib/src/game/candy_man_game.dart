import 'package:candy_man/src/joy_stick/action_buttons.dart';
import 'package:candy_man/src/joy_stick/action_controller.dart';
import 'package:candy_man/src/joy_stick/joy_stick.dart';
import 'package:candy_man/src/player/player.dart';
import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:flame/palette.dart';
import 'package:flutter/material.dart';
import 'package:logging/logging.dart';

import '../style/palette.dart';

class CandyManGame extends FlameGame with HasTappables, HasDraggables {
  static final _log = Logger('CandyManGame');

  final Palette color;
  final Vector2 gridSize = Vector2(70, 70);
  bool debugMode;

  CandyManGame({required this.color, this.debugMode = false});

  @override
  Future<void> onLoad() async {
    await super.onLoad();

    _log.info("Start loading the game");

    var actionController = ActionController();
    var player = Player(
        character: "m1",
        actionController: actionController,
        gridSize: gridSize,
        debugMode: debugMode);

    add(player);
    add(Joystick(actionController: actionController, debugMode: debugMode));
    add(ActionButtons(
        actionController: actionController, debugMode: debugMode));

  }

  @override
  Color backgroundColor() => color.backgroundPlaySession;
}
