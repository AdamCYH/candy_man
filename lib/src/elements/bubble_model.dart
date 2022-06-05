import 'package:candy_man/src/elements/game_element.dart';
import 'package:candy_man/src/elements/player.dart';
import 'package:flame/components.dart';

typedef void OnBubbleStateChange(BubbleState bubbleState);

class BubbleModel extends GameElement with CountDownMixin {
  static const explosionDuration = 0.5;

  BubbleState _bubbleState;

  OnBubbleStateChange? _onBubbleStateChange;

  late Timer _countDownTimer;

  late Timer _explosionTimer;

  Player player;

  BubbleModel({
    required this.player,
    required this.position,
    OnBubbleStateChange? onBubbleStateChange,
    countDown = 2.0,
  })  : _onBubbleStateChange = onBubbleStateChange,
        _bubbleState = BubbleState.pending {
    _countDownTimer =
        Timer(countDown, onTick: () => {bubbleState = BubbleState.blowing});
    _explosionTimer = Timer(countDown + explosionDuration,
        onTick: () => {bubbleState = BubbleState.destroyed});
  }

  @override
  final bool collidable = true;

  @override
  final ElementType elementType = ElementType.bubble;

  @override
  Vector2 position;

  @override
  void countDown(double dt) {
    _countDownTimer.update(dt);
    _explosionTimer.update(dt);
  }

  BubbleState get bubbleState => _bubbleState;

  set bubbleState(BubbleState state) {
    _bubbleState = state;
    _onBubbleStateChange?.call(state);
  }
}

enum BubbleState {
  pending,
  blowing,
  destroyed,
}
