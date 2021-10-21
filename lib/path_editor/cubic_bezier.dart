import 'package:flutter/material.dart';

class CubicBezier {
  final Offset start;
  final Offset startControl;
  final Offset endControl;
  final Offset end;

  CubicBezier({
    required this.start,
    required this.startControl,
    required this.endControl,
    required this.end,
  });

  bool operator ==(final Object other) =>
      other is CubicBezier &&
      this.start == other.start &&
      this.startControl == other.startControl &&
      this.endControl == other.endControl &&
      this.end == other.end;

  @override
  int get hashCode => throw Exception("No hash code for CubicBezier");
}
