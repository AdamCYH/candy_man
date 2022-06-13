import 'dart:ui';

import 'package:candy_man/src/elements/bubble_animation.dart';
import 'package:candy_man/src/elements/bubble_model.dart';
import 'package:candy_man/src/game/candy_man_game.dart';
import 'package:flame_forge2d/flame_forge2d.dart';
import 'package:logging/logging.dart';

class BubbleComponent extends BodyComponent<CandyManGame> {
  static final _log = Logger('BubbleComponent');

  final BubbleModel bubbleModel;

  late final BubbleAnimation animation;

  BubbleComponent({
    required this.bubbleModel,
    debugMode = false,
  }) {
    _log.info('Initiate bubble component');
    this.debugMode = debugMode;
    this.debugColor = Color.fromRGBO(0, 0, 0, 0.5);
    renderBody = false;

    animation = BubbleAnimation(debugMode: debugMode);
  }

  @override
  Future<void> onLoad() async {
    super.onLoad();
    _log.info('Loading bubble component');

    add(animation);
  }

  @override
  void update(double dt) {
    super.update(dt);

    bubbleModel.countDown(dt);
  }

  @override
  Body createBody() {
    final shape = PolygonShape()
      ..setAsBoxXY(gameRef.gridSize.x / 2 * 0.9, gameRef.gridSize.y / 2 * 0.9);
    final fixtureDef = FixtureDef(shape, userData: bubbleModel, isSensor: true);

    final bodyDef = BodyDef(
      position: bubbleModel.position,
      type: BodyType.static,
    );

    return world.createBody(bodyDef)..createFixture(fixtureDef);
  }

  void makeColliable() {
    body.fixtures[0].setSensor(false);
  }
}
