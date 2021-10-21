import 'package:flutter/material.dart';
import 'package:pathfinder/path_editor/dashed_line_painter.dart';
import 'package:pathfinder/path_editor/path_painter.dart';
import 'package:pathfinder/path_editor/path_point.dart';
import 'package:pathfinder/path_editor/cubic_bezier.dart';

class PathEditor extends StatefulWidget {
  PathEditor({Key? key}) : super(key: key);

  @override
  _PathEditorState createState() => _PathEditorState();
}

class _PathEditorState extends State<PathEditor> {
  List<Offset> points = [];
  Offset mousePosition = Offset.zero;

  List<CubicBezier> getBezierSections(final List<Offset> points) {
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

  @override
  Widget build(final BuildContext context) {
    final List<CubicBezier> bezierSections = getBezierSections(this.points);

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
            for (final CubicBezier bezierSection in bezierSections) ...[
              CustomPaint(
                painter: DashedLinePainter(
                    start: bezierSection.start,
                    end: bezierSection.startControl),
              ),
              CustomPaint(
                painter: DashedLinePainter(
                  start: bezierSection.endControl,
                  end: bezierSection.end,
                ),
              )
            ],
            for (final Offset point in points)
              PathPoint(
                point: point,
                controlPoint: points.indexOf(point) % 3 != 0,
                onDrag: (final DragUpdateDetails details) => setState(
                  () {
                    mousePosition += details.delta;

                    final int pointIndex = points.indexOf(point);
                    if (pointIndex > -1) points[pointIndex] = mousePosition;
                  },
                ),
              ),
            for (final cubicBezier in getBezierSections(this.points))
              CustomPaint(
                painter: CubicBezierPainter(cubicBezier: cubicBezier),
              ),
          ],
        ),
      ),
    );
  }
}
