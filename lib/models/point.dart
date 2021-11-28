import 'package:flutter/cupertino.dart';

class Point {
  final Offset position;
  final Offset inControlPoint;
  final Offset outControlPoint;
  final double heading;
  final bool useHeading;
  final List<String> actions;

  Point({
    required final this.position,
    required final this.inControlPoint,
    required final this.outControlPoint,
    required final this.heading,
    required final this.useHeading,
    required final this.actions,
  });
}
