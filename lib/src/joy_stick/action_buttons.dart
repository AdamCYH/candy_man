import 'package:candy_man/src/game/candy_man_game.dart';
import 'package:candy_man/src/joy_stick/action_controller.dart';
import 'package:flame/components.dart';
import 'package:flame/input.dart';
import 'package:flutter/material.dart';

class ActionButtons extends PositionComponent with HasGameRef<CandyManGame> {
  final buttonPaint = Paint()..color = Colors.lightBlue;
  final ActionController actionController;

  ActionButtons({required this.actionController, bool debugMode = false}) {
    super.debugMode = debugMode;
  }

  @override
  Future<void> onLoad() async {
    super.onLoad();
    add(_dropBubbleButton());
  }

  ButtonComponent _dropBubbleButton() {
    return ButtonComponent(
        button: CircleComponent(radius: 30, paint: buttonPaint),
        onPressed: () => actionController
            .input(ActionEvent(actionType: ActionType.dropBubble)));
  }

  @override
  void onGameResize(Vector2 size) {
    super.onGameResize(size);
    super.position = Vector2(gameRef.size.x - 200, gameRef.size.y - 200);
  }
}
