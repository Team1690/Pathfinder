import "package:flutter/material.dart";
import "package:flutter_redux/flutter_redux.dart";
import "package:pathfinder/models/point.dart";
import "package:pathfinder/models/segment.dart";
import "package:pathfinder/views/editor/point_type.dart";
import "package:pathfinder/store/app/app_state.dart";
import "package:pathfinder/constants.dart";

import "package:pathfinder/views/editor/timeline/time_line_view_model.dart";

import "package:pathfinder/views/editor/timeline/path_timeline.dart";

import "package:pathfinder/views/editor/timeline/timeline_point.dart";

import "package:pathfinder/views/editor/timeline/time_line_segment.dart";

//TODO: all store connectors should be like this generalize this to all other models
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
                  //TODO: get rid of this lambda function
                  pointType: () {
                    if (e.value.isStop) return PointType.stop;
                    if (e.key == 0) return PointType.first;
                    if (e.key == props.points.length - 1) return PointType.last;
                    return PointType.regular;
                  }(),
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
