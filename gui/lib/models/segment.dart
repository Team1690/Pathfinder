import "package:pathfinder/rpc/protos/PathFinder.pb.dart";

class Segment {
  Segment({
    required this.pointIndexes,
    required this.maxVelocity,
    this.isHidden = false,
    this.evaluatedPoints,
    this.trajectoryPoints,
    this.splineParameters,
    this.splineTypes,
  });

  factory Segment.initial({final List<int>? pointIndexes}) => Segment(
        pointIndexes: pointIndexes ?? <int>[],
        maxVelocity: 3,
      );

  // Json
  Segment.fromJson(final Map<String, dynamic> json)
      : pointIndexes = (json["pointIndexes"] as List<dynamic>).cast<int>(),
        maxVelocity = json["maxVelocity"] as double,
        isHidden = json["isHidden"] as bool,
        evaluatedPoints = null,
        trajectoryPoints = null,
        splineParameters = null,
        splineTypes = null;
  final List<int> pointIndexes;
  final double maxVelocity;
  final bool isHidden;

  // Data from server side calculations
  final List<SplineResponse_Point>? evaluatedPoints;
  final List<TrajectoryResponse_SwervePoint>?
      trajectoryPoints; // TODO: Understand protobuf inheritance and use one class for both drivetrains

  // For server side spline calculation
  final SplineParameters? splineParameters;
  final SplineTypes? splineTypes;

  Segment copyWith({
    final List<int>? pointIndexes,
    final double? maxVelocity,
    final bool? isHidden,
    final List<SplineResponse_Point>? evaluatedPoints,
    final List<TrajectoryResponse_SwervePoint>? trajectoryPoints,
    final SplineParameters? splineParameters,
    final SplineTypes? splineTypes,
  }) =>
      Segment(
        pointIndexes: pointIndexes ?? this.pointIndexes,
        maxVelocity: maxVelocity ?? this.maxVelocity,
        isHidden: isHidden ?? this.isHidden,
        evaluatedPoints: evaluatedPoints ?? this.evaluatedPoints,
        trajectoryPoints: trajectoryPoints ?? this.trajectoryPoints,
        splineParameters: splineParameters ?? this.splineParameters,
        splineTypes: splineTypes ?? this.splineTypes,
      );

  Map<String, dynamic> toJson() => <String, dynamic>{
        "pointIndexes": pointIndexes,
        "maxVelocity": maxVelocity,
        "isHidden": isHidden,
      };
}
