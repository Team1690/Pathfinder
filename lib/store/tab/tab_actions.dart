import 'package:flutter/cupertino.dart';
import 'package:pathfinder/rpc/protos/PathFinder.pb.dart' as rpc;
import 'package:pathfinder/widgets/path_editor_bloc/path_editor_event.dart';

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

// Server actions
class ServerError extends TabAction {
  final String? error;
  ServerError(this.error);
}

class SplineCalculated extends TabAction {
  final List<rpc.SplineResponse_Point> points;
  SplineCalculated(this.points);
}

// Point actions
class AddPointToPath extends TabAction {
  final Offset position;
  AddPointToPath({required this.position});
}
class EditPoint extends TabAction {
  final int pointIndex;
  final Offset? position;
  final Offset? inControlPoint;
  final Offset? outControlPoint;
  final double? heading;
  final bool? useHeading;
  final List<String>? actions;

  EditPoint({
    required this.pointIndex,
    this.position,
    this.inControlPoint,
    this.outControlPoint,
    this.heading,
    this.useHeading,
    this.actions
  });
}

class DeletePointFromPath extends TabAction {
  final int index;
  DeletePointFromPath({required this.index});
}
