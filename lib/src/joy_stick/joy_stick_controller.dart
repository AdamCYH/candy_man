import 'dart:async';

class JoystickController {
  /// Controller used to notify when log entries are added to this logger.
  ///
  /// If hierarchical logging is disabled then this is `null` for all but the
  /// root [Logger].
  StreamController<JoyStickEvent>? _controller;

  Stream<JoyStickEvent> get onFire => _getStream();

  Stream<JoyStickEvent> _getStream() {
    return (_controller ??=
            StreamController<JoyStickEvent>.broadcast(sync: true))
        .stream;
  }

  void input(JoyStickEvent joyStickEvent) => _controller?.add(joyStickEvent);
}

class JoyStickEvent {
  final Direction direction;

  const JoyStickEvent({required this.direction});
}

enum Direction { up, down, left, right, idle }
