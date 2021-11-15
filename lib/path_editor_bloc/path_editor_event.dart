import 'package:flutter/material.dart';
import 'package:pathfinder/path_editor/waypoint.dart';

abstract class PathEditorEvent {}

class AddPointEvent extends PathEditorEvent {
  final Offset newPoint;

  AddPointEvent(final this.newPoint);
}

class WaypointDrag extends PathEditorEvent {
  final int pointIndex;
  final Offset mouseDelta;

  WaypointDrag({
    required final this.pointIndex,
    required final this.mouseDelta,
  });
}

class ControlPointDrag extends PathEditorEvent {
  final int waypointIndex;
  final ControlPointType pointType;
  final Offset mouseDelta;

  ControlPointDrag({
    required final this.waypointIndex,
    required final this.pointType,
    required final this.mouseDelta,
  });
}

class ControlPointTangentialDrag extends PathEditorEvent {
  final int waypointIndex;
  final ControlPointType pointType;
  final Offset mouseDelta;

  ControlPointTangentialDrag({
    required final this.waypointIndex,
    required final this.pointType,
    required final this.mouseDelta,
  });
}

class LineSectionEvent extends PathEditorEvent {
  final int waypointIndex;

  LineSectionEvent({
    required final this.waypointIndex,
  });
}

class PointDragEnd extends PathEditorEvent {}

class Undo extends PathEditorEvent {}

class Redo extends PathEditorEvent {}

class ClearAllPoints extends PathEditorEvent {}
