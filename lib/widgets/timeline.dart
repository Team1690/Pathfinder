import 'dart:math';

import 'package:flutter/material.dart';
import 'package:pathfinder/constants.dart';

class PathTimeline extends StatelessWidget {
  final List<TimeLineSegment> segments;

  const PathTimeline({Key? key, required this.segments}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.centerLeft,
      children: [
        Row(
          children: segments
              .map(
                (segment) => Expanded(
                  //TODO: flex between 1-6
                  flex: max(segment.points.length - 1, 1),
                  child: TimeLineSegment(
                    points: segment.points,
                    color: segment.color,
                    velocity: segment.velocity,
                  ),
                ),
              )
              .toList(),
        ),
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(''),
            SizedBox(height: 5),
            Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: segments
                    .map((segment) {
                      // List<TimelinePoint> redeucedList =
                      //     List.castFrom(segment.points);
                      // redeucedList.removeLast();
                      // return redeucedList;
                      return segment.points;
                    })
                    .expand((points) => points)
                    .toList()
                // ..add(segments.last.points.last),
                ),
          ],
        ),
      ],
    );
    // return Stack(
    //   children: [segments.removeAt(0)]..addAll(segments
    //       .asMap()
    //       .entries
    //       .map((entry) => Positioned(
    //             child: entry.value,
    //             left: (entry.key + 1) *
    //                 (TimeLineSegment.segmentWidth -
    //                     TimelinePoint.pointRadius * 2),
    //           ))
    //       .toList()),
    // );
  }
}

class TimelinePoint extends StatelessWidget {
  final void Function() onTap;
  final Color color;
  static double pointRadius = 10;
  final bool isSelected;

  TimelinePoint({
    required this.onTap,
    required this.color,
    required this.isSelected,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 2 * pointRadius,
        height: 2 * pointRadius,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: isSelected ? selectedPointColor : color,
          boxShadow: !isSelected
              ? []
              : [
                  BoxShadow(
                    blurRadius: selectedPointHighlightRadius,
                    color: color,
                  ),
                ],
        ),
      ),
    );
  }
}

class TimeLineSegment extends StatelessWidget {
  const TimeLineSegment(
      {Key? key,
      required this.points,
      required this.color,
      required this.velocity})
      : super(key: key);

  final List<TimelinePoint> points;
  final Color color;
  final double velocity;
  static double segmentWidth = 300;
  static double segmentHeight = 50;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('$velocity m/s'),
            SizedBox(width: 5),
          ],
        ),
        SizedBox(height: 5),
        Stack(alignment: Alignment.center, children: [
          Container(
              height: TimeLineSegment.segmentHeight,
              decoration: BoxDecoration(
                color: gray,
                border: Border.all(color: primary, width: 4),
                borderRadius: BorderRadius.all(Radius.circular(defaultRadius)),
              )),
          Container(
            height: 2,
            color: color,
          ),
        ]),
      ],
    );
  }
}
