import 'package:candy_man/src/game/candy_man_game.dart';
import 'package:candy_man/src/joy_stick/joy_stick_controller.dart';
import 'package:flame/components.dart';
import 'package:flame/palette.dart';
import 'package:flame/sprite.dart';
import 'package:flutter/material.dart';
import 'package:logging/logging.dart';

class Joystick extends PositionComponent with HasGameRef<CandyManGame> {
  static final _log = Logger('JoyStick');

  final buttonPaint = Paint()..color = Colors.deepOrangeAccent;
  final buttonPressedPaint = BasicPalette.blue.paint();
  final buttonSize = Vector2(80, 80);
  final positionOffset = 80.0;

  final JoystickController joystickController;

  late JoystickComponent joystick;

  Joystick({required this.joystickController, debugMode = false}) {
    super.anchor = Anchor.center;
    super.debugMode = debugMode;
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
        size: Vector2.all(150),
      ),
      position: Vector2(0, 0),
    );

    add(joystick);
  }

  @override
  void update(double dt) {
    super.update(dt);
    joystickController
        .input(JoyStickEvent(direction: mapDirection(joystick.direction)));
  }

  Direction mapDirection(JoystickDirection joystickDirection) {
    switch (joystickDirection) {
      case JoystickDirection.up:
        return Direction.up;
      case JoystickDirection.down:
        return Direction.down;
      case JoystickDirection.left:
        return Direction.left;
      case JoystickDirection.right:
        return Direction.right;
      case JoystickDirection.upLeft:
      case JoystickDirection.upRight:
      case JoystickDirection.downLeft:
      case JoystickDirection.downRight:
      case JoystickDirection.idle:
        return Direction.idle;
    }
  }

  @override
  void onGameResize(Vector2 size) {
    super.onGameResize(size);
    super.position = Vector2(100, gameRef.size.y - 100);
  }
}
