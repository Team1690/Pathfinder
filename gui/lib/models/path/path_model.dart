import "package:collection/collection.dart";
import "package:orbit_standard_library/orbit_standard_library.dart";
import "package:pathfinder/models/path/path_point.dart";
import "package:pathfinder/models/robot_on_field.dart";
import "package:pathfinder/models/path/section.dart";
import "package:pathfinder/models/spline_point.dart";
import "package:pathfinder/rpc/protos/pathfinder_service.pbgrpc.dart" as rpc;

class PathModel {
  const PathModel({
    required this.sections,
    required this.evaluatedPoints,
    required this.robotOnField,
    required this.autoDuration,
    required this.trajectoryPoints,
  });

  factory PathModel.initial() => PathModel(
        sections: <Section>[],
        evaluatedPoints: <SplinePoint>[],
        robotOnField: None<RobotOnField>(),
        autoDuration: 0,
        trajectoryPoints: <rpc.SwervePoints_SwervePoint>[],
      );

  // Json
  PathModel.fromJson(final dynamic json)
      : sections =
            (json["sections"] as List<dynamic>).map(Section.fromJson).toList(),
        evaluatedPoints = List<SplinePoint>.from(
          (json["evaluatedPoints"] as List<dynamic>)
              .cast<Map<String, dynamic>>()
              .map(SplinePoint.fromJson),
        ),
        robotOnField = None<RobotOnField>(),
        autoDuration = (json["autoDuration"] as double?) ?? 0.0,
        //TODO: add trajectory points to tojson
        trajectoryPoints = <rpc.SwervePoints_SwervePoint>[];

  final List<Section> sections;
  final List<SplinePoint> evaluatedPoints;
  final Optional<RobotOnField> robotOnField;
  final double autoDuration;
  //TODO: change this to
  final List<rpc.SwervePoints_SwervePoint> trajectoryPoints;
  //TODO: reimplement copiedpoint
  // final Optional<PathPoint> copiedPoint;

  List<PathPoint> get pathPoints => sections
      .map((final Section section) => section.pathPoints)
      .flattened
      .toList();

  PathModel copyWith({
    final List<Section>? sections,
    final List<SplinePoint>? evaluatedPoints,
    final Optional<RobotOnField>? robotOnField,
    final double? autoDuration,
    final List<rpc.SwervePoints_SwervePoint>? trajectoryPoints,
  }) =>
      PathModel(
        sections: sections ?? this.sections,
        evaluatedPoints: evaluatedPoints ?? this.evaluatedPoints,
        robotOnField: robotOnField ?? this.robotOnField,
        autoDuration: autoDuration ?? this.autoDuration,
        trajectoryPoints: trajectoryPoints ?? this.trajectoryPoints,
      );

  Map<String, dynamic> toJson() => <String, dynamic>{
        "sections":
            sections.map((final Section section) => section.toJson()).toList(),
        "evaluatedPoints":
            evaluatedPoints.map((final SplinePoint p) => p.toJson()).toList(),
        "autoDuration": autoDuration,
        //TODO: add trajectory points to tojson
      };
}
