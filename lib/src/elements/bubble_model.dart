import 'package:candy_man/src/elements/bubble_component.dart';
import 'package:candy_man/src/elements/direction.dart';
import 'package:candy_man/src/elements/game_element.dart';
import 'package:candy_man/src/elements/player_model.dart';
import 'package:flame/components.dart';
import 'package:flame_forge2d/contact_callbacks.dart';
import 'package:flame_forge2d/flame_forge2d.dart' as forge2d;

typedef OnBubbleCountDownEnd = void Function(BubbleModel bubble);

enum BubbleState {
  pending,
  blowing,
  destroyed,
}

/// Key: [Direction], Value: isVertical
const bubbleDirections = {
  Direction.up: true,
  Direction.right: false,
  Direction.down: true,
  Direction.left: false
};

class BubbleModel extends GameElement with CountDownMixin, ContactCallbacks {
  static const explosionDuration = 30;

  BubbleState _bubbleState;

  late Timer _countDownTimer;

  late Timer _explosionTimer;

  final collidable = true;
  bool debugMode;
  PlayerModel player;

  BubbleComponent? component;

  BubbleModel({
    required this.player,
    required this.position,
    countDown = 5.0,
    OnBubbleCountDownEnd? onBubbleCountDownEnd,
    OnElementDestroy? onBubbleDestroy,
    this.debugMode = false,
  }) : _bubbleState = BubbleState.pending {
    _countDownTimer = Timer(countDown, onTick: () {
      bubbleState = BubbleState.blowing;
      onBubbleCountDownEnd?.call(this);
    }, autoStart: false);
    _explosionTimer = Timer(countDown + explosionDuration, onTick: () {
      bubbleState = BubbleState.destroyed;
      component?.removeFromParent();
      onBubbleDestroy?.call(this);
    }, autoStart: false);
  }

  @override
  final ElementType elementType = ElementType.bubble;

  @override
  Vector2 position;

  @override
  Future<BubbleComponent> create() async {
    component = BubbleComponent(bubbleModel: this, debugMode: debugMode);
    _countDownTimer.start();
    _explosionTimer.start();
    return component!;
  }

  @override
  void countDown(double dt) {
    _countDownTimer.update(dt);
    _explosionTimer.update(dt);
  }

  @override
  void endContact(Object other, forge2d.Contact contact) {
    if (identical(other, player)) {
      component?.makeColliable();
    }
  }

  BubbleState get bubbleState => _bubbleState;

  set bubbleState(BubbleState state) {
    _bubbleState = state;
    component?.animation.updateBubbleStateChange(state);
  }
}
