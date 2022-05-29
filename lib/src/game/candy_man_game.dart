import 'package:candy_man/src/joy_stick/joy_stick_component.dart';
import 'package:candy_man/src/joy_stick/joy_stick_controller.dart';
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

  CandyManGame({required this.color, this.debugMode = false});

  @override
  Future<void> onLoad() async {
    await super.onLoad();

    _log.info("Start loading the game");

    var joystickController = JoystickController();
    var player = Player(
        character: "m1",
        joystickController: joystickController,
        debugMode: debugMode);

    add(player);
    add(Joystick(joystickController: joystickController, debugMode: debugMode));
  }

  @override
  Color backgroundColor() => color.backgroundPlaySession;
}
