import 'package:pathfinder/store/tab/tab_thunk.dart';
import 'package:pathfinder/widgets/timeline.dart';
import 'package:pathfinder/store/tab/tab_actions.dart';
import 'package:redux/redux.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:pathfinder/models/point.dart';
import 'package:pathfinder/models/segment.dart';
import 'package:pathfinder/store/app/app_state.dart';
import 'package:pathfinder/constants.dart';

class TimeLineViewModel {
  final List<Point> points;
  final List<Segment> segments;
  final int? selectedPointIndex;
  final double autoDuration;
  final Function(int) selectPoint;
  final Function(int, double, bool) editSegment;
  final Function(int, int) addPoint;

  TimeLineViewModel({
    required this.points,
    required this.segments,
    required this.selectedPointIndex,
    required this.selectPoint,
    required this.editSegment,
    required this.addPoint,
    required this.autoDuration,
  });

  static TimeLineViewModel fromStore(Store<AppState> store) {
    return TimeLineViewModel(
      points: store.state.tabState.path.points,
      segments: store.state.tabState.path.segments,
      selectedPointIndex: (store.state.tabState.ui.selectedType == Point
          ? store.state.tabState.ui.selectedIndex
          : null),
      selectPoint: (int index) {
        store.dispatch(ObjectSelected(index, Point));
      },
      editSegment: (int index, double vel, bool isHidden) {
        store.dispatch(editSegmentThunk(
          index: index,
          velocity: vel,
          isHidden: isHidden,
        ));
      },
      addPoint: (int segmentIndex, int insertIndex) {
        store.dispatch(addPointThunk(null, segmentIndex, insertIndex));
      },
      autoDuration: store.state.tabState.path.autoDuration,
    );
  }
}

StoreConnector<AppState, TimeLineViewModel> timeLineView() {
  return new StoreConnector<AppState, TimeLineViewModel>(
      converter: (store) => TimeLineViewModel.fromStore(store),
      builder: (_, props) => _TimeLineView(props: props));
}

class _TimeLineView extends StatelessWidget {
  final TimeLineViewModel props;

  _TimeLineView({
    required this.props,
  });

  @override
  Widget build(final BuildContext context) {
    final shownAutoDuration =
        props.autoDuration >= 0 ? props.autoDuration.toStringAsFixed(3) : '...';

    return Column(children: [
      PathTimeline(
        insertPoint: (int segmentIndex, int insertIndex) =>
            props.addPoint(segmentIndex, insertIndex),
        points: props.points
            .asMap()
            .entries
            .map(
              (e) => TimelinePoint(
                onTap: () => props.selectPoint(e.key),
                isSelected: e.key == props.selectedPointIndex,
                isStop: e.value.isStop,
                isFirstPoint: e.key == 0,
                isLastPoint: e.key == props.points.length - 1,
                color: Color(0xffE1E1E1CC),
              ),
            )
            .toList(),
        segments: props.segments
            .asMap()
            .entries
            .map(
              (e) => TimeLineSegment(
                color: getSegmentColor(e.key),
                velocity: e.value.maxVelocity,
                pointAmount: e.value.pointIndexes.length,
                onChange: (value) => props.editSegment(e.key, value, false),
              ),
            )
            .toList(),
      ),
      Text(''),
      if (props.autoDuration != 0)
        Text(
          'Duration: $shownAutoDuration s',
        ),
    ]);
  }
}
