import 'package:flutter/material.dart';

class PathPoint extends StatefulWidget {
  final Offset point;
  final void Function(DragUpdateDetails) onDrag;

  const PathPoint({
    Key? key,
    required this.point,
    required this.onDrag,
  }) : super(key: key);

  @override
  _PathPointState createState() => _PathPointState();
}

class _PathPointState extends State<PathPoint> {
  bool hovered = false;
  double radius = 10;

  @override
  Widget build(final BuildContext context) {
    return Positioned(
      top: widget.point.dy - radius,
      left: widget.point.dx - radius,
      child: MouseRegion(
        onEnter: (_) => setState(() {
          hovered = true;
          radius = 15;
        }),
        onExit: (_) => setState(() {
          hovered = false;
          radius = 10;
        }),
        child: GestureDetector(
          onPanUpdate: widget.onDrag,
          child: Container(
            width: 2 * radius,
            height: 2 * radius,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Color(0xbbdddddd),
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
