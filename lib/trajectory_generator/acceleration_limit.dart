import 'dart:math';

import 'package:pathfinder/trajectory_generator/trajectory_generator.dart';

double skid(final double acceleration, final RobotParams robot) =>
    min(acceleration, robot.skidAcceleration);

double tilt(final double acceleration, final RobotParams robot) =>
    min(acceleration, robot.maxAccelerationForward);

double speedForward(
  final double acceleration,
  final double speed,
  final RobotParams robot,
) {
  // Relative to max
  final double relativeSpeed = (robot.maxVelocity - speed) / robot.maxVelocity;
  final double maxAccForward = robot.maxAccelerationForward * relativeSpeed;

  return min(acceleration, maxAccForward);
}

double limitAcceleration(
    final double acceleration, final double speed, final RobotParams robot) {
  double limitedAcceleration = skid(acceleration, robot);
  limitedAcceleration = tilt(limitedAcceleration, robot);
  limitedAcceleration = speedForward(limitedAcceleration, speed, robot);

  return limitedAcceleration;
}
