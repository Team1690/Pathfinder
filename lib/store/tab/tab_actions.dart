import 'package:flutter/cupertino.dart';
import 'package:pathfinder/rpc/protos/PathFinder.pb.dart' as rpc;

abstract class TabAction {
  @override
  String toString() {
    return '$runtimeType';
  }
}

// UI actions
class SetSideBarVisibility extends TabAction {
  final bool visibility = false;
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

class DeletePointFromPath extends TabAction {
  final int index;
  DeletePointFromPath({required this.index});
}
