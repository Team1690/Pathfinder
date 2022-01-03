import 'package:flutter/cupertino.dart';
import 'package:pathfinder/models/point.dart';
import 'package:pathfinder/models/robot.dart';
import 'package:pathfinder/models/segment.dart';
import 'package:pathfinder/rpc/protos/PathFinder.pbgrpc.dart' as rpc;
import 'package:pathfinder/store/tab/tab_ui/tab_ui.dart';
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
    Robot robot,
    String fileName,
  ) async {
    var client = rpc.PathFinderClient(GrpcClientSingleton().client);

    fileName = fileName == "" ? defaultTrajectoryFileName : fileName;

    var request = rpc.TrajectoryRequest(
      swerveRobotParams: toRpcSwerveRobotParams(robot),
      sections: toRpcSections(points, segments),
      trajectoryFileName: '$fileName.csv',
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
    heading: p.heading,
    useHeading: p.useHeading,
    action: rpc.RobotAction(
      actionType: p.action,
      time: p.actionTime,
    ),
  );
}

List<rpc.Segment> toRpcSegments(List<Segment> segments, List<Point> points) {
  return segments.map((s) => toRpcSegment(s, points)).toList();
}

rpc.Segment toRpcSegment(Segment s, List<Point> points) {
  return rpc.Segment(
    maxVelocity: s.maxVelocity,
    points: s.pointIndexes.map((i) => toRpcPoint(points[i])).toList(),
  );
}

List<rpc.Section> toRpcSections(List<Point> points, List<Segment> segments) {
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

  // Add the first point of every section (except for the first one) to the
  // end of the previous one
  sections.sublist(0, sections.length - 1).asMap().entries.forEach((e) =>
      sections[e.key]
          .segments
          .last
          .points
          .add(sections[e.key + 1].segments.first.points.first));

  return sections;
}

rpc.TrajectoryRequest_SwerveRobotParams toRpcSwerveRobotParams(Robot r) {
  return rpc.TrajectoryRequest_SwerveRobotParams(
    width: r.width,
    height: r.height,
    maxAcceleration: r.maxAcceleration,
    maxAngularAcceleration: r.maxAngularAcceleration,
    maxAngularVelocity: r.maxAngularVelocity,
    skidAcceleration: r.skidAcceleration,
    maxJerk: r.maxJerk,
    maxVelocity: r.maxVelocity,
    cycleTime: r.cycleTime,
    angularAccelerationPercentage: r.angularAccelerationPercentage,
  );
}
