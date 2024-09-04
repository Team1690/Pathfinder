import "package:flutter/gestures.dart";
import "package:pathfinder/point_type.dart";

//TODO: i don't like the fact that there is like three classes for different levels of generality
//i think that one is enough
class DraggingPoint {
  DraggingPoint(this.type, this.position);
  final PointType type;
  final Offset position;
}

class FullDraggingPoint extends DraggingPoint {
  FullDraggingPoint(super.type, super.position, this.index);
  int index;
}
