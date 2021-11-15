import 'package:flutter/material.dart';
import 'package:pathfinder/cubic_bezier/cubic_bezier.dart';

class Waypoint {
  final Offset position;
  final double magIn, magOut;
  final double dirIn, dirOut;
  final double heading;

  Waypoint({
    required this.position,
    required this.magIn,
    required this.magOut,
    required this.dirIn,
    required this.dirOut,
    required this.heading,
  });

  Offset get inControlPoint => position - Offset.fromDirection(dirIn, magIn);
  Offset get outControlPoint => position + Offset.fromDirection(dirOut, magOut);

  Waypoint.fromControlPoints({
    required final this.position,
    required final Offset inControlPoint,
    required final Offset outControlPoint,
    required final this.heading,
  })  : magIn = (position - inControlPoint).distance,
        dirIn = (position - inControlPoint).direction,
        magOut = (outControlPoint - position).distance,
        dirOut = (outControlPoint - position).direction;

  static CubicBezier bezierSection(final Waypoint start, final Waypoint end) =>
      CubicBezier(
        start: start.position,
        startControl: start.outControlPoint,
        endControl: end.inControlPoint,
        end: end.position,
      );
}

enum ControlPointType { In, Out }
