import "dart:math";

import "package:collection/collection.dart";
import "package:pathfinder/store/app/app_actions.dart";
import "package:pathfinder/store/app/app_state.dart";
import "package:pathfinder/store/tab/store.dart";
import "package:redux/redux.dart";

Reducer<AppState> applyReducers = combineReducers(
  <Reducer<AppState>>[
    TypedReducer<AppState, AddTab>(addTab),
    TypedReducer<AppState, ChangeCurrentTab>(changeCurrentTab),
    TypedReducer<AppState, RemoveTab>(removeTab),
  ],
);

AppState removeTab(final AppState appState, final RemoveTab removeTab) {
  return appState.copyWith(
    tabState: appState.tabState
        .whereIndexed(
          (final int index, final TabState element) => removeTab.index != index,
        )
        .toList(),
    currentTabIndex: max(appState.currentTabIndex - 1, 0),
  );
}

AppState addTab(final AppState appState, final AddTab addTab) =>
    appState.copyWith(
      tabState: <TabState>[...appState.tabState, TabState.initial()],
      currentTabIndex: appState.tabState.length,
    );

AppState changeCurrentTab(
  final AppState appState,
  final ChangeCurrentTab changeCurrentTab,
) =>
    appState.copyWith(currentTabIndex: changeCurrentTab.index);

AppState appStateReducer(final AppState state, final dynamic action) {
  final AppState newState = applyReducers(state, action);
  final TabState newTabState =
      tabStateReducer(newState.tabState[newState.currentTabIndex], action);

  return newState.copyWith(
    tabState: <TabState>[
      ...newState.tabState.sublist(0, newState.currentTabIndex),
      newTabState,
      ...newState.tabState.sublist(newState.currentTabIndex + 1),
    ],
  );
}
