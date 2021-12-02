import 'package:flutter/cupertino.dart';
import 'package:pathfinder/models/point.dart';
import 'package:pathfinder/rpc/protos/PathFinder.pbgrpc.dart' as rpc;
import 'package:pathfinder/utils/grpc.dart';

class PathFinderService {
  static Future<rpc.SplineResponse> calculateSpline(
    List<Point> points,
  ) async {
    var client = rpc.PathFinderClient(GrpcClientSingleton().client);

    var requestPoints = points.map((p) => rpc.Point(
          controlIn: toRpcVector(p.inControlPoint),
          controlOut: toRpcVector(p.outControlPoint),
          position: toRpcVector(p.position),
        ));

    var request = rpc.SplineRequest(
      evaluatedPointsInterval: 0.01,
      points: requestPoints,
    );

    return await client.calculateSplinePoints(request);
  }

  static Future<rpc.TrajectoryResponse> calculateTrjactory(
    List<Se> points,
  ) async {
    var client = rpc.PathFinderClient(GrpcClientSingleton().client);

    var requestPoints = points.map((p) => rpc.Point(
          controlIn: toRpcVector(p.inControlPoint),
          controlOut: toRpcVector(p.outControlPoint),
          position: toRpcVector(p.position),
        ));

    var request = rpc.TrajectoryRequest(
      points: requestPoints,
    );

    return await client.calculateTrajectory(request);
  }
}

rpc.Vector toRpcVector(Offset p) {
  return rpc.Vector(
    x: p.dx,
    y: p.dy,
  );
}
