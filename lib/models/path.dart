import 'package:pathfinder/models/point.dart';
import 'package:pathfinder/models/segment.dart';

class Path {
  final List<Segment> segments;
  final List<Point> points;

  const Path({
    required this.segments,
    required this.points,
  });

  factory Path.initial() {
    return Path(
      segments: [],
      points: [],
    );
  }

  Path copyWith({
    List<Segment>? segments,
    List<Point>? points,
  }) {
    return Path(
      segments: segments ?? this.segments,
      points: points ?? this.points,
    );
  }
}
