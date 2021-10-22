import 'package:flutter/material.dart';

class PathPoint extends StatefulWidget {
  final Offset point;
  final void Function(DragUpdateDetails) onDrag;
  final void Function(DragEndDetails) onDragEnd;
  final Color color;
  final bool controlPoint;

  static const double controlPointRadius = 7;
  static const double pathPointRadius = 10;

  const PathPoint({
    Key? key,
    required this.point,
    required this.onDrag,
    required this.onDragEnd,
    required this.controlPoint,
  })  : color =
            controlPoint ? const Color(0xff111111) : const Color(0xbbdddddd),
        super(key: key);

  @override
  _PathPointState createState() => _PathPointState();
}

class _PathPointState extends State<PathPoint> {
  bool hovered = false;
  double radius = 0;

  @override
  Widget build(final BuildContext context) {
    if (radius == 0)
      setState(() {
        radius = widget.controlPoint
            ? PathPoint.controlPointRadius
            : PathPoint.pathPointRadius;
      });
    return Positioned(
      top: widget.point.dy - radius,
      left: widget.point.dx - radius,
      child: MouseRegion(
        onEnter: (_) => setState(() {
          hovered = true;
          radius *= 1.5;
        }),
        onExit: (_) => setState(() {
          hovered = false;
          radius = widget.controlPoint
              ? PathPoint.controlPointRadius
              : PathPoint.pathPointRadius;
        }),
        child: GestureDetector(
          onPanUpdate: widget.onDrag,
          onPanEnd: widget.onDragEnd,
          child: Container(
            width: 2 * radius,
            height: 2 * radius,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: widget.color,
              boxShadow: hovered
                  ? [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.2),
                        spreadRadius: 5,
                        blurRadius: 7,
                      )
                    ]
                  : null,
            ),
          ),
        ),
      ),
    );
  }
}
