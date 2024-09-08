import "package:orbit_standard_library/orbit_standard_library.dart";
import "package:pathfinder/models/path_point.dart";
import "package:pathfinder/models/robot_on_field.dart";
import "package:pathfinder/models/segment.dart";

import "package:pathfinder/models/spline_point.dart";
import "package:pathfinder/rpc/protos/pathfinder_service.pbgrpc.dart" as rpc;

class PathModel {
  const PathModel({
    required this.segments,
    required this.points,
    required this.autoDuration,
    required this.evaluatedPoints,
    required this.robotOnField,
    required this.trajectoryPoints,
    required this.copiedPoint,
  });

  factory PathModel.initial() => PathModel(
        trajectoryPoints: <rpc.SwervePoints_SwervePoint>[],
        segments: <Segment>[],
        points: <PathPoint>[],
        evaluatedPoints: <SplinePoint>[],
        autoDuration: 0,
        robotOnField: None<RobotOnField>(),
        copiedPoint: None<PathPoint>(),
      );

  // Json
  PathModel.fromJson(final Map<String, dynamic> json)
      : segments = List<Segment>.from(
          (json["segments"] as List<dynamic>)
              .cast<Map<String, dynamic>>()
              .map(Segment.fromJson),
        ),
        robotOnField = robotOnFieldFromJson(json["robot"]),
        points = List<PathPoint>.from(
          (json["points"] as List<dynamic>)
              .cast<Map<String, dynamic>>()
              .map(PathPoint.fromJson),
        ),
        trajectoryPoints = <rpc.SwervePoints_SwervePoint>[],
        evaluatedPoints = List<SplinePoint>.from(
          (json["evaluatedPoints"] as List<dynamic>)
              .cast<Map<String, dynamic>>()
              .map(SplinePoint.fromJson),
        ),
        copiedPoint = None<PathPoint>(),
        autoDuration = (json["autoDuration"] as double?) ?? 0.0;
  final List<Segment> segments;
  final List<PathPoint> points;
  final List<SplinePoint> evaluatedPoints;
  //TODO: don't save robot on field in json
  final Optional<RobotOnField> robotOnField;
  final double autoDuration;
  final List<rpc.SwervePoints_SwervePoint> trajectoryPoints;
  //TODO: don't save copiedPoint in json
  final Optional<PathPoint> copiedPoint;

  PathModel copyWith({
    final List<Segment>? segments,
    final List<PathPoint>? points,
    final List<SplinePoint>? evaluatedPoints,
    final double? autoDuration,
    final Optional<RobotOnField>? robotOnField,
    final List<rpc.SwervePoints_SwervePoint>? trajectoryPoints,
    final Optional<PathPoint>? copiedPoint,
  }) =>
      PathModel(
        copiedPoint: copiedPoint ?? this.copiedPoint,
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
