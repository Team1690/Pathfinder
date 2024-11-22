import "package:flutter/material.dart";

enum PointType {
  first(
    color: Color.fromARGB(255, 52, 168, 83),
    selectedColor: Color.fromARGB(255, 52, 230, 83),
    radius: 8,
  ),
  stop(
    color: Color.fromARGB(255, 196, 41, 41),
    selectedColor: Color.fromARGB(255, 255, 68, 68),
    radius: 8,
  ),
  last(
    color: Color.fromARGB(255, 137, 16, 0),
    selectedColor: Color.fromARGB(255, 255, 21, 0),
    radius: 8,
  ),
  regular(
    color: Color.fromARGB(186, 221, 221, 221),
    selectedColor: Color.fromARGB(255, 238, 238, 238),
    radius: 8,
  ),
  controlIn(
    color: Colors.orange,
    selectedColor: Colors.orange,
  ),
  controlOut(
    color: Colors.yellow,
    selectedColor: Colors.yellow,
  ),
  heading(
    color: Color.fromARGB(255, 200, 0, 0),
    selectedColor: Color.fromARGB(255, 200, 0, 0),
  );

  const PointType({
    required this.color,
    required this.selectedColor,
    this.radius = 6,
  });

  final Color color;
  final Color selectedColor;
  final double radius;

  /// Returns the color of this [PointType] depending on if this point is [isSelected]
  Color getPointColor(
    final bool isSelected,
  ) =>
      isSelected ? selectedColor : color;

  /// Wether this [PointType] is on the path
  bool get isPathPoint =>
      this == PointType.first ||
      this == PointType.regular ||
      this == PointType.stop ||
      this == PointType.last;
}
