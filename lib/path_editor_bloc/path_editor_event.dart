import 'package:flutter/material.dart';

abstract class PathEditorEvent {}

class AddPointEvent extends PathEditorEvent {
  final Offset newPoint;

  AddPointEvent(final this.newPoint);
}

class PointDrag extends PathEditorEvent {
  final int pointIndex;
  final Offset mouseDelta;

  PointDrag({required final this.pointIndex, required final this.mouseDelta});
}

class ControlPointTangentialDrag extends PathEditorEvent {
  final int pointIndex;
  final Offset mouseDelta;

  ControlPointTangentialDrag({
    required final this.pointIndex,
    required final this.mouseDelta,
  });
}

class PointDragEnd extends PathEditorEvent {}

class Undo extends PathEditorEvent {}

class Redo extends PathEditorEvent {}
