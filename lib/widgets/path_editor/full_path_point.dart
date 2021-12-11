
import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pathfinder/models/point.dart';
import 'package:pathfinder/widgets/path_editor/dashed_line_painter.dart';
import 'package:pathfinder/widgets/path_editor/heading_line_painter.dart';
import 'package:pathfinder/widgets/path_editor/path_point.dart';

class FullPathPoint extends StatefulWidget {
  Key key;
  final Point point;
  final bool isSelected;
  final bool enableControlPointsEdit;
  final bool enableHeadingEdit;
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
    required this.enableControlPointsEdit,
    required this.enableHeadingEdit,
  });

  @override
  _FullPathPointState createState() =>
    _FullPathPointState(point.inControlPoint, point.outControlPoint, point.heading);
}

double CalcAngle(Offset center, Offset edge) {
  return atan((edge.dy - center.dy) / (edge.dx - center.dx));
}

class _FullPathPointState extends State<FullPathPoint> {
  Offset inControlPointDrag;
  Offset outControlPointDrag;
  double headingDrag;

  _FullPathPointState(this.inControlPointDrag, this.outControlPointDrag, this.headingDrag);

  final double radius = pointSettings[PointType.path]!.radius;

  @override
  Widget build(final BuildContext context) {
    return Positioned(
      top: widget.point.position.dy - radius,
      left: widget.point.position.dx - radius,
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
            pointType: PointType.path,
          ),
          ...heading(
            heading: headingDrag,
            position: Offset(radius, radius),
            onDrag: (DragUpdateDetails details) {
              setState(() {
                // headingDrag = CalcAngle(
                //   widget.point.position,
                //   Offset(
                //     headingDrag.dx + details.dx,
                //     headingDrag.dy + details.dy
                //   )
              });
            },
            onDragEnd: (_) {},
            onTap: () {},
            enableEdit: widget.enableHeadingEdit && widget.isSelected
          ),
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
                widget.onInControlDragEnd(inControlPointDrag);
              },
              onTap: () {},
              enableEdit: widget.enableControlPointsEdit
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
              onTap: () {},
              enableEdit: widget.enableControlPointsEdit
            )
          ],
        ]
      )
    );
  }
}

List<Widget> heading({
  required double heading,
  required Offset position,
  required Function(DragUpdateDetails) onDrag,
  required Function(DragEndDetails) onDragEnd,
  required Function() onTap,
  required bool enableEdit
}) {
  return [
    CustomPaint(
      painter: HeadingLinePainter(
        heading: heading,
        position: position,
      ),
    ),
    if (enableEdit)
      PathPoint(
        onDrag: onDrag,
        onDragEnd: onDragEnd,
        onTap: onTap,
        pointType: PointType.heading,
      // )),
      )
  ];
}

List<Widget> controlPoint({
  required Offset basePosition,
  required  Offset deltaPosition,
  required Function(DragUpdateDetails) onDrag,
  required Function(DragEndDetails) onDragEnd,
  required Function() onTap,
  required bool enableEdit,
  }) {

  final double radius = pointSettings[PointType.control]!.radius; 

  return [
    CustomPaint(
      painter: DashedLinePainter(
        // start: Offset(-0.5 * PathPoint.pathPointRadius, 0.5 * PathPoint.controlPointRadius),
        start: Offset(radius, radius),
        end: Offset(
                radius + deltaPosition.dx,
                radius + deltaPosition.dy),
      ),
    ),
    //   // top: basePosition.dx + deltaPosition.dy,
    //   // left: basePosition.dy + deltaPosition.dx,
    //   child: Align(
    //     alignment: Alignment.centerRight,
        // child: PathPoint(
        if (enableEdit)
          PathPoint(
            onDrag: onDrag,
            onDragEnd: onDragEnd,
            onTap: onTap,
            pointType: PointType.control,
          // )),
          )
  ];
}
