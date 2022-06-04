import 'package:candy_man/src/elements/bubble.dart';
import 'package:candy_man/src/game/candy_man_game.dart';
import 'package:candy_man/src/player/player.dart';
import 'package:flame/components.dart';
import 'package:flame/extensions.dart';

class GameWorld extends SpriteComponent with HasGameRef<CandyManGame> {
  List<Player> players;

  GameWorld({this.players = const []});

  @override
  Future<void>? onLoad() async {
    super.onLoad();

    sprite = await gameRef.loadSprite('worlds/world_1.png');
    size = gameRef.worldSize;

    players.forEach((player) {
      add(player);
    });
  }

  void addMyPlayer(Player player) {
    add(player);
    gameRef.camera.followComponent(player,
        worldBounds: Rect.fromLTRB(0, 0, gameRef.worldSize.x, gameRef.worldSize.y));
  }

  void addOtherPlayer(Player player) {
    add(player);
  }

  void dropBubble(Bubble bubble) {
    add(bubble);
  }
}
