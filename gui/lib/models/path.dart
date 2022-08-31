import 'package:flutter/cupertino.dart';
import 'package:pathfinder/models/point.dart';
import 'package:pathfinder/models/segment.dart';
import 'package:pathfinder/utils/coordinates_convertion.dart';
import 'package:pathfinder/utils/json.dart';
import 'package:redux/redux.dart';

class Path {
  final List<Segment> segments;
  final List<Point> points;
  final List<SplinePoint> evaluatedPoints;
  final double autoDuration;

  const Path({
    required this.segments,
    required this.points,
    required this.autoDuration,
    required this.evaluatedPoints,
  });

  factory Path.initial() {
    return Path(segments: [], points: [], evaluatedPoints: [], autoDuration: 0);
  }

  Path copyWith({
    List<Segment>? segments,
    List<Point>? points,
    List<SplinePoint>? evaluatedPoints,
    double? autoDuration,
  }) {
    return Path(
      segments: segments ?? this.segments,
      points: points ?? this.points,
      evaluatedPoints: evaluatedPoints ?? this.evaluatedPoints,
      autoDuration: autoDuration ?? this.autoDuration,
    );
  }

  // Json
  Path.fromJson(Map<String, dynamic> json)
      : segments = List<Segment>.from(
            json['segments'].map((p) => Segment.fromJson(p))),
        points = List<Point>.from(json['points'].map((p) => Point.fromJson(p))),
        evaluatedPoints = List<SplinePoint>.from(
            json['evaluatedPoints'].map((p) => SplinePoint.fromJson(p))),
        autoDuration = json['autoDuration'] ?? 0.0;

  Map<String, dynamic> toJson() {
    return {
      'segments': segments,
      'points': points,
      'evaluatedPoints': evaluatedPoints.map((p) => p.toJson()).toList(),
      'autoDuration': autoDuration,
    };
  }
}

class SplinePoint {
  final Offset position;
  final int segmentIndex;

  SplinePoint({
    required this.position,
    required this.segmentIndex,
  });

  SplinePoint toUiCoord(Store store) {
    return copyWith(
      position: fieldToUiOrigin(store, metersToUiCoord(store, position)),
    );
  }

  SplinePoint copyWith({Offset? position, int? segmentIndex}) {
    return SplinePoint(
      position: position ?? this.position,
      segmentIndex: segmentIndex ?? this.segmentIndex,
    );
  }

  SplinePoint.fromJson(Map<String, dynamic> json)
      : position = offsetFromJson(json['position']),
        segmentIndex = json['segmentIndex'];

  Map<String, dynamic> toJson() {
    return {
      'position': offsetToJson(position),
      'segmentIndex': segmentIndex,
    };
  }
}
