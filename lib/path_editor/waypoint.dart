import 'package:flutter/material.dart';

class Waypoint {
  final Offset position;
  final double magIn, magOut;
  final double dirIn, dirOut;
  final double heading;
  final double omega;

  Waypoint({
    required this.position,
    required this.magIn,
    required this.magOut,
    required this.dirIn,
    required this.dirOut,
    required this.heading,
    required this.omega,
  });

  Offset get outControlPoint => Offset.fromDirection(dirOut, magOut);
  Offset get inControlPoint => Offset.fromDirection(dirIn, magIn);

  Waypoint.fromControlPoints({
    required final this.position,
    required final inControlPoint,
    required final outControlPoint,
    required final this.heading,
    required final this.omega,
  })  : magIn = (position - inControlPoint).distance,
        dirIn = (position - inControlPoint).direction,
        magOut = (outControlPoint - position).distance,
        dirOut = (outControlPoint - position).direction;
}
