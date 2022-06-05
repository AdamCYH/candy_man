import 'package:candy_man/src/elements/bubble_model.dart';
import 'package:candy_man/src/elements/game_element.dart';
import 'package:candy_man/src/elements/player_component.dart';
import 'package:candy_man/src/elements/player_model.dart';
import 'package:candy_man/src/game/candy_man_game.dart';
import 'package:flame/components.dart';
import 'package:flame/extensions.dart';

const cameraSafeZone = 20.0;

typedef void OnElementDestroy();

class GameWorld extends SpriteComponent with HasGameRef<CandyManGame> {
  var _players = <PlayerComponent>[];

  List<List<GameElement?>> tileMap;

  GameWorld({required this.tileMap});

  @override
  Future<void>? onLoad() async {
    super.onLoad();

    sprite = await gameRef.loadSprite('worlds/world_1.png');
    size = gameRef.worldSize;
  }

  void addMyPlayer(PlayerComponent player) {
    _players.add(player);
    add(player);
    gameRef.camera.followComponent(player,
        worldBounds: Rect.fromLTRB(
            0 - cameraSafeZone,
            0 - cameraSafeZone,
            gameRef.worldSize.x + cameraSafeZone,
            gameRef.worldSize.y + cameraSafeZone));
  }

  void addOtherPlayer(PlayerComponent player) {
    _players.add(player);
    add(player);
  }

  BubbleModel? dropBubble(PlayerModel player) {
    var indexPosition = toIndexPosition(player.position);
    var x = indexPosition[0];
    var y = indexPosition[1];
    if (tileMap[x][y] != null) {
      return null;
    }
    var bubble = BubbleModel(
        player: player,
        position: toPixelPosition(toIndexPosition(player.position)),
        onBubbleDestroy: () {
          tileMap[x][y] = null;
        },
        debugMode: player.debugMode);
    tileMap[x][y] = bubble;
    add(bubble.create());
    return bubble;
  }

  List<int> toIndexPosition(Vector2 position) {
    var x = (position.x / gameRef.gridSize.x).round();
    var y = (position.y / gameRef.gridSize.y).round();
    return [x, y];
  }

  Vector2 toPixelPosition(List<int> index) {
    return Vector2(
        index[0] * gameRef.gridSize.x, index[1] * gameRef.gridSize.y);
  }
}
