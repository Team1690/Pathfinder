import "package:flutter/material.dart";
import "dart:math";

//TODO: i don't think we need this cubic bezier painter
class CubicBezier {
  CubicBezier({
    required this.start,
    required this.startControl,
    required this.endControl,
    required this.end,
  });
  CubicBezier.line({required this.start, required this.end})
      : startControl = (start * 2 + end) / 3,
        endControl = (start + end * 2) / 3;
  final Offset start;
  final Offset startControl;
  final Offset endControl;
  final Offset end;

  List<Offset>? _pointsList;

  List<Offset> get pointsList {
    _pointsList ??= <Offset>[start, startControl, endControl, end];

    return _pointsList as List<Offset>;
  }

  Offset evaluate(final double t) {
    final double oneMinusT = 1 - t;

    double oneMinusTFactor = pow(1 - t, 3).toDouble();
    double tFactor = 1;

    Offset result = Offset.zero;

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

  double get length {
    const double dt = 0.001;

    double t = 0;
    double result = 0;
    Offset prevPosition = start;

    while (t <= 1) {
      final Offset currentPosition = evaluate(t);

      result += (currentPosition - prevPosition).distance;

      prevPosition = currentPosition;
      t += dt;
    }

    return result;
  }

  bool operator ==(final Object other) =>
      other is CubicBezier &&
      start == other.start &&
      startControl == other.startControl &&
      endControl == other.endControl &&
      end == other.end;

  @override
  int get hashCode => throw Exception("No hash code for CubicBezier");
}
