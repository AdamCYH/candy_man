import 'package:candy_man/src/elements/bubble_model.dart';
import 'package:candy_man/src/elements/direction.dart';
import 'package:candy_man/src/elements/explosion_model.dart';
import 'package:candy_man/src/elements/player_animation.dart';
import 'package:candy_man/src/elements/player_component.dart';
import 'package:candy_man/src/elements/player_model.dart';
import 'package:candy_man/src/game/candy_man_game.dart';
import 'package:candy_man/src/game_world/map.dart';
import 'package:flame/components.dart';

const cameraSafeZone = 5.0;

class GameWorld extends SpriteComponent with HasGameRef<CandyManGame> {
  final _players = <PlayerComponent>[];

  GameMap tileMap;

  Vector2? boundary;

  GameWorld({required this.tileMap});

  @override
  Future<void>? onLoad() async {
    super.onLoad();

    sprite = await gameRef.loadSprite('worlds/world_1.png');
    size = gameRef.worldSize;
  }

  @override
  void onGameResize(Vector2 size) {
    super.onGameResize(size);

    this.size = gameRef.worldSize;
  }

  void addMyPlayer(PlayerComponent player) {
    _players.add(player);
    add(player);
  }

  void addOtherPlayer(PlayerAnimation player) {
//    _players.add(player);
    add(player);
  }

  Future<BubbleModel?> dropBubble(PlayerModel player) async {
    final indexPosition = toIndexPosition(player.position);
    final x = indexPosition.x;
    final y = indexPosition.y;
    if (tileMap.get(x, y) != null) {
      return null;
    }

    var explosions = <ExplosionModel>[];

    final bubble = BubbleModel(
        player: player,
        position: toPixelPosition(indexPosition),
        onBubbleCountDownEnd: (bubble) {
          explosions = _explode(bubble, indexPosition);
          explosions
              .forEach((explosion) async => add(await explosion.create()));
        },
        onBubbleDestroy: (_) {
          tileMap.set(x, y, null);
          explosions.forEach((explosion) {
            remove(explosion.component!);
          });
        },
        debugMode: player.debugMode);
    tileMap.set(x, y, bubble);
    add(await bubble.create());
    return bubble;
  }

  IndexPosition toIndexPosition(Vector2 position) {
    final x = (position.x / gameRef.gridSize.x).floor();
    final y = (position.y / gameRef.gridSize.y).floor();
    return IndexPosition(x, y);
  }

  Vector2 toPixelPosition(IndexPosition index) {
    return Vector2(index.x * gameRef.gridSize.x + gameRef.gridSize.x / 2,
        index.y * gameRef.gridSize.y + gameRef.gridSize.y / 2);
  }

  List<ExplosionModel> _explode(
      BubbleModel bubble, IndexPosition indexPosition) {
    final explosions = <ExplosionModel>[];
    for (final direction in bubbleDirections) {
      var step = 1;
      var targetPosition = indexPosition.add(direction);
      while (step <= bubble.player.bubblePower &&
          tileMap.isInBoundary(targetPosition.x, targetPosition.y)) {
        final explosion = ExplosionModel(
            position: toPixelPosition(targetPosition),
            isVertical: direction.isVertical);
        explosions.add(explosion);

        step++;
        targetPosition = targetPosition.add(direction);
      }
    }
    return explosions;
  }
}
