import 'package:flutter/material.dart';
import 'package:pathfinder/cubic_bezier/cubic_bezier.dart';
import 'package:pathfinder/path_editor/waypoint.dart';

abstract class PathEditorState {}

class InitialState extends PathEditorState {}

class OnePointDefined extends PathEditorState {
  final Offset point;
  OnePointDefined(final this.point);
}

class PathDefined extends PathEditorState {
  /* 
  ? should there be start and end points
  ? (which are not waypoints because they don't have all the parameters)
  */
  final List<Waypoint> waypoints;
  PathDefined(final this.waypoints);

  List<CubicBezier> get bezierSections {
    final List<CubicBezier> sections = [];

    for (int i = 0; i < waypoints.length - 1; i++)
      sections.add(Waypoint.bezierSection(waypoints[i], waypoints[i + 1]));

    return sections;
  }
}