import 'package:flutter/material.dart';

enum PointType {
  path,
  control,
  heading
}

class PointSettings {
  final Color color;
  final double radius;

  PointSettings(
    this.color,
    this.radius
  );
}

Map<PointType, PointSettings> pointSettings = {
  PointType.path: PointSettings(Color(0xbbdddddd), 10),
  PointType.control: PointSettings(Color(0xff111111), 7),
  PointType.heading: PointSettings(Color(0xffc80000), 7)
};

class PathPoint extends StatefulWidget {
  final void Function(DragUpdateDetails) onDrag;
  final void Function(DragEndDetails) onDragEnd;
  final void Function() onTap;
  final PointType pointType;

  const PathPoint({
    Key? key,
    required this.onDrag,
    required this.onDragEnd,
    required this.onTap,
    this.pointType = PointType.path
  }): super(key: key);

  @override
  _PathPointState createState() => _PathPointState();
}

class _PathPointState extends State<PathPoint> {
  bool hovered = false;
  // Don't change the radius!! that make wierd stuff because of the way the hover is implemented

  @override
  Widget build(final BuildContext context) {
    PointSettings settings = pointSettings[widget.pointType]!;

    return MouseRegion(
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
          width: 2 * settings.radius,
          height: 2 * settings.radius,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: settings.color,
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
    );
  }
}
