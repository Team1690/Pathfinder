import 'package:flutter/material.dart';
import 'package:pathfinder/constants.dart';

class TimelinePoint extends StatelessWidget {
  final void Function() onTap;
  final Color color;

  TimelinePoint({required this.onTap, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
        width: 2 * pointRadius,
        height: 2 * pointRadius,
        decoration: BoxDecoration(shape: BoxShape.circle, color: color));
  }
}

class TimeLineSegment extends StatelessWidget {
  const TimeLineSegment({Key? key, required this.points}) : super(key: key);

  final List<TimelinePoint> points;

  @override
  Widget build(BuildContext context) {
    double segmentWidth = 300;

    return Container(
      height: 50,
      width: segmentWidth,
      decoration: BoxDecoration(

          // color: gray,
          // borderRadius: BorderRadius.all(Radius.circular(defaultRaduis)),
          ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          Container(
              height: 50,
              width: segmentWidth - 20,
              decoration: BoxDecoration(
                color: gray,
                border: Border.all(color: primary, width: 2),
                // borderRadius: BorderRadius.all(Radius.circular(defaultRaduis)),
              )),
          Container(
            height: 2,
            color: blue,
          ),
          Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: points
                  .map((TimelinePoint point) => GestureDetector(
                        child: point,
                        onTap: () => {print(point.color)},
                      ))
                  .toList()),
        ],
      ),
    );
  }
}

class PathTimeline extends StatelessWidget {
  final List<TimeLineSegment> segments;

  const PathTimeline({Key? key, required this.segments}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
        children: [segments.first]..addAll(segments.map((e) => Positioned(
              child: e,
              left: 300 - 20,
            ))));
  }
}
