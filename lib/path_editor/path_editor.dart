import 'package:flutter/material.dart';
import 'package:pathfinder/path_editor/path_painter.dart';
import 'package:pathfinder/path_editor/path_point.dart';

class PathEditor extends StatefulWidget {
  PathEditor({Key? key}) : super(key: key);

  @override
  _PathEditorState createState() => _PathEditorState();
}

class _PathEditorState extends State<PathEditor> {
  List<Offset> points = [];
  Offset mousePosition = Offset(0, 0);

  List<List<Offset>> getBezierPoints(final List<Offset> points) {
    final List<List<Offset>> bezierPoints = [];

    for (int i = 0; i + 4 <= points.length; i += 3)
      bezierPoints.add(points.sublist(i, i + 4));

    return bezierPoints;
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: MouseRegion(
        onHover: (event) {
          setState(() => mousePosition = event.localPosition);
        },
        child: Stack(
          children: [
            GestureDetector(
              child: const Image(
                image: const AssetImage('assets/images/frc_2020_field.png'),
                width: 1100,
                height: 1100 / 15.98 * 8.21,
              ),
              onTapDown: (final TapDownDetails detailes) {
                final Offset tapPos = detailes.localPosition;

                setState(() {
                  if (points.isEmpty) {
                    points.add(tapPos);
                  } else {
                    points.addAll([
                      (points.last * 2 + tapPos) / 3, // start control point
                      (points.last + tapPos * 2) / 3, // end control point
                      tapPos // end position
                    ]);
                  }
                });
              },
              onPanUpdate: (final DragUpdateDetails details) =>
                  setState(() => mousePosition = details.localPosition),
            ),
            for (final Offset point in points)
              PathPoint(
                point: point,
                controlPoint: points.indexOf(point) % 3 != 0,
                onDrag: (final DragUpdateDetails details) => setState(
                  () {
                    mousePosition = Offset(mousePosition.dx + details.delta.dx,
                        mousePosition.dy + details.delta.dy);

                    final int pointIndex = points.indexOf(point);
                    if (pointIndex > -1) points[pointIndex] = mousePosition;
                  },
                ),
              ),
            for (final sectionPoints in getBezierPoints(this.points))
              CustomPaint(
                painter: PathPainter(points: sectionPoints),
              ),
          ],
        ),
      ),
    );
  }
}
