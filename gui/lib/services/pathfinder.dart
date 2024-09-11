import "package:flutter/cupertino.dart";
import "package:pathfinder/models/path_point.dart";
import "package:pathfinder/models/robot.dart";
import "package:pathfinder/models/segment.dart";
import "package:pathfinder/rpc/protos/pathfinder_service.pbgrpc.dart" as rpc;
import "package:pathfinder/models/tab_ui.dart";
import "package:pathfinder/utils/grpc.dart";

class PathFinderService {
  static Future<rpc.SplineResponse> calculateSpline(
    final List<Segment> segments,
    final List<PathPoint> points,
    final double interval,
  ) async {
    final rpc.PathFinderClient client =
        rpc.PathFinderClient(GrpcClientSingleton().client);

    final rpc.SplineRequest request = rpc.SplineRequest(
      pointInterval: interval,
      segments: toRpcSegments(segments, points),
    );

    return await client.calculateSplinePoints(request);
  }

  static Future<rpc.TrajectoryResponse> calculateTrjactory(
    final List<PathPoint> points,
    final List<Segment> segments,
    final Robot robot,
    String fileName,
  ) async {
    final rpc.PathFinderClient client =
        rpc.PathFinderClient(GrpcClientSingleton().client);

    fileName = fileName == "" ? defaultTrajectoryFileName : fileName;
//TODO: this only calculates kinematics, it should also somehow figure out heading time
//TODO: implement tank
    final rpc.TrajectoryRequest request = rpc.TrajectoryRequest(
      swerveParams: toRpcSwerveRobotParams(robot),
      sections: toRpcSections(points, segments),
      fileName: "$fileName.csv",
    );

    return await client.calculateTrajectory(request);
  }
}

rpc.Vector toRpcVector(final Offset p) => rpc.Vector(
      x: p.dx,
      y: p.dy,
    );

rpc.PathPoint toRpcPoint(final PathPoint p) => rpc.PathPoint(
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

List<rpc.Segment> toRpcSegments(
  final List<Segment> segments,
  final List<PathPoint> points,
) =>
    segments.map((final Segment s) => toRpcSegment(s, points)).toList();

rpc.Segment toRpcSegment(final Segment s, final List<PathPoint> points) =>
    rpc.Segment(
      maxVelocity: s.maxVelocity,
      points:
          s.pointIndexes.map((final int i) => toRpcPoint(points[i])).toList(),
    );

List<rpc.Section> toRpcSections(
  final List<PathPoint> points,
  final List<Segment> segments,
) {
  final List<int> stopPointIndexes = points
      .asMap()
      .entries
      .where((final MapEntry<int, PathPoint> e) => e.value.isStop)
      .map((final MapEntry<int, PathPoint> e) => e.key)
      .toList();

  // Build a list of the indexes of the segments that define the sections
  final List<int> stopPointSegmentIndexes = <int>[0] +
      stopPointIndexes
          .map(
            (final int i) => segments
                .indexWhere((final Segment s) => s.pointIndexes.contains(i)),
          )
          .toList() +
      <int>[segments.length];
  final List<rpc.Segment> rpcSegments = toRpcSegments(segments, points);

  final List<rpc.Section> sections = stopPointSegmentIndexes
      .sublist(0, stopPointSegmentIndexes.length - 1)
      .asMap()
      .entries
      .map(
        (final MapEntry<int, int> e) => rpcSegments.sublist(
          stopPointSegmentIndexes[e.key],
          stopPointSegmentIndexes[e.key + 1],
        ),
      )
      .map(
        (final List<rpc.Segment> segments) => rpc.Section(segments: segments),
      )
      .toList();

  // Add the first point of every section (except for the first one) to the
  // end of the previous one
  sections.sublist(0, sections.length - 1).asMap().entries.forEach(
        (final MapEntry<int, rpc.Section> e) => sections[e.key]
            .segments
            .last
            .points
            .add(sections[e.key + 1].segments.first.points.first),
      );

  return sections;
}

rpc.SwerveRobotParams toRpcSwerveRobotParams(final Robot r) =>
    rpc.SwerveRobotParams(
      width: r.width,
      height: r.height,
      maxAcceleration: r.maxAcceleration,
      skidAcceleration: r.skidAcceleration,
      maxJerk: r.maxJerk,
      maxVelocity: r.maxVelocity,
      cycleTime: r.cycleTime,
      angularAccelerationPercentage: r.angularAccelerationPercentage,
    );

Offset fromRpcVector(final rpc.Vector v) => Offset(v.x, v.y);
