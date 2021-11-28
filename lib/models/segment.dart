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
}
