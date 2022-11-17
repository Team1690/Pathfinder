import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pathfinder/models/robot.dart';
import 'package:pathfinder/rpc/protos/PathFinder.pb.dart' as rpc;

abstract class TabAction {
  @override
  String toString() {
    return '$runtimeType';
  }
}

// UI actions
class SetSideBarVisibility extends TabAction {
  final bool visibility;
  SetSideBarVisibility(this.visibility);
}

class ObjectSelected extends TabAction {
  final int index;
  final Type type;
  ObjectSelected(this.index, this.type);
}

class ObjectUnselected extends TabAction {
  ObjectUnselected();
}

class SetZoomLevel extends TabAction {
  final double zoomLevel;
  final Offset? pan;
  SetZoomLevel(this.zoomLevel, {this.pan});
}

class SetPan extends TabAction {
  final Offset pan;
  SetPan(this.pan);
}

// Server actions
class ServerError extends TabAction {
  final String? error;
  ServerError(this.error);
}

class SplineCalculated extends TabAction {
  final List<rpc.SplineResponse_Point> points;
  SplineCalculated(this.points);
}

class TrajectoryInProgress extends TabAction {
  TrajectoryInProgress();
}

class TrajectoryCalculated extends TabAction {
  final List<rpc.TrajectoryResponse_SwervePoint> points;
  TrajectoryCalculated(this.points);
}

// Point actions
class AddPointToPath extends TabAction {
  final Offset? position;
  final int segmentIndex;
  final int insertIndex;

  AddPointToPath(this.position, this.segmentIndex, this.insertIndex);
}

class EditPoint extends TabAction {
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
}

class DeletePointFromPath extends TabAction {
  final int index;
  DeletePointFromPath(this.index);
}

class SetFieldSizePixels extends TabAction {
  final Offset size;
  SetFieldSizePixels(this.size);
}

class EditSegment extends TabAction {
  final int index;
  final double? velocity;
  final bool? isHidden;
  final bool isPathFollowerHeading;
  EditSegment({
    required this.index,
    this.velocity,
    this.isHidden,
    required this.isPathFollowerHeading,
  });
}

class EditRobot extends TabAction {
  final Robot robot;
  EditRobot({
    required this.robot,
  });
}

class ToggleHeading extends TabAction {}

class ToggleControl extends TabAction {}

class TrajectoryFileNameChanged extends TabAction {
  final String fileName;
  TrajectoryFileNameChanged(this.fileName);
}

class OpenFile extends TabAction {
  final String fileContent;
  final String fileName;

  OpenFile({
    required this.fileContent,
    required this.fileName,
  });
}

class SaveFile extends TabAction {
  final String fileName;

  SaveFile({
    required this.fileName,
  });
}

class NewAuto extends TabAction {
  NewAuto();
}

class PathRedo extends TabAction {}

class PathUndo extends TabAction {}
