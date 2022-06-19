import 'package:flame_forge2d/flame_forge2d.dart';

enum Direction {
  up(Movement(0, -1)),
  down(Movement(0, 1)),
  left(Movement(-1, 0)),
  right(Movement(1, 0)),
  idle(Movement(0, 0));

  final Movement movement;

  const Direction(this.movement);
}

extension DirectionExtension on Direction {
  Vector2 get vector {
    return Vector2(movement.x, movement.y);
  }

  Direction get reverse {
    switch (this) {
      case Direction.up:
        return Direction.down;
      case Direction.down:
        return Direction.up;
      case Direction.left:
        return Direction.right;
      case Direction.right:
        return Direction.left;
      case Direction.idle:
        break;
    }
    return Direction.idle;
  }
}

class Movement {
  final double x;
  final double y;

  const Movement(this.x, this.y);
}

class IndexPosition {
  final int x;
  final int y;

  const IndexPosition(this.x, this.y);

  IndexPosition add(Direction direction) {
    return IndexPosition(
        x + direction.movement.x.toInt(), y + direction.movement.y.toInt());
  }

  @override
  String toString() {
    return '$x $y';
  }
}
