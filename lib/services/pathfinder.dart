import 'package:flutter/cupertino.dart';
import 'package:pathfinder/models/point.dart';
import 'package:pathfinder/models/segment.dart';
import 'package:pathfinder/rpc/protos/PathFinder.pbgrpc.dart' as rpc;
import 'package:pathfinder/utils/grpc.dart';

class PathFinderService {
  static Future<rpc.SplineResponse> calculateSpline(
    List<Point> points,
    double interval,
  ) async {
    var client = rpc.PathFinderClient(GrpcClientSingleton().client);

    var requestPoints = points.map(toRpcPoint).toList();

    var request = rpc.SplineRequest(
      evaluatedPointsInterval: interval,
      points: requestPoints,
    );

    return await client.calculateSplinePoints(request);
  }

  static Future<rpc.TrajectoryResponse> calculateTrjactory(
    List<Point> points,
    List<Segment> segments,
  ) async {
    var client = rpc.PathFinderClient(GrpcClientSingleton().client);

    final stopPointIndexes = points
        .asMap()
        .entries
        .where((e) => e.value.isStop)
        .map((e) => e.key)
        .toList();

    // Build a list of the indexes of the segments that define the sections
    final stopPointSegmentIndexes = [0] +
        stopPointIndexes
            .map((i) => segments.indexWhere((s) => s.pointIndexes.contains(i)))
            .toList() +
        [segments.length];
    final rpcSegments = toRpcSegments(segments, points);

    final sections = stopPointSegmentIndexes
        .sublist(0, stopPointSegmentIndexes.length - 1)
        .asMap()
        .entries
        .map((e) => rpcSegments.sublist(
            stopPointSegmentIndexes[e.key], stopPointSegmentIndexes[e.key + 1]))
        .map((segments) => rpc.Section(segments: segments))
        .toList();

    var request = rpc.TrajectoryRequest(
      swerveRobotParams: rpc.TrajectoryRequest_SwerveRobotParams(
        width: 0.6,
        height: 0.6,
        maxAcceleration: 7.5,
        maxAngularAcceleration: 1,
        maxAngularVelocity: 3.141,
        skidAcceleration: 7.5,
        maxJerk: 50,
        maxVelocity: 3,
        cycleTime: 0.02,
      ),
      sections: sections,
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

rpc.Point toRpcPoint(Point p) {
  return rpc.Point(
    position: toRpcVector(p.position),
    controlIn: toRpcVector(p.position + p.inControlPoint),
    controlOut: toRpcVector(p.position + p.outControlPoint),
  );
}

List<rpc.Segment> toRpcSegments(List<Segment> segments, List<Point> points) {
  return segments
      .asMap()
      .entries
      .map((e) {
        if (e.key == segments.length - 1) return e.value;
        return e.value.copyWith(pointIndexes: [
          ...e.value.pointIndexes,
          segments[e.key].pointIndexes.first
        ]);
      })
      .map((s) => toRpcSegment(s, points))
      .toList();
}

rpc.Segment toRpcSegment(Segment s, List<Point> points) {
  return rpc.Segment(
    maxVelocity: s.maxVelocity,
    points: s.pointIndexes.map((i) => toRpcPoint(points[i])).toList(),
  );
}
