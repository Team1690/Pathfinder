import 'package:flutter/material.dart';
import 'dart:math';

class CubicBezier {
  final Offset start;
  final Offset startControl;
  final Offset endControl;
  final Offset end;

  List<Offset>? _pointsList;

  List<Offset> get pointsList {
    _pointsList ??= [start, startControl, endControl, end];

    return _pointsList as List<Offset>;
  }

  CubicBezier({
    required this.start,
    required this.startControl,
    required this.endControl,
    required this.end,
  });

  CubicBezier.line({required final this.start, required final this.end})
      : startControl = (start * 2 + end) / 3,
        endControl = (start + end * 2) / 3;

  Offset evaluate(final double t) {
    final double oneMinusT = 1 - t;

    double oneMinusTFactor = pow(1 - t, 3).toDouble();
    double tFactor = 1;

    var result = Offset.zero;

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
