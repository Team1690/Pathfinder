import 'package:flutter/material.dart';
import 'package:pathfinder/cubic_bezier/cubic_bezier.dart';

class WayPoint1D {
  final double position;
  final double velocity;

  final double heading;
  final double omega;

  const WayPoint1D({
    required this.position,
    required this.velocity,
    required this.heading,
    required this.omega,
  });
}

class WayPoint2D {
  final Offset position;
  final Offset velocity;

  final double heading;
  final double omega;

  const WayPoint2D({
    required this.position,
    required this.velocity,
    required this.heading,
    required this.omega,
  });
}

class RobotParams {
  final double maxVelocity;
  final double maxAcceleration;
  final double maxJerk;

  final Offset size; // width and length

  final double skidAcceleration;
  final double maxAccelerationForward;

  const RobotParams({
    required this.maxVelocity,
    required this.maxAcceleration,
    required this.maxJerk,
    required this.size,
    required this.skidAcceleration,
    required this.maxAccelerationForward,
  });
}

class PathSectionProperties {
  final double startHeading;
  final double endHeading;
  final double maxSpeed;

  const PathSectionProperties({
    required this.startHeading,
    required this.endHeading,
    required this.maxSpeed,
  });
}

class PathSection1D {
  final double length;
  final PathSectionProperties properties;

  const PathSection1D({
    required this.length,
    required this.properties,
  });
}

class PathSection2D {
  final CubicBezier bezier;
  final PathSectionProperties properties;

  const PathSection2D({
    required this.bezier,
    required this.properties,
  });
}

const double dt = 0.005;

List<WayPoint1D> generateTrajectory1D(
    final List<PathSection1D> path, final RobotParams robot) {
  // final double pathLength = path.fold(
  //   0,
  //   (lengthAccumulator, pathSection) => lengthAccumulator + pathSection.length,
  // );

  double currentPosition = 0;
  double currentVelocity = 0;
  double currentAcceleration = 0;

  double prevPosition = currentPosition;
  double prevVelocity = currentVelocity;

  List<WayPoint1D> waypoints = [];

  for (double t = 0; t < path.length; t += dt) {
    final PathSection1D currentSection = path[t.floor()];
    // currentPosition = currentSection.bezier.evaluate(t);
    // currentVelocity = (currentPosition - prevPosition) / dt;
    // currentAcceleration = (currentVelocity - prevVelocity) / dt;

    prevPosition = currentPosition;
    prevVelocity = currentVelocity;
  }

  return [];
}
