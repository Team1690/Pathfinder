import 'package:flutter/material.dart';
import 'package:pathfinder/constants.dart';

class TimelinePoint extends StatelessWidget {
  final void Function() onTap;
  final Color color;

  TimelinePoint({required this.onTap, required this.color});

  @override
  Widget build(BuildContext context) {
    double radius = 10;
    return Container(
        width: 2 * radius,
        height: 2 * radius,
        decoration: BoxDecoration(shape: BoxShape.circle, color: color));
  }
}

class PathTimeline extends StatelessWidget {
  final List<TimelinePoint> points;

  const PathTimeline({Key? key, required this.points}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 60,
      decoration: BoxDecoration(
          color: gray,
          borderRadius: BorderRadius.all(Radius.circular(defaultRaduis))),
      child: Row(
          children: points
              .map((TimelinePoint point) => GestureDetector(
                    child: point,
                    onTap: () => {print(point.color)},
                  ))
              .toList()),
    );
  }
}
