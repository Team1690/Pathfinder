import "package:collection/collection.dart";
import "package:flutter/material.dart";
import "package:pathfinder/views/editor/timeline/add_point_inside_timeline.dart";
import "package:pathfinder/views/editor/timeline/timeline_point.dart";
import "package:pathfinder/views/editor/timeline/time_line_segment.dart";

class PathTimeline extends StatelessWidget {
  const PathTimeline({
    super.key,
    required this.segments,
    required this.points,
    required this.insertPoint,
  });

  final List<TimeLineSegment> segments;
  final List<TimelinePoint> points;
  final void Function(int, int) insertPoint;

  int findSegment(int pointIndex, final List<TimeLineSegment> segments) {
    final List<int> segmentsLength =
        segments.map((final TimeLineSegment seg) => seg.pointAmount).toList();

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
                  .mapIndexed(
                    ((final int index, final TimeLineSegment segment) =>
                        Expanded(
                          flex: segments.length - 1 == index
                              ? segment.pointAmount - 1
                              : segment.pointAmount,
                          child: segment,
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
                const SizedBox(height: 45),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: points
                      .mapIndexed(
                        (final int index, final TimelinePoint point) =>
                            AddPointInsideTimeline(
                          onClick: () => insertPoint(
                            findSegment(index, segments),
                            index + 1,
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
