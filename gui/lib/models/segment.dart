import "package:pathfinder/models/path_point.dart";

class Segment {
  Segment({
    required this.pathPoints,
    required this.maxVelocity,
    this.isHidden = false,
    required this.index,
  });

  factory Segment.initial({final List<PathPoint>? pathPoints}) => Segment(
        pathPoints: pathPoints ?? <PathPoint>[],
        maxVelocity: 3,
        index: 0,
      );

  Segment.fromJson(final dynamic json)
      : pathPoints = (json["pathPoints"] as List<dynamic>)
            .map(PathPoint.fromJson)
            .toList(),
        maxVelocity = json["maxVelocity"] as double,
        isHidden = json["isHidden"] as bool,
        index = json["index"] as int;

  final List<PathPoint> pathPoints;
  final double maxVelocity;
  final bool isHidden;
  final int index;

  //TODO: implement tank

  Segment copyWith({
    final List<PathPoint>? pathPoints,
    final double? maxVelocity,
    final bool? isHidden,
    final int? index,
  }) =>
      Segment(
        pathPoints: pathPoints ?? this.pathPoints,
        maxVelocity: maxVelocity ?? this.maxVelocity,
        isHidden: isHidden ?? this.isHidden,
        index: index ?? this.index,
      );

  Map<String, dynamic> toJson() => <String, dynamic>{
        "pathPoints": pathPoints
            .map((final PathPoint pathPoint) => pathPoint.toJson())
            .toList(),
        "maxVelocity": maxVelocity,
        "isHidden": isHidden,
        "index": index,
      };
}
