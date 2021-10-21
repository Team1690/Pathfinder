import 'package:flutter/material.dart';
import 'dart:math';

class CubicBezier {
  final Offset start;
  final Offset startControl;
  final Offset endControl;
  final Offset end;

  final List<Offset> pointsList;

  CubicBezier({
    required this.start,
    required this.startControl,
    required this.endControl,
    required this.end,
  }) : pointsList = [start, startControl, endControl, end];

  Offset evaluate(final double t) {
    final double oneMinusT = 1 - t;

    double oneMinusTFactor = pow(1 - t, 3).toDouble();
    double tFactor = 1;

    var result = Offset(0, 0);

    for (int i = 0; i < 4; i++) {
      result += pointsList[i] *
          tFactor *
          oneMinusTFactor *
          (i == 1 || i == 2 ? 3 : 1);

      oneMinusTFactor /= oneMinusT;
      tFactor *= t;
    }

    return result;
  }

  bool operator ==(final Object other) =>
      other is CubicBezier &&
      this.start == other.start &&
      this.startControl == other.startControl &&
      this.endControl == other.endControl &&
      this.end == other.end;

  @override
  int get hashCode => throw Exception("No hash code for CubicBezier");
}
