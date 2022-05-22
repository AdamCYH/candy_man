import 'package:flame/game.dart';
import 'package:logging/logging.dart';

class CandyManGame extends FlameGame {
  static final _log = Logger('CandyManGame');

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    _log.info("Initial loading of candy man game");
  }
}
