import 'package:pathfinder/models/point.dart';
import 'package:pathfinder/models/segment.dart';
import 'package:pathfinder/rpc/protos/PathFinder.pb.dart' as rpc;

class Path {
  final List<Segment> segments;
  final List<Point> points;
  final List<rpc.SplineResponse_Point>? evaluatedPoints;

  const Path({
    required this.segments,
    required this.points,
    this.evaluatedPoints,
  });

  factory Path.initial() {
    return Path(segments: [], points: [], evaluatedPoints: []);
  }

  Path copyWith({
    List<Segment>? segments,
    List<Point>? points,
    List<rpc.SplineResponse_Point>? evaluatedPoints,
  }) {
    return Path(
      segments: segments ?? this.segments,
      points: points ?? this.points,
      evaluatedPoints: evaluatedPoints ?? this.evaluatedPoints,
    );
  }
}
