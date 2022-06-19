import 'package:flame/components.dart';

/**
 * Elements that can be displayed on a game world.
 */
abstract class GameElement {
  Component? get component;

  Vector2 get position;

  ElementType get elementType;

  bool get collidable;

  /**
   * Creates flame component from element model.
   */
  Future<Component> create();
}

enum ElementType {
  player,
  bubble,
  explosion,
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
  Vector2 moveTo({required Vector2 newPosition, CanMoveTo? canMoveTo});
}

/**
 * Mixin for elements that have a countdown.
 */
mixin CountDownMixin on GameElement {
  void countDown(double dt);
}

typedef CanMoveTo = bool Function(Vector2 position);

typedef OnElementDestroy = void Function(GameElement gameElement);