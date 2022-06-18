import 'dart:math';

import 'package:candy_man/src/game/candy_man_game.dart';
import 'package:candy_man/src/joy_stick/action_controller.dart';
import 'package:candy_man/src/style/component_priority.dart';
import 'package:flame/components.dart';
import 'package:flame/palette.dart';
import 'package:flame/sprite.dart';
import 'package:flutter/material.dart';
import 'package:logging/logging.dart';

class Joystick extends PositionComponent with HasGameRef<CandyManGame> {
  static final _log = Logger('JoyStick');

  static const double _eighthOfPi = pi / 8;

  final buttonPaint = Paint()..color = Colors.deepOrangeAccent;
  final buttonPressedPaint = BasicPalette.blue.paint();
  final buttonSize = Vector2(80, 80);
  final positionOffset = 80.0;

  final ActionController actionController;

  late JoystickComponent joystick;

  Joystick({required this.actionController, debugMode = false}) {
    this.anchor = Anchor.center;
    this.debugMode = debugMode;
    this.positionType = PositionType.viewport;
    this.priority = ComponentPriority.hud;
  }

  @override
  Future<void> onLoad() async {
    super.onLoad();
    _log.info("Loading joystick");

    loadJoystick();
  }

  void loadJoystick() async {
    final image = await gameRef.images.load('joystick.png');
    final sheet = SpriteSheet.fromColumnsAndRows(
      image: image,
      columns: 6,
      rows: 1,
    );
    joystick = JoystickComponent(
      knob: SpriteComponent(
        sprite: sheet.getSpriteById(1),
        size: Vector2.all(100),
      ),
      background: SpriteComponent(
        sprite: sheet.getSpriteById(0),
        size: Vector2.all(130),
      ),
      position: Vector2(0, 0),
    );

    add(joystick);
  }

  @override
  void update(double dt) {
    super.update(dt);
    actionController.input(ActionEvent(actionType: direction));
  }

  ActionType get direction {
    if (joystick.delta.isZero()) {
      return ActionType.idle;
    }

    var knobAngle = joystick.delta.screenAngle();

    knobAngle = knobAngle < 0 ? 2 * pi + knobAngle : knobAngle;
    if (knobAngle >= 0 && knobAngle <= 2 * _eighthOfPi) {
      return ActionType.moveUp;
    } else if (knobAngle > 2 * _eighthOfPi && knobAngle <= 6 * _eighthOfPi) {
      return ActionType.moveRight;
    } else if (knobAngle > 6 * _eighthOfPi && knobAngle <= 10 * _eighthOfPi) {
      return ActionType.moveDown;
    } else if (knobAngle > 10 * _eighthOfPi && knobAngle <= 14 * _eighthOfPi) {
      return ActionType.moveLeft;
    } else if (knobAngle > 14 * _eighthOfPi) {
      return ActionType.moveUp;
    } else {
      return ActionType.idle;
    }
  }

  @override
  void onGameResize(Vector2 size) {
    super.onGameResize(size);

    this.position = Vector2(100, gameRef.canvasSize.y - 100);
  }
}
