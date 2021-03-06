import 'package:candy_man/src/elements/bubble_model.dart';
import 'package:candy_man/src/game/candy_man_game.dart';
import 'package:flame/components.dart';
import 'package:logging/logging.dart';

class BubbleAnimation extends SpriteAnimationComponent
    with HasGameRef<CandyManGame> {
  static final _log = Logger('BubbleAnimation');

  late SpriteAnimation _pendingBubbleAnimation;

  late SpriteAnimation _blowingBubbleAnimation;

  final bool debugMode;

  BubbleAnimation({this.debugMode = false});

  @override
  Future<void> onLoad() async {
    super.onLoad();
    _log.info('Loading bubble animiation');

    this.size = gameRef.gridSize;
    this.anchor = Anchor.center;

    await _loadAnimations();
  }

  void updateBubbleStateChange(BubbleState bubbleState) {
    switch (bubbleState) {
      case BubbleState.pending:
        animation = _pendingBubbleAnimation;
        return;
      case BubbleState.blowing:
        animation = _blowingBubbleAnimation;
        return;
      case BubbleState.destroyed:
        removeFromParent();
        return;
      default:
        return;
    }
  }

  Future<void> _loadAnimations() async {
    final spriteSheet = await gameRef.images.load('bubble.png');

    _pendingBubbleAnimation = SpriteAnimation.fromFrameData(
        spriteSheet,
        SpriteAnimationData.sequenced(
            textureSize: Vector2.all(177.0),
            amount: 2,
            stepTime: 0.1,
            amountPerRow: 2));

    _blowingBubbleAnimation = SpriteAnimation.fromFrameData(
        spriteSheet,
        SpriteAnimationData.sequenced(
            textureSize: Vector2.all(177.0),
            amount: 9,
            stepTime: 0.05,
            amountPerRow: 3,
            loop: false));

    animation = _pendingBubbleAnimation;
  }
}
