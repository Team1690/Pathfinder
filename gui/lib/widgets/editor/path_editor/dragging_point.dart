import "package:flutter/gestures.dart";
import "package:pathfinder/point_type.dart";

class DraggingPoint {
  DraggingPoint(this.type, this.position);
  final PointType type;
  final Offset position;
}
