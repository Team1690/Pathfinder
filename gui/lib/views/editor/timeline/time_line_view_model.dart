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

  String get shownAutoDuration =>
      autoDuration >= 0 ? "${autoDuration.toStringAsFixed(3)} s" : "<<>>";

  static TimeLineViewModel fromStore(final Store<AppState> store) =>
      TimeLineViewModel(
        points: store.state.currentTabState.path.points,
        segments: store.state.currentTabState.path.segments,
        selectedPointIndex:
            (store.state.currentTabState.ui.selectedType == PathPoint
                ? store.state.currentTabState.ui.selectedIndex
                : null),
        autoDuration: store.state.currentTabState.path.autoDuration,
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
      );
}
