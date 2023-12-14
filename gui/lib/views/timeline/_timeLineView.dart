import "package:flutter/material.dart";
import "package:flutter_redux/flutter_redux.dart";
import "package:pathfinder/models/point.dart";
import "package:pathfinder/models/segment.dart";
import "package:pathfinder/store/app/app_state.dart";
import "package:pathfinder/constants.dart";

import "package:pathfinder/views/timeline/time_line_view_model.dart";

import "package:pathfinder/widgets/timeline/path_timeline.dart";

import "package:pathfinder/widgets/timeline/timeline_point.dart";

import "package:pathfinder/widgets/timeline/time_line_segment.dart";

StoreConnector<AppState, TimeLineViewModel> timeLineView() =>
    new StoreConnector<AppState, TimeLineViewModel>(
      converter: TimeLineViewModel.fromStore,
      builder: (final _, final TimeLineViewModel props) =>
          _TimeLineView(props: props),
    );

class _TimeLineView extends StatelessWidget {
  _TimeLineView({
    required this.props,
  });
  final TimeLineViewModel props;

  @override
  Widget build(final BuildContext context) {
    final String shownAutoDuration =
        props.autoDuration >= 0 ? props.autoDuration.toStringAsFixed(3) : "...";

    return Column(
      children: <Widget>[
        PathTimeline(
          insertPoint: props.addPoint,
          points: props.points
              .asMap()
              .entries
              .map(
                (final MapEntry<int, Point> e) => TimelinePoint(
                  onTap: () => props.selectPoint(e.key),
                  isSelected: e.key == props.selectedPointIndex,
                  isStop: e.value.isStop,
                  isFirstPoint: e.key == 0,
                  isLastPoint: e.key == props.points.length - 1,
                  color: const Color(0xffE1E1E1CC),
                ),
              )
              .toList(),
          segments: props.segments
              .asMap()
              .entries
              .map(
                (final MapEntry<int, Segment> e) => TimeLineSegment(
                  color: getSegmentColor(e.key),
                  onHidePressed: () => props.editSegment(
                    e.key,
                    e.value.maxVelocity,
                    !e.value.isHidden,
                  ),
                  isHidden: e.value.isHidden,
                  velocity: e.value.maxVelocity,
                  pointAmount: e.value.pointIndexes.length,
                  onChange: (final double value) =>
                      props.editSegment(e.key, value, false),
                ),
              )
              .toList(),
        ),
        const Text(""),
        if (props.autoDuration != 0)
          Text(
            "Duration: $shownAutoDuration s",
          ),
      ],
    );
  }
}
