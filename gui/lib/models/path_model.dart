import "package:orbit_standard_library/orbit_standard_library.dart";
import "package:pathfinder_gui/models/path_point.dart";
import "package:pathfinder_gui/models/robot_on_field.dart";
import "package:pathfinder_gui/models/segment.dart";
import "package:pathfinder_gui/models/spline_point.dart";
import "package:pathfinder_gui/rpc/protos/pathfinder_service.pbgrpc.dart"
    as rpc;

class PathModel {
  const PathModel({
    required this.segments,
    required this.points,
    required this.splinePoints,
    required this.trajectoryPoints,
    required this.autoDuration,
    required this.robotOnField,
    required this.copiedPoint,
  });

  factory PathModel.initial() => PathModel(
        segments: <Segment>[],
        points: <PathPoint>[],
        splinePoints: <SplinePoint>[],
        trajectoryPoints: <rpc.SwervePoints_SwervePoint>[],
        autoDuration: 0,
        robotOnField: None<RobotOnField>(),
        copiedPoint: None<PathPoint>(),
      );

  PathModel.fromJson(final dynamic json)
      : segments =
            (json["segments"] as List<dynamic>).map(Segment.fromJson).toList(),
        points =
            (json["points"] as List<dynamic>).map(PathPoint.fromJson).toList(),
        splinePoints = (json["splinePoints"] as List<dynamic>)
            .map(SplinePoint.fromJson)
            .toList(),
        trajectoryPoints = <rpc.SwervePoints_SwervePoint>[],
        autoDuration = json["autoDuration"] as double,
        robotOnField = None<RobotOnField>(),
        copiedPoint = None<PathPoint>();

  final List<Segment> segments;
  final List<PathPoint> points;
  final List<SplinePoint> splinePoints;
  final List<rpc.SwervePoints_SwervePoint> trajectoryPoints;
  final double autoDuration;
  final Optional<RobotOnField> robotOnField;
  final Optional<PathPoint> copiedPoint;

  PathModel copyWith({
    final List<Segment>? segments,
    final List<PathPoint>? points,
    final List<SplinePoint>? splinePoints,
    final List<rpc.SwervePoints_SwervePoint>? trajectoryPoints,
    final double? autoDuration,
    final Optional<RobotOnField>? robotOnField,
    final Optional<PathPoint>? copiedPoint,
  }) =>
      PathModel(
        segments: segments ?? this.segments,
        points: points ?? this.points,
        splinePoints: splinePoints ?? this.splinePoints,
        trajectoryPoints: trajectoryPoints ?? this.trajectoryPoints,
        autoDuration: autoDuration ?? this.autoDuration,
        robotOnField: robotOnField ?? this.robotOnField,
        copiedPoint: copiedPoint ?? this.copiedPoint,
      );

  dynamic toJson() => <String, dynamic>{
        "segments": segments.map((final Segment seg) => seg.toJson()).toList(),
        "points": points.map((final PathPoint p) => p.toJson()).toList(),
        "splinePoints":
            splinePoints.map((final SplinePoint p) => p.toJson()).toList(),
        "autoDuration": autoDuration,
      };
}
