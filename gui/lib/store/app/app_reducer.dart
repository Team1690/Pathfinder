import 'package:pathfinder/store/app/app_state.dart';
import 'package:pathfinder/store/tab/store.dart';

import 'app_state.dart';

AppState appStateReducer(AppState state, action) {
  return state.copyWith(tabState: tabStateReducer(state.tabState, action));
}