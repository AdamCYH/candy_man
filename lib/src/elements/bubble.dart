import 'package:candy_man/src/game/candy_man_game.dart';
import 'package:candy_man/src/player/player.dart';
import 'package:flame/components.dart';

class Bubble extends SpriteAnimationComponent with HasGameRef<CandyManGame> {
  final bool debugMode;

  final Player player;
  final Vector2 gridSize;

  Timer? timer;

  BubbleState? bubbleState;

  late SpriteAnimation _pendingBubbleAnimation;

  late SpriteAnimation _blowingBubbleAnimation;

  @override
  Future<void> onLoad() async {
    super.onLoad();
    await _loadAnimations();

    this.position = player.position;
    this.size = gridSize;
  }

  Bubble.dropByPlayer(
      {required this.player, required this.gridSize, this.debugMode = false}) {
    this.debugMode = debugMode;

    bubbleState = BubbleState.pending;
    timer = Timer(2, onTick: () => bubbleState = BubbleState.destroyed);
    timer?.start();
  }

  @override
  void update(double dt) {
    super.update(dt);

    timer?.update(dt);
    if (timer != null &&
        timer!.progress > 0.8 &&
        bubbleState == BubbleState.pending) {
      bubbleState = BubbleState.blowing;
    }

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
  }
}

enum BubbleState {
  pending,
  blowing,
  destroyed,
}
