import 'dart:developer';
import 'dart:html';

import 'package:flutter/material.dart';
import 'package:pathfinder/constants.dart';

class TimelinePoint extends StatelessWidget {
  final void Function() onTap;
  final Color color;
  static double pointRadius = 10;

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
        Text('$velocity m/s'),
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

class PathTimeline extends StatelessWidget {
  final List<TimeLineSegment> segments;

  const PathTimeline({Key? key, required this.segments}) : super(key: key);

  // int sumPoints({required List<TimeLineSegment> segments}) =>
  //     segments.fold(0,
  //         (int acc, TimeLineSegment segment) => acc + segment.points.length) -
  //     (segments.length - 1);

  @override
  Widget build(BuildContext context) {
    inspect(segments);

    return Stack(
      alignment: Alignment.centerLeft,
      children: [
        Row(
          children: segments
              .map(
                (segment) => Expanded(
                  //TODO: flex between 1-6
                  flex: segment.points.length - 1,

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
                    List<TimelinePoint> redeucedList =
                        List.castFrom(segment.points);
                    redeucedList.removeLast();
                    return redeucedList;
                  })
                  .expand((points) => points)
                  .toList()
                ..add(segments.last.points.last),
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
