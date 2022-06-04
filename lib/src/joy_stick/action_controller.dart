import 'dart:async';

class ActionController {
  /// Controller used to notify when log entries are added to this logger.
  ///
  /// If hierarchical logging is disabled then this is `null` for all but the
  /// root [Logger].
  StreamController<ActionEvent>? _controller;

  Stream<ActionEvent> get onFire => _getStream();

  Stream<ActionEvent> _getStream() {
    return (_controller ??= StreamController<ActionEvent>.broadcast(sync: true))
        .stream;
  }

  void input(ActionEvent actionEvent) => _controller?.add(actionEvent);
}

class ActionEvent {
  final ActionType actionType;

  const ActionEvent({required this.actionType});
}

enum ActionType { moveUp, moveDown, moveLeft, moveRight, idle, dropBubble }
