import 'package:candy_man/src/elements/explosion_model.dart';
import 'package:candy_man/src/game/candy_man_game.dart';
import 'package:flame_forge2d/flame_forge2d.dart';
import 'package:flutter/material.dart';

class ExplosionComponent extends BodyComponent<CandyManGame> {
  final ExplosionModel explosionModel;

  ExplosionComponent({required this.explosionModel});

  @override
  Body createBody() {
    this.paint = Paint()..color = Colors.lightBlueAccent;
    final shape = explosionModel.isVertical
        ? _verticalExplosion()
        : _horizontalExplosion();
    final fixtureDef =
        FixtureDef(shape, userData: explosionModel);

    final bodyDef = BodyDef(
      position: explosionModel.position,
      type: BodyType.static,
    );

    return world.createBody(bodyDef)..createFixture(fixtureDef);
  }

  Shape _horizontalExplosion() {
    return PolygonShape()
      ..setAsBoxXY(gameRef.gridSize.x / 2, gameRef.gridSize.y / 3);
  }

  Shape _verticalExplosion() {
    return PolygonShape()
      ..setAsBoxXY(gameRef.gridSize.x / 3, gameRef.gridSize.y / 2);
  }
}
