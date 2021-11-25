import 'package:redux/redux.dart';

import 'tab_actions.dart';
import 'tab_state.dart';

Reducer<TabState> tabStateReducer = combineReducers<TabState>([
  TypedReducer<TabState, SetSideBarVisibility>(_setSideBarVisibility),
]);

TabState _setSideBarVisibility(TabState tabState, SetSideBarVisibility action) {
  return tabState.copyWith(
      ui: tabState.ui.copyWith(isSidebarOpen: action.visibility));
}
