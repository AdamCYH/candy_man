import 'package:candy_man/src/elements/bubble_component.dart';
import 'package:candy_man/src/elements/game_element.dart';
import 'package:candy_man/src/elements/player_model.dart';
import 'package:candy_man/src/game_world/game_world.dart';
import 'package:flame/components.dart';

class BubbleModel extends GameElement with CountDownMixin {
  static const explosionDuration = 0.5;

  BubbleState _bubbleState;

  late Timer _countDownTimer;

  late Timer _explosionTimer;

  bool debugMode;
  PlayerModel player;

  BubbleComponent? bubble;

  BubbleModel({
    required this.player,
    required this.position,
    countDown = 2.0,
    OnElementDestroy? onBubbleDestroy,
    this.debugMode = false,
  }) : _bubbleState = BubbleState.pending {
    _countDownTimer = Timer(countDown,
        onTick: () => {bubbleState = BubbleState.blowing}, autoStart: false);
    _explosionTimer = Timer(countDown + explosionDuration, onTick: () {
      bubbleState = BubbleState.destroyed;
      onBubbleDestroy?.call();
    }, autoStart: false);
  }

  @override
  final bool collidable = true;

  @override
  final ElementType elementType = ElementType.bubble;

  @override
  Vector2 position;

  @override
  BubbleComponent create() {
    bubble =
        BubbleComponent.dropByPlayer(bubbleModel: this, debugMode: debugMode);
    _countDownTimer.start();
    _explosionTimer.start();
    return bubble!;
  }

  @override
  void countDown(double dt) {
    _countDownTimer.update(dt);
    _explosionTimer.update(dt);
  }

  BubbleState get bubbleState => _bubbleState;

  set bubbleState(BubbleState state) {
    _bubbleState = state;
    bubble?.updateBubbleStateChange(state);
  }
}

enum BubbleState {
  pending,
  blowing,
  destroyed,
}
