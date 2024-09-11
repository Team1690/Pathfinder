import "package:pathfinder/rpc/protos/pathfinder_service.pb.dart" as rpc;

class Segment {
  Segment({
    required this.pointIndexes,
    required this.maxVelocity,
    this.isHidden = false,
  });

  factory Segment.initial({final List<int>? pointIndexes}) => Segment(
        pointIndexes: pointIndexes ?? <int>[],
        maxVelocity: 3,
      );

  // Json
  Segment.fromJson(final Map<String, dynamic> json)
      : pointIndexes = (json["pointIndexes"] as List<dynamic>).cast<int>(),
        maxVelocity = json["maxVelocity"] as double,
        isHidden = json["isHidden"] as bool;

  final List<int> pointIndexes;
  final double maxVelocity;
  final bool isHidden;

  //TODO: implement tank

  Segment copyWith({
    final List<int>? pointIndexes,
    final double? maxVelocity,
    final bool? isHidden,
    final List<rpc.SplinePoint>? evaluatedPoints,
    final List<rpc.SwervePoints_SwervePoint>? trajectoryPoints,
  }) =>
      Segment(
        pointIndexes: pointIndexes ?? this.pointIndexes,
        maxVelocity: maxVelocity ?? this.maxVelocity,
        isHidden: isHidden ?? this.isHidden,
      );

  Map<String, dynamic> toJson() => <String, dynamic>{
        "pointIndexes": pointIndexes,
        "maxVelocity": maxVelocity,
        "isHidden": isHidden,
      };
}
