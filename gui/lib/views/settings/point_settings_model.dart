import "package:pathfinder_gui/models/path_point.dart";
import "package:pathfinder_gui/store/app/app_state.dart";
import "package:redux/redux.dart";

class PointSettingsModel {
  PointSettingsModel({required this.index, required this.points});

  static PointSettingsModel fromStore(final Store<AppState> store) =>
      PointSettingsModel(
        index: store.state.currentTabState.ui.selectedIndex,
        points: store.state.currentTabState.path.points,
      );

  final int index;
  final List<PathPoint> points;

  PathPoint get pointData => points[index];
  bool get isFirstOrLast => index == 0 || index == points.length - 1;
}
