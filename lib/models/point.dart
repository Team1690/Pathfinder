import 'package:flutter/cupertino.dart';

class Point {
  final Offset position;
  final Offset inControlPoint;
  final Offset outControlPoint;
  final double heading;
  final bool useHeading;
  final List<String> actions;

  Point(
    this.position,
    this.inControlPoint,
    this.outControlPoint,
    this.heading,
    this.useHeading,
    this.actions,
  );
}
