import 'package:flutter/material.dart';

abstract class PathEditorEvent {}

class AddPointEvent extends PathEditorEvent {
  final Offset newPoint;

  AddPointEvent(final this.newPoint);
}

class PointDragStart extends PathEditorEvent {}

class PointDrag extends PathEditorEvent {
  final int pointIndex;
  final Offset delta;

  PointDrag({
    required final this.pointIndex,
    required final this.delta,
  });
}
