import 'package:pathfinder/models/point.dart';
import 'package:redux/redux.dart';

import 'tab_actions.dart';
import 'tab_state.dart';

Reducer<TabState> tabStateReducer = combineReducers<TabState>([
  TypedReducer<TabState, SetSideBarVisibility>(_setSideBarVisibility),
  TypedReducer<TabState, AddPointToPath>(_addPointToPath),
]);

TabState _setSideBarVisibility(TabState tabState, SetSideBarVisibility action) {
  return tabState.copyWith(
      ui: tabState.ui.copyWith(isSidebarOpen: action.visibility));
}

TabState _addPointToPath(TabState tabState, AddPointToPath action) {
  return tabState.copyWith(
        path: tabState.path.copyWith(points: [...tabState.path.points, new Point.initial(action.position)])
      );
}
