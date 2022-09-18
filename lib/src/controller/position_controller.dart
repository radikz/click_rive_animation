import 'dart:async';

import '../model/position.dart';

class PositionController  {
  final _positionController = StreamController<Position>();
  StreamSink<Position> get _position => _positionController.sink;
  Stream<Position> get position => _positionController.stream;

  void changePosition(double dx, double dy) {
    _position.add(Position(dx: dx, dy: dy));
  }

  void dispose() {
    _positionController.close();
  }
}