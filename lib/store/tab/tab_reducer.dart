import 'package:pathfinder/models/point.dart';
import 'package:redux/redux.dart';

import 'tab_actions.dart';
import 'tab_state.dart';

Reducer<TabState> tabStateReducer = combineReducers<TabState>([
  TypedReducer<TabState, SetSideBarVisibility>(_setSideBarVisibility),
  TypedReducer<TabState, AddPointToPath>(_addPointToPath),
  TypedReducer<TabState, DeletePointFromPath>(_deletePointFromPath),
  TypedReducer<TabState, SplineCalculated>(_splineCalculated),
  TypedReducer<TabState, ServerError>(_setServerError),
  TypedReducer<TabState, EditPoint>(_editPoint),
]);

TabState _setSideBarVisibility(TabState tabState, SetSideBarVisibility action) {
  return tabState.copyWith(
      ui: tabState.ui.copyWith(isSidebarOpen: action.visibility));
}

TabState _setServerError(TabState tabState, ServerError action) {
  return tabState.copyWith(ui: tabState.ui.copyWith(serverError: action.error));
}

TabState _splineCalculated(TabState tabState, SplineCalculated action) {
  return tabState.copyWith(
      ui: tabState.ui.copyWith(serverError: null),
      path: tabState.path.copyWith(evaluatedPoints: action.points));
}

TabState _addPointToPath(TabState tabState, AddPointToPath action) {
  return tabState.copyWith(
      path: tabState.path.copyWith(points: [
    ...tabState.path.points,
    new Point.initial(action.position)
  ]));
}

TabState _editPoint(TabState tabState, EditPoint action) {
  return tabState.copyWith(
      path: tabState.path.copyWith(
        points: 
          tabState.path.points.asMap().entries.map((entery) {
          if (entery.key == action.pointIndex) {
            return tabState.path.points[entery.key].copyWith(position: action.position);
          } else {
            return tabState.path.points[entery.key];
          }
      }).toList()
  ));
}

TabState _deletePointFromPath(TabState tabState, DeletePointFromPath action) {
  List<Point> newPoints = tabState.path.points;
  newPoints.removeAt(action.index);

  return tabState.copyWith(
      path: tabState.path.copyWith(
    points: newPoints,
    evaluatedPoints: newPoints.length < 2 ? [] : null,
  ));
}
