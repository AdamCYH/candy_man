import 'package:candy_man/src/elements/game_element.dart';

class GameMap {
  List<List<GameElement?>> tileMap;

  GameMap({required this.tileMap})
      : assert(tileMap.isNotEmpty),
        assert(tileMap[0].isNotEmpty);

  GameElement? get(int x, int y) {
    return tileMap[y][x];
  }

  GameElement? set(int x, int y, GameElement? element) {
    tileMap[y][x] = element;
    return element;
  }

  int get width => tileMap[0].length;

  int get height => tileMap.length;

  bool isInBoundary(int x, int y) {
    return x >= 0 && x < width && y >= 0 && y < height;
  }
}
