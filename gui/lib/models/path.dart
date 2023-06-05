import "package:flutter/cupertino.dart";
import "package:pathfinder/models/point.dart";
import "package:pathfinder/models/segment.dart";
import "package:pathfinder/store/app/app_state.dart";
import "package:pathfinder/utils/coordinates_convertion.dart";
import "package:pathfinder/utils/json.dart";
import "package:redux/redux.dart";

class Path {
  const Path({
    required this.segments,
    required this.points,
    required this.autoDuration,
    required this.evaluatedPoints,
  });

  factory Path.initial() => const Path(
        segments: <Segment>[],
        points: <Point>[],
        evaluatedPoints: <SplinePoint>[],
        autoDuration: 0,
      );

  // Json
  Path.fromJson(final Map<String, dynamic> json)
      : segments = List<Segment>.from(
          (json["segments"] as List<Map<String, dynamic>>)
              .map(Segment.fromJson),
        ),
        points = List<Point>.from(
          (json["points"] as List<Map<String, dynamic>>).map(Point.fromJson),
        ),
        evaluatedPoints = List<SplinePoint>.from(
          (json["evaluatedPoints"] as List<Map<String, dynamic>>)
              .map(SplinePoint.fromJson),
        ),
        autoDuration = (json["autoDuration"] as double?) ?? 0.0;
  final List<Segment> segments;
  final List<Point> points;
  final List<SplinePoint> evaluatedPoints;
  final double autoDuration;

  Path copyWith({
    final List<Segment>? segments,
    final List<Point>? points,
    final List<SplinePoint>? evaluatedPoints,
    final double? autoDuration,
  }) =>
      Path(
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
      };
}

class SplinePoint {
  SplinePoint({
    required this.position,
    required this.segmentIndex,
  });

  SplinePoint.fromJson(final Map<String, dynamic> json)
      : position = offsetFromJson(json["position"] as Map<String, dynamic>),
        segmentIndex = json["segmentIndex"] as int;
  final Offset position;
  final int segmentIndex;

  SplinePoint toUiCoord(final Store<AppState> store) => copyWith(
        position: fieldToUiOrigin(store, metersToUiCoord(store, position)),
      );

  SplinePoint copyWith({final Offset? position, final int? segmentIndex}) =>
      SplinePoint(
        position: position ?? this.position,
        segmentIndex: segmentIndex ?? this.segmentIndex,
      );

  Map<String, dynamic> toJson() => <String, dynamic>{
        "position": offsetToJson(position),
        "segmentIndex": segmentIndex,
      };
}
