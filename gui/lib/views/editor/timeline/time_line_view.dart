import "package:collection/collection.dart";
import "package:flutter/material.dart";
import "package:flutter_redux/flutter_redux.dart";
import "package:pathfinder_gui/models/path_point.dart";
import "package:pathfinder_gui/models/segment.dart";
import "package:pathfinder_gui/store/app/app_state.dart";
import "package:pathfinder_gui/constants.dart";
import "package:pathfinder_gui/views/editor/timeline/time_line_view_model.dart";
import "package:pathfinder_gui/views/editor/timeline/path_timeline.dart";
import "package:pathfinder_gui/views/editor/timeline/timeline_point.dart";
import "package:pathfinder_gui/views/editor/timeline/time_line_segment.dart";

class TimeLineView extends StatelessWidget {
  @override
  Widget build(final BuildContext context) =>
      StoreConnector<AppState, TimeLineViewModel>(
        converter: TimeLineViewModel.fromStore,
        builder: (final BuildContext context, final TimeLineViewModel model) =>
            Column(
          children: <Widget>[
            PathTimeline(
              insertPoint: model.addPoint,
              points: model.points
                  .mapIndexed(
                    (final int index, final PathPoint pathPoint) =>
                        TimelinePoint(
                      onTap: () => model.selectPoint(index),
                      isSelected: index == model.selectedPointIndex,
                      pointType:
                          pathPoint.pointType(index, model.points.length),
                    ),
                  )
                  .toList(),
              segments: model.segments
                  .mapIndexed(
                    (final int index, final Segment segment) => TimeLineSegment(
                      color: getSegmentColor(index),
                      onHidePressed: () => model.editSegment(
                        index,
                        segment.maxVelocity,
                        !segment.isHidden,
                      ),
                      isHidden: segment.isHidden,
                      velocity: segment.maxVelocity,
                      pointAmount: segment.pointIndexes.length,
                      onChange: (final double value) =>
                          model.editSegment(index, value, false),
                    ),
                  )
                  .toList(),
            ),
            if (model.autoDuration != 0)
              Text(
                "Duration: ${model.shownAutoDuration}",
              ),
          ],
        ),
      );
}
