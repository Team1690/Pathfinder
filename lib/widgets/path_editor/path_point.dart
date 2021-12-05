import 'package:flutter/material.dart';

class PathPoint extends StatefulWidget {
  final Offset point;
  final void Function(DragUpdateDetails) onDrag;
  final void Function(DragEndDetails) onDragEnd;
  final void Function() onTap;
  final Color color;
  final bool controlPoint;

  static const double controlPointRadius = 7;
  static const double pathPointRadius = 10;
  static const Color noneControlPointColor = Color(0xbbdddddd);
  static const Color controlPointColor = Color(0xff111111);

  const PathPoint({
    Key? key,
    required this.point,
    required this.onDrag,
    required this.onDragEnd,
    required this.onTap,
    required this.controlPoint,
  })  : color =
            controlPoint ? controlPointColor : noneControlPointColor,
        super(key: key);

  @override
  _PathPointState createState() => _PathPointState();
}

class _PathPointState extends State<PathPoint> {
  bool hovered = false;
  // Don't change the radius!! that make wierd stuff because of the way the hover is implemented

  @override
  Widget build(final BuildContext context) {
    double radius = widget.controlPoint
              ? PathPoint.controlPointRadius
              : PathPoint.pathPointRadius;

    return Positioned(
      top: widget.point.dy - radius,
      left: widget.point.dx - radius,
      child: MouseRegion(
        onEnter: (_) => setState(() {
          hovered = true;
        }),
        onExit: (_) => setState(() {
          hovered = false;
        }),
        child: GestureDetector(
          onPanUpdate: widget.onDrag,
          onPanEnd: widget.onDragEnd,
          onTap: widget.onTap,
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
