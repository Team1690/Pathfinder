import "package:flutter/material.dart";
import "package:pathfinder/views/editor/timeline/add_point_inside_timeline.dart";
import "package:pathfinder/views/editor/timeline/timeline_point.dart";
import "package:pathfinder/views/editor/timeline/time_line_segment.dart";

//TODO: concise
class PathTimeline extends StatelessWidget {
  const PathTimeline({
    final Key? key,
    required this.segments,
    required this.insertPoint,
    required this.points,
  }) : super(key: key);
  final List<TimeLineSegment> segments;
  final List<TimelinePoint> points;
  final void Function(int, int) insertPoint;

  int findSegment(int pointIndex, final List<TimeLineSegment> segments) {
    final List<int> segmentsLength =
        segments.map((final TimeLineSegment e) => e.pointAmount).toList();

    int segmentIndex = 0;
    for (int i = 0; i < segments.length; i++) {
      if (pointIndex + 1 > segmentsLength[i]) {
        pointIndex -= segmentsLength[i];
      } else {
        segmentIndex = i;
        break;
      }
    }
    return segmentIndex;
  }

  @override
  Widget build(final BuildContext context) => segments.isNotEmpty
      ? Stack(
          alignment: Alignment.centerLeft,
          children: <Widget>[
            //segments
            Row(
              children: segments
                  .asMap()
                  .entries
                  .map(
                    ((final MapEntry<int, TimeLineSegment> e) => Expanded(
                          flex: segments.length - 1 == e.key
                              ? e.value.pointAmount - 1
                              : e.value.pointAmount,
                          child: e.value,
                        )),
                  )
                  .toList(),
            ),
            //points
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                const SizedBox(height: 45),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: points,
                ),
              ],
            ),
            //hover points
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                const SizedBox(height: 40),
                const SizedBox(height: 5),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: points
                      .asMap()
                      .entries
                      .map(
                        (final MapEntry<int, TimelinePoint> e) =>
                            AddPointInsideTimeline(
                          onClick: () => insertPoint(
                            findSegment(e.key, segments),
                            e.key + 1,
                          ),
                        ),
                      )
                      .toList()
                    ..removeLast(),
                ),
              ],
            ),
          ],
        )
      : Container();
}
