import 'package:flutter/material.dart';
import 'package:pathfinder/curve_painter.dart';
import 'package:pathfinder/path_editor/path_point.dart';

class PathEditor extends StatefulWidget {
  PathEditor({Key? key}) : super(key: key);

  @override
  _PathEditorState createState() => _PathEditorState();
}

class _PathEditorState extends State<PathEditor> {
  List<Offset> points = [];
  Offset mousePosition = Offset(0, 0);

  // List<List<Offset>> getBezierPoints(final List<Offset> points) {
  //   return points.fold([], (previousValue, element) => null);
  // }

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
              child: Image(
                image: AssetImage('assets/images/frc_2020_field.png'),
                width: 1100,
                height: 1100 / 15.98 * 8.21,
              ),
              onTapDown: (final TapDownDetails detailes) =>
                  setState(() => points.add(detailes.localPosition)),
              onPanUpdate: (final DragUpdateDetails details) =>
                  setState(() => mousePosition = details.localPosition),
            ),
            for (final Offset point in points)
              PathPoint(
                point: point,
                onDrag: (final DragUpdateDetails details) => setState(
                  () {
                    mousePosition = Offset(mousePosition.dx + details.delta.dx,
                        mousePosition.dy + details.delta.dy);

                    final int pointIndex = points.indexOf(point);
                    if (pointIndex > -1) points[pointIndex] = mousePosition;
                  },
                ),
              ),
            if (points.length == 4)
              CustomPaint(
                painter: CurvePainter(points: points),
              ),
          ],
        ),
      ),
    );
  }
}
