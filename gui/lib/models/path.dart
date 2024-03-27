import "package:orbit_standard_library/orbit_standard_library.dart";
import "package:pathfinder/models/point.dart";
import "package:pathfinder/models/robot_on_field.dart";
import "package:pathfinder/models/segment.dart";

import "package:pathfinder/models/spline_point.dart";
import "package:pathfinder/rpc/protos/PathFinder.pbgrpc.dart" as rpc;

class Path {
  const Path({
    required this.segments,
    required this.points,
    required this.autoDuration,
    required this.evaluatedPoints,
    required this.robotOnField,
    required this.trajectoryPoints,
  });

  factory Path.initial() => Path(
        trajectoryPoints: <rpc.TrajectoryResponse_SwervePoint>[],
        segments: <Segment>[],
        points: <Point>[],
        evaluatedPoints: <SplinePoint>[],
        autoDuration: 0,
        robotOnField: None<RobotOnField>(),
      );

  // Json
  Path.fromJson(final Map<String, dynamic> json)
      : segments = List<Segment>.from(
          (json["segments"] as List<dynamic>)
              .cast<Map<String, dynamic>>()
              .map(Segment.fromJson),
        ),
        robotOnField = robotOnFieldFromJson(json["robot"]),
        points = List<Point>.from(
          (json["points"] as List<dynamic>)
              .cast<Map<String, dynamic>>()
              .map(Point.fromJson),
        ),
        trajectoryPoints = <rpc.TrajectoryResponse_SwervePoint>[],
        evaluatedPoints = List<SplinePoint>.from(
          (json["evaluatedPoints"] as List<dynamic>)
              .cast<Map<String, dynamic>>()
              .map(SplinePoint.fromJson),
        ),
        autoDuration = (json["autoDuration"] as double?) ?? 0.0;
  final List<Segment> segments;
  final List<Point> points;
  final List<SplinePoint> evaluatedPoints;
  final Optional<RobotOnField> robotOnField;
  final double autoDuration;
  final List<rpc.TrajectoryResponse_SwervePoint> trajectoryPoints;

  Path copyWith({
    final List<Segment>? segments,
    final List<Point>? points,
    final List<SplinePoint>? evaluatedPoints,
    final double? autoDuration,
    final Optional<RobotOnField>? robotOnField,
    final List<rpc.TrajectoryResponse_SwervePoint>? trajectoryPoints,
  }) =>
      Path(
        trajectoryPoints: trajectoryPoints ?? this.trajectoryPoints,
        robotOnField: robotOnField ?? this.robotOnField,
        segments: segments ?? this.segments,
        points: points ?? this.points,
        evaluatedPoints: evaluatedPoints ?? this.evaluatedPoints,
        autoDuration: autoDuration ?? this.autoDuration,
      );

  Map<String, dynamic> toJson() => <String, dynamic>{
        "segments": segments,
        "points": points,
        "evaluatedPoints":
            evaluatedPoints.map((final SplinePoint p) => p.toJson()).toList(),
        "autoDuration": autoDuration,
        ...robotOnFieldToJson(robotOnField),
      };
}
