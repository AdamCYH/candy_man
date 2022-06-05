import 'package:flame/game.dart';

/**
 * Elements that can be displayed on a game world.
 */
abstract class GameElement {
  Vector2 get position;

  ElementType get elementType;

  bool get collidable;
}

enum ElementType {
  player,
  bubble,
  obstacle,
  movable_obstacle,
}

/**
 * Mixin for elements that can move.
 */
mixin MovableMixin on GameElement {
  Vector2 moveTo(Vector2 newPosition);
}

/**
 * Mixin for elements that have a countdown.
 */
mixin CountDownMixin on GameElement {
  void countDown(double dt);
}
