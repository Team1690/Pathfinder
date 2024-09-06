import "package:flutter/gestures.dart";
import "package:pathfinder/views/editor/point_type.dart";

class DraggingPoint {
  DraggingPoint({
    required this.type,
    required this.position,
    this.index = 0,
  });

  final PointType type;
  final Offset position;
  final int index;
}
