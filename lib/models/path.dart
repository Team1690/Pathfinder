import 'package:pathfinder/models/point.dart';
import 'package:pathfinder/models/segment.dart';
import 'package:pathfinder/rpc/protos/PathFinder.pb.dart' as rpc;

class Path {
  final List<Segment> segments;
  final List<Point> points;
  final List<rpc.SplineResponse_Point>? evaluatedPoints;
  final double autoDuration;

  const Path({
    required this.segments,
    required this.points,
    required this.autoDuration,
    this.evaluatedPoints,
  });

  factory Path.initial() {
    return Path(segments: [], points: [], evaluatedPoints: [], autoDuration: 0);
  }

  Path copyWith({
    List<Segment>? segments,
    List<Point>? points,
    List<rpc.SplineResponse_Point>? evaluatedPoints,
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
        evaluatedPoints = List<rpc.SplineResponse_Point>.from(
            json['evaluatedPoints']
                .map((p) => rpc.SplineResponse_Point.fromJson(p))),
        autoDuration = json['autoDuration'] ?? 0.0;

  Map<String, dynamic> toJson() {
    return {
      'segments': segments,
      'points': points,
      'evaluatedPoints': evaluatedPoints?.map((p) => p.writeToJson()).toList(),
      'autoDuration': autoDuration,
    };
  }
}
