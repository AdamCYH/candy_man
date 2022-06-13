import 'package:candy_man/src/elements/bubble_model.dart';
import 'package:candy_man/src/elements/game_element.dart';
import 'package:candy_man/src/elements/player_animation.dart';
import 'package:candy_man/src/elements/player_component.dart';
import 'package:candy_man/src/elements/player_model.dart';
import 'package:candy_man/src/game/candy_man_game.dart';
import 'package:flame/components.dart';

const cameraSafeZone = 20.0;

typedef OnElementDestroy = void Function(GameElement gameElement);

class GameWorld extends SpriteComponent with HasGameRef<CandyManGame> {
  var _players = <PlayerComponent>[];

  List<List<GameElement?>> tileMap;

  Vector2? boundary;

  GameWorld({required this.tileMap});

  @override
  Future<void>? onLoad() async {
    super.onLoad();

    sprite = await gameRef.loadSprite('worlds/world_1.png');
    size = gameRef.worldSize;

    setBoundary();
  }

  @override
  void onGameResize(Vector2 size) {
    super.onGameResize(size);

    this.size = gameRef.gridSize;
    setBoundary();
  }

  void addMyPlayer(PlayerComponent player) {
    _players.add(player);
    add(player);
//    gameRef.camera.followBodyComponent(player,
//        worldBounds: Rect.fromLTRB(
//            0 - cameraSafeZone,
//            0 - cameraSafeZone,
//            gameRef.worldSize.x + cameraSafeZone,
//            gameRef.worldSize.y + cameraSafeZone));
  }

  void addOtherPlayer(PlayerAnimation player) {
//    _players.add(player);
    add(player);
  }

  Future<BubbleModel?> dropBubble(PlayerModel player) async {
    var indexPosition = toIndexPosition(player.position);
    var x = indexPosition.x;
    var y = indexPosition.y;
    if (tileMap[x][y] != null) {
      return null;
    }
    var bubble = BubbleModel(
        player: player,
        position: toPixelPosition(toIndexPosition(player.position)),
        onBubbleDestroy: (_) {
          tileMap[x][y] = null;
        },
        debugMode: player.debugMode);
    tileMap[x][y] = bubble;
    add(await bubble.create());
    return bubble;
  }

  IndexPosition toIndexPosition(Vector2 position) {
    var x = (position.x / gameRef.gridSize.x).floor();
    var y = (position.y / gameRef.gridSize.y).floor();
    return IndexPosition(x, y);
  }

  Vector2 toPixelPosition(IndexPosition index) {
    return Vector2(index.x * gameRef.gridSize.x + gameRef.gridSize.x / 2,
        index.y * gameRef.gridSize.y + gameRef.gridSize.y / 2);
  }

  void setBoundary() {
    boundary = Vector2(gameRef.worldSize.x - gameRef.gridSize.x,
        gameRef.worldSize.y - gameRef.gridSize.y);
  }
}

class IndexPosition {
  final int x;
  final int y;

  const IndexPosition(this.x, this.y);

  @override
  String toString() {
    return '$x $y';
  }
}
