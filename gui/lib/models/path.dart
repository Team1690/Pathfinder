import "package:pathfinder/models/point.dart";
import "package:pathfinder/models/segment.dart";

import "package:pathfinder/models/spline_point.dart";

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
          (json["segments"] as List<dynamic>)
              .cast<Map<String, dynamic>>()
              .map(Segment.fromJson),
        ),
        points = List<Point>.from(
          (json["points"] as List<dynamic>)
              .cast<Map<String, dynamic>>()
              .map(Point.fromJson),
        ),
        evaluatedPoints = List<SplinePoint>.from(
          (json["evaluatedPoints"] as List<dynamic>)
              .cast<Map<String, dynamic>>()
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
