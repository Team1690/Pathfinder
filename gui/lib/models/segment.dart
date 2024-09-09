import "package:pathfinder/models/path_point.dart";

class Segment {
  Segment({
    required this.pathPoints,
    required this.maxVelocity,
    this.isHidden = false,
  });

  factory Segment.initial({final List<PathPoint>? pathPoints}) => Segment(
        pathPoints: pathPoints ?? <PathPoint>[],
        maxVelocity: 3,
      );

  Segment.fromJson(final dynamic json)
      : pathPoints = (json["pathPoints"] as List<dynamic>)
            .map(PathPoint.fromJson)
            .toList(),
        maxVelocity = json["maxVelocity"] as double,
        isHidden = json["isHidden"] as bool;

  final List<PathPoint> pathPoints;
  final double maxVelocity;
  final bool isHidden;

  //TODO: implement tank

  Segment copyWith({
    final List<PathPoint>? pathPoints,
    final double? maxVelocity,
    final bool? isHidden,
  }) =>
      Segment(
        pathPoints: pathPoints ?? this.pathPoints,
        maxVelocity: maxVelocity ?? this.maxVelocity,
        isHidden: isHidden ?? this.isHidden,
      );

  Map<String, dynamic> toJson() => <String, dynamic>{
        "pathPoints": pathPoints,
        "maxVelocity": maxVelocity,
        "isHidden": isHidden,
      };
}
