import 'package:candy_man/src/game/candy_man_game.dart';
import 'package:candy_man/src/joy_stick/action_controller.dart';
import 'package:candy_man/src/style/component_priority.dart';
import 'package:flame/components.dart';
import 'package:flame/input.dart';
import 'package:flutter/material.dart';

class ActionButtons extends PositionComponent with HasGameRef<CandyManGame> {
  final buttonPaint = Paint()..color = Colors.lightBlue;
  final ActionController actionController;

  ActionButtons({required this.actionController, bool debugMode = false}) {
    this.debugMode = debugMode;
    this.anchor = Anchor.center;
    this.positionType = PositionType.viewport;
    this.priority = ComponentPriority.hud;
  }

  @override
  Future<void> onLoad() async {
    super.onLoad();

    add(_dropBubbleButton());
  }

  HudButtonComponent _dropBubbleButton() {
    return HudButtonComponent(
        anchor: Anchor.center,
        button: CircleComponent(radius: 30, paint: buttonPaint),
        position: Vector2(0, 0),
        onPressed: () => actionController
            .input(ActionEvent(actionType: ActionType.dropBubble)));
  }

  @override
  void onGameResize(Vector2 size) {
    super.onGameResize(size);

    this.position =
        Vector2(gameRef.canvasSize.x - 200, gameRef.canvasSize.y - 200);
  }
}
