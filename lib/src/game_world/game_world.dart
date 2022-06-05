import 'package:candy_man/src/elements/bubble_model.dart';
import 'package:candy_man/src/elements/game_element.dart';
import 'package:candy_man/src/elements/player_component.dart';
import 'package:candy_man/src/elements/player_model.dart';
import 'package:candy_man/src/game/candy_man_game.dart';
import 'package:flame/components.dart';
import 'package:flame/extensions.dart';

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
        worldBounds:
            Rect.fromLTRB(0, 0, gameRef.worldSize.x, gameRef.worldSize.y));
  }

  void addOtherPlayer(PlayerComponent player) {
    _players.add(player);
    add(player);
  }

  void dropBubble(PlayerModel player) {
    var bubble = BubbleModel(player: player, position: player.position);
    add(bubble.create());
  }
}
