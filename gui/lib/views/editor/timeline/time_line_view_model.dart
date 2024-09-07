import "package:pathfinder/models/path_point.dart";
import "package:pathfinder/models/segment.dart";
import "package:pathfinder/store/app/app_state.dart";
import "package:pathfinder/store/tab/tab_actions.dart";
import "package:pathfinder/store/tab/tab_thunk.dart";
import "package:redux/redux.dart";

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
  final List<PathPoint> points;
  final List<Segment> segments;
  final int? selectedPointIndex;
  final double autoDuration;
  final Function(int) selectPoint;
  final Function(int, double, bool) editSegment;
  final Function(int, int) addPoint;

  static TimeLineViewModel fromStore(final Store<AppState> store) =>
      TimeLineViewModel(
        points: store.state.tabState[store.state.currentTabIndex].path.points,
        segments:
            store.state.tabState[store.state.currentTabIndex].path.segments,
        selectedPointIndex: (store.state.tabState[store.state.currentTabIndex]
                    .ui.selectedType ==
                PathPoint
            ? store.state.tabState[store.state.currentTabIndex].ui.selectedIndex
            : null),
        selectPoint: (final int index) {
          store.dispatch(ObjectSelected(index, PathPoint));
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
        autoDuration:
            store.state.tabState[store.state.currentTabIndex].path.autoDuration,
      );
}
