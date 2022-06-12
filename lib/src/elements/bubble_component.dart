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
    print('Loading bbbb comp');

    add(animation);
  }

  @override
  void update(double dt) {
    super.update(dt);

    bubbleModel.countDown(dt);
  }

  @override
  Body createBody() {
    print('Creating bubble body');
    print(animation);
    print(animation.size);
    final shape = PolygonShape()
      ..setAsBoxXY(gameRef.gridSize.x / 2 * 0.8, gameRef.gridSize.y / 2 * 0.8);
    final fixtureDef = FixtureDef(
      shape,
      userData: bubbleModel, // To be able to determine object in collision
    );

    final bodyDef = BodyDef(
      position: bubbleModel.position,
      linearVelocity: Vector2.zero(),
      type: BodyType.static,
    );

    return world.createBody(bodyDef)..createFixture(fixtureDef);
  }
}
