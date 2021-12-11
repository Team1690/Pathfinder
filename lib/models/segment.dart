import 'package:flutter/cupertino.dart';
import 'package:pathfinder/rpc/protos/PathFinder.pb.dart';

class Segment {
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

  Segment({
    required final this.pointIndexes,
    required final this.maxVelocity,
    final this.isHidden = false,
    final this.evaluatedPoints,
    final this.trajectoryPoints,
    final this.splineParameters,
    final this.splineTypes,
  });

  factory Segment.initial() {
    return Segment(
      pointIndexes: [],
      maxVelocity: 3,
    );
  }

  Segment copyWith({
    List<int>? pointIndexes,
    double? maxVelocity,
    bool? isHidden,
    List<SplineResponse_Point>? evaluatedPoints,
    List<TrajectoryResponse_SwervePoint>? trajectoryPoints,
    SplineParameters? splineParameters,
    SplineTypes? splineTypes,
  }) {
    return Segment(
      pointIndexes: pointIndexes ?? this.pointIndexes,
      maxVelocity: maxVelocity ?? this.maxVelocity,
      isHidden: isHidden ?? this.isHidden,
      evaluatedPoints: evaluatedPoints ?? this.evaluatedPoints,
      trajectoryPoints: trajectoryPoints ?? this.trajectoryPoints,
      splineParameters: splineParameters ?? this.splineParameters,
      splineTypes: splineTypes ?? this.splineTypes,
    );
  }
}
