import 'package:flame/components.dart';
import 'package:flame/input.dart';

class DirectionButton extends ButtonComponent {
  late final PositionComponent? button;

  late final PositionComponent? buttonDown;

  void Function()? onPressed;

  void Function()? onReleased;

  DirectionButton({
    this.button,
    this.buttonDown,
    this.onPressed,
    this.onReleased,
    Vector2? position,
    Vector2? size,
    Vector2? scale,
    double? angle,
    Anchor? anchor,
    Iterable<Component>? children,
    int? priority,
  }) : super(
          position: position,
          size: size ?? button?.size,
          scale: scale,
          angle: angle,
          anchor: anchor,
          children: children,
          priority: priority,
        );

  @override
  bool onTapDown(TapDownInfo info) {
    super.onTapDown(info);

    onPressed?.call();
    return false;
  }

  @override
  bool onTapUp(TapUpInfo info) {
    super.onTapUp(info);

    onTapCancel();
    return true;
  }

  @override
  bool onTapCancel() {
    super.onTapCancel();

    onReleased?.call();
    return false;
  }
}
