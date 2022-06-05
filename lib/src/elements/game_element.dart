import 'package:flame/components.dart';

/**
 * Elements that can be displayed on a game world.
 */
abstract class GameElement {
  Vector2 get position;

  ElementType get elementType;

  bool get collidable;

  /**
   * Creates flame component from element model.
   */
  Component create();
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
  /**
   * Move to a new position.
   */
  Vector2 moveTo(Vector2 newPosition);

  /**
   * Move for dt seconds.
   */
  Vector2 moveFor(double dt);
}

/**
 * Mixin for elements that have a countdown.
 */
mixin CountDownMixin on GameElement {
  void countDown(double dt);
}
