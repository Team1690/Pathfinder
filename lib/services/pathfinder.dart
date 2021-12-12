import 'package:flutter/cupertino.dart';
import 'package:pathfinder/models/point.dart';
import 'package:pathfinder/rpc/protos/PathFinder.pbgrpc.dart' as rpc;
import 'package:pathfinder/utils/grpc.dart';

class PathFinderService {
  static Future<rpc.SplineResponse> calculateSpline(
    List<Point> points,
    double interval,
  ) async {
    var client = rpc.PathFinderClient(GrpcClientSingleton().client);

    var requestPoints = points.map((p) => rpc.Point(
          controlIn: toRpcVector(p.position + p.inControlPoint),
          controlOut: toRpcVector(p.position + p.outControlPoint),
          position: toRpcVector(p.position),
        ));

    var request = rpc.SplineRequest(
      evaluatedPointsInterval: interval,
      points: requestPoints,
    );

    return await client.calculateSplinePoints(request);
  }

  static Future<rpc.TrajectoryResponse> calculateTrjactory(
    List<Point> points,
    double maxVelocity,
  ) async {
    var client = rpc.PathFinderClient(GrpcClientSingleton().client);

    var requestPoints = points.map((p) => rpc.Point(
          controlIn: toRpcVector(p.inControlPoint),
          controlOut: toRpcVector(p.outControlPoint),
          position: toRpcVector(p.position),
        ));

    var request = rpc.TrajectoryRequest(
      swerveRobotParams: rpc.TrajectoryRequest_SwerveRobotParams(
        width: 0.5,
        height: 0.5,
        maxAcceleration: 1,
        maxAngularAcceleration: 1,
        maxAngularVelocity: 3.141,
        maxJerk: 100,
        maxVelocity: 3,
      ),
      sections: [
        rpc.Section(segments: [
          rpc.Segment(maxVelocity: maxVelocity, points: requestPoints)
        ])
      ],
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
