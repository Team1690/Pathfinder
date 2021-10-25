import 'package:flutter/material.dart';
import 'package:pathfinder/cubic_bezier/cubic_bezier.dart';

abstract class PathEditorState {
  final List<Offset> points;

  PathEditorState(this.points);
}

class InitialState extends PathEditorState {
  InitialState() : super([]);
}

class OnePointDefined extends PathEditorState {
  OnePointDefined(final Offset point) : super([point]);

  Offset get point => points.first;
}

class PathDefined extends PathEditorState {
  PathDefined(final List<Offset> points) : super(points);

  List<CubicBezier> get bezierSections {
    final List<CubicBezier> sections = [];

    for (int i = 0; i + 4 <= points.length; i += 3)
      sections.add(
        new CubicBezier(
          start: points[i],
          startControl: points[i + 1],
          endControl: points[i + 2],
          end: points[i + 3],
        ),
      );

    return sections;
  }
}
