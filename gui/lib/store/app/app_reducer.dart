import "package:pathfinder/store/app/app_state.dart";
import "package:pathfinder/store/tab/store.dart";

AppState appStateReducer(final AppState state, final dynamic action) =>
    state.copyWith(tabState: tabStateReducer(state.tabState, action));
