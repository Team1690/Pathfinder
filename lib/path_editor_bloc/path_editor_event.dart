import 'package:flutter/material.dart';

abstract class PathEditorEvent {}

class AddPointEvent extends PathEditorEvent {
  final Offset newPoint;

  AddPointEvent(final this.newPoint);
}

class PointDrag extends PathEditorEvent {
  final int pointIndex;
  final Offset newPosition;

  PointDrag({required final this.pointIndex, required final this.newPosition});
}

class PointDragEnd extends PathEditorEvent {}

class Undo extends PathEditorEvent {}

class Redo extends PathEditorEvent {}
