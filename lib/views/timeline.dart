import 'package:pathfinder/rpc/protos/PathFinder.pb.dart' as rpc;
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
        store.dispatch(EditSegment(
          index: index,
          velocity: vel,
          isHidden: isHidden,
        ));
      },
      addPoint: (int segmentIndex, int insertIndex) {
        store.dispatch(AddPointToPath(null, segmentIndex, insertIndex));
      },
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
    return PathTimeline(
      insertPoint: (int segmentIndex, int insertIndex) =>
          props.addPoint(segmentIndex, insertIndex),
      points: props.points
          .asMap()
          .entries
          .map(
            (point) => TimelinePoint(
              onTap: () => props.selectPoint(point.key),
              isSelected: point.key == props.selectedPointIndex,
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
              points: e.value.pointIndexes
                  .map(
                    (pointIndex) => TimelinePoint(
                      onTap: () => props.selectPoint(pointIndex),
                      isSelected: pointIndex == props.selectedPointIndex,
                      color: Color(0xffE1E1E1CC),
                    ),
                  )
                  .toList(),
              onChange: (value) => props.editSegment(e.key, value, false),
            ),
          )
          .toList(),
    );
  }
}
