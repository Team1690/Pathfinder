import "package:flutter/cupertino.dart";
import "package:flutter/material.dart";
import "package:pathfinder/models/robot.dart";
import "package:pathfinder/rpc/protos/PathFinder.pb.dart" as rpc;

abstract class TabAction {
  @override
  String toString() => "$runtimeType";
}

// UI actions
class SetSideBarVisibility extends TabAction {
  SetSideBarVisibility(this.visibility);
  final bool visibility;
}

class ObjectSelected extends TabAction {
  ObjectSelected(this.index, this.type);
  final int index;
  final Type type;
}

class ObjectUnselected extends TabAction {
  ObjectUnselected();
}

class SetZoomLevel extends TabAction {
  SetZoomLevel(this.zoomLevel, {this.pan});
  final double zoomLevel;
  final Offset? pan;
}

class SetPan extends TabAction {
  SetPan(this.pan);
  final Offset pan;
}

// Server actions
class ServerError extends TabAction {
  ServerError(this.error);
  final String? error;
}

class SplineCalculated extends TabAction {
  SplineCalculated(this.points);
  final List<rpc.SplineResponse_Point> points;
}

class TrajectoryInProgress extends TabAction {
  TrajectoryInProgress();
}

class TrajectoryCalculated extends TabAction {
  TrajectoryCalculated(this.points);
  final List<rpc.TrajectoryResponse_SwervePoint> points;
}

// Point actions
class AddPointToPath extends TabAction {
  AddPointToPath(this.position, this.segmentIndex, this.insertIndex);
  final Offset? position;
  final int segmentIndex;
  final int insertIndex;
}

class EditPoint extends TabAction {
  EditPoint({
    required this.pointIndex,
    this.position,
    this.inControlPoint,
    this.outControlPoint,
    this.heading,
    this.useHeading,
    this.actions,
    this.cutSegment,
    this.isStop,
    this.action,
    this.actionTime,
  });
  final int pointIndex;
  final Offset? position;
  final Offset? inControlPoint;
  final Offset? outControlPoint;
  final double? heading;
  final bool? useHeading;
  final List<String>? actions;
  final bool? cutSegment;
  final bool? isStop;
  final String? action;
  final double? actionTime;
}

class DeletePointFromPath extends TabAction {
  DeletePointFromPath(this.index);
  final int index;
}

class SetFieldSizePixels extends TabAction {
  SetFieldSizePixels(this.size);
  final Offset size;
}

class EditSegment extends TabAction {
  EditSegment({
    required this.index,
    this.velocity,
    this.isHidden,
  });
  final int index;
  final double? velocity;
  final bool? isHidden;
}

class EditRobot extends TabAction {
  EditRobot({
    required this.robot,
  });
  final Robot robot;
}

class ToggleHeading extends TabAction {}

class ToggleControl extends TabAction {}

class TrajectoryFileNameChanged extends TabAction {
  TrajectoryFileNameChanged(this.fileName);
  final String fileName;
}

class PathRedo extends TabAction {}

class PathUndo extends TabAction {}

class SetRobotOnField extends TabAction {
  SetRobotOnField(this.clickPos);
  final Offset clickPos;
}

class SetRobotOnFieldRaw extends TabAction {
  SetRobotOnFieldRaw(this.position, this.heading);
  final Offset position;
  final double heading;
}
