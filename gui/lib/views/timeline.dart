import "package:pathfinder/store/tab/tab_thunk.dart";
import "package:pathfinder/widgets/timeline.dart";
import "package:pathfinder/store/tab/tab_actions.dart";
import "package:redux/redux.dart";
import "package:flutter/material.dart";
import "package:flutter_redux/flutter_redux.dart";
import "package:pathfinder/models/point.dart";
import "package:pathfinder/models/segment.dart";
import "package:pathfinder/store/app/app_state.dart";
import "package:pathfinder/constants.dart";

class TimeLineViewModel {
  TimeLineViewModel({
    required this.points,
    required this.segments,
    required this.selectedPointIndex,
    required this.selectPoint,
    required this.editSegment,
    required this.addPoint,
    required this.autoDuration,
  });
  final List<Point> points;
  final List<Segment> segments;
  final int? selectedPointIndex;
  final double autoDuration;
  final Function(int) selectPoint;
  final Function(int, double, bool) editSegment;
  final Function(int, int) addPoint;

  static TimeLineViewModel fromStore(final Store<AppState> store) =>
      TimeLineViewModel(
        points: store.state.tabState.path.points,
        segments: store.state.tabState.path.segments,
        selectedPointIndex: (store.state.tabState.ui.selectedType == Point
            ? store.state.tabState.ui.selectedIndex
            : null),
        selectPoint: (final int index) {
          store.dispatch(ObjectSelected(index, Point));
        },
        editSegment: (final int index, final double vel, final bool isHidden) {
          store.dispatch(
            editSegmentThunk(
              index: index,
              velocity: vel,
              isHidden: isHidden,
            ),
          );
        },
        addPoint: (final int segmentIndex, final int insertIndex) {
          store.dispatch(addPointThunk(null, segmentIndex, insertIndex));
        },
        autoDuration: store.state.tabState.path.autoDuration,
      );
}

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
