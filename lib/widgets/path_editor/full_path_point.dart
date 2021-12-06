
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:grpc/grpc.dart';
import 'package:pathfinder/models/point.dart';
import 'package:pathfinder/widgets/path_editor/dashed_line_painter.dart';
import 'package:pathfinder/widgets/path_editor/heading_line_painter.dart';
import 'package:pathfinder/widgets/path_editor/path_point.dart';

class FullPathPoint extends StatefulWidget {
  Key key;
  final Point point;
  final bool isSelected;
  final Function(DragUpdateDetails) onDrag;
  final Function(DragEndDetails) onDragEnd;
  final Function() onTap;
  final Function(Offset) onInControlDragEnd;
  final Function(Offset) onOutControlDragEnd;

  FullPathPoint({
    required this.key,
    required this.point,
    required this.onDrag,
    required this.onDragEnd,
    required this.onTap, 
    required this.isSelected,
    required this.onInControlDragEnd,
    required this.onOutControlDragEnd,
  });

  @override
  _FullPathPointState createState() =>
    _FullPathPointState(point.inControlPoint, point.outControlPoint);
}

class _FullPathPointState extends State<FullPathPoint> {
  Offset inControlPointDrag;
  Offset outControlPointDrag;

  _FullPathPointState(this.inControlPointDrag, this.outControlPointDrag);

  @override
  Widget build(final BuildContext context) {
    return Positioned(
      top: widget.point.position.dy - PathPoint.pathPointRadius,
      left: widget.point.position.dx - PathPoint.pathPointRadius,
      child: Stack(
        children: [
          // Actual point
          PathPoint(
            onDrag: (final DragUpdateDetails details) {
              widget.onDrag(details);
            },
            onDragEnd: (final DragEndDetails details) {
              widget.onDragEnd(details);
            },
            onTap: () {
              widget.onTap();
            },
            controlPoint: false,
          ),
          // Red line
          CustomPaint(
            painter: HeadingLinePainter(
              heading: widget.point.heading,
              position: Offset(-PathPoint.pathPointRadius, PathPoint.pathPointRadius),
            ),
          ),
          // Control Point lines and dots
          if (widget.isSelected) ...[
            ...controlPoint(
              basePosition: widget.point.position,
              deltaPosition: inControlPointDrag,
              onDrag: (DragUpdateDetails detailes) {
                setState(() {
                  inControlPointDrag = Offset(
                    inControlPointDrag.dx + detailes.delta.dx,
                    inControlPointDrag.dy + detailes.delta.dy
                  );
                });
              },
              onDragEnd: (_) {
                // inControlPointDrag
                widget.onInControlDragEnd(inControlPointDrag);
              },
              onTap: () {}
            ),
            ...controlPoint(
              basePosition: widget.point.position,
              deltaPosition: outControlPointDrag,
              onDrag: (DragUpdateDetails detailes) {
                setState(() {
                  outControlPointDrag = Offset(
                    outControlPointDrag.dx + detailes.delta.dx,
                    outControlPointDrag.dy + detailes.delta.dy
                  );
                });
              },
              onDragEnd: (_) {
                widget.onOutControlDragEnd(outControlPointDrag);
              },
              onTap: () {}
            )
          ],
        ]
      )
    );
  }
}

List<Widget> controlPoint({
  required Offset basePosition,
  required  Offset deltaPosition,
  required Function(DragUpdateDetails) onDrag,
  required Function(DragEndDetails) onDragEnd,
  required Function() onTap,
  }) {

  return [
    CustomPaint(
      painter: DashedLinePainter(
        // start: Offset(-0.5 * PathPoint.pathPointRadius, 0.5 * PathPoint.controlPointRadius),
        start: Offset(PathPoint.pathPointRadius, PathPoint.pathPointRadius),
        end: Offset(
                PathPoint.pathPointRadius + deltaPosition.dx,
                PathPoint.pathPointRadius + deltaPosition.dy),
      ),
    ),
    //   // top: basePosition.dx + deltaPosition.dy,
    //   // left: basePosition.dy + deltaPosition.dx,
    //   child: Align(
    //     alignment: Alignment.centerRight,
        // child: PathPoint(
        PathPoint(
          controlPoint: true,
          onDrag: onDrag,
          onDragEnd: onDragEnd,
          onTap: onTap,
        // )),
        )
  ];
}
