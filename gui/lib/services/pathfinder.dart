import "package:collection/collection.dart";
import "package:flutter/cupertino.dart";
import "package:pathfinder_gui/models/path_point.dart";
import "package:pathfinder_gui/models/robot.dart";
import "package:pathfinder_gui/models/segment.dart";
import "package:pathfinder_gui/rpc/protos/pathfinder_service.pbgrpc.dart"
    as rpc;
import "package:pathfinder_gui/models/tab_ui.dart";
import "package:pathfinder_gui/utils/grpc.dart";

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
    print(segments);
    final rpc.PathFinderClient client =
        rpc.PathFinderClient(GrpcClientSingleton().client);

    fileName = fileName == "" ? defaultTrajectoryFileName : fileName;
//TODO: implement tank
    final rpc.TrajectoryRequest request = rpc.TrajectoryRequest(
      swerveParams: toRpcSwerveRobotParams(robot),
      sections: toRpcSections(points, segments),
      fileName: "$fileName.csv",
    );

    return await client.calculateTrajectory(request);
  }

  static Stream<rpc.PathModel> optimizePath(
    final List<PathPoint> points,
    final List<Segment> segments,
    final Robot robot,
  ) {
    print(segments);
    final rpc.PathFinderClient client =
        rpc.PathFinderClient(GrpcClientSingleton().client);

    final rpc.PathModel path = rpc.PathModel(
      pathPoints: points.map(toRpcPoint),
      segments: segments.map(toRpcOptSegment),
      sections: toRpcOptSections(points, segments),
    );
    // print(path);

    final rpc.PathOptimizationRequest request = rpc.PathOptimizationRequest(
      swerveParams: toRpcSwerveRobotParams(robot),
      path: path,
    );
    return client.optimizePath(request);
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

rpc.OptSegment toRpcOptSegment(final Segment s) => rpc.OptSegment(
      pointIndexes: s.pointIndexes.toList(),
      speed: s.maxVelocity,
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

List<rpc.OptSection> toRpcOptSections(
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
      <int>[
        segments.length,
      ]; // length instead of length-1 because otherwise it will be without the last segment

  return stopPointSegmentIndexes
      .sublist(0, stopPointSegmentIndexes.length - 1)
      .mapIndexed(
        (final int index, final _) => List<int>.generate(
          stopPointSegmentIndexes[index + 1] - stopPointSegmentIndexes[index],
          (final int i) => stopPointSegmentIndexes[index] + i,
        ),
      )
      .map(
        (final List<int> segmentIndexes) =>
            rpc.OptSection(segmentIndexes: segmentIndexes),
      )
      .toList();
}

List<PathPoint> fromRpcPathPoints(
  final List<rpc.PathPoint> rpcPoints,
  final List<PathPoint> points,
) =>
    points
        .mapIndexed(
          (final int index, final PathPoint point) => point.copyWith(
            inControlPoint: fromRpcVector(rpcPoints[index].controlIn),
            outControlPoint: fromRpcVector(rpcPoints[index].controlOut),
          ),
        )
        .toList();
