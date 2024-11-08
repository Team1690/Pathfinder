import "dart:convert";
import "dart:math";

import "package:collection/collection.dart";
import "package:pathfinder_gui/store/app/app_actions.dart";
import "package:pathfinder_gui/store/app/app_state.dart";
import "package:pathfinder_gui/store/tab/store.dart";
import "package:redux/redux.dart";

Reducer<AppState> applyReducers = combineReducers(
  <Reducer<AppState>>[
    TypedReducer<AppState, AddTab>(addTab),
    TypedReducer<AppState, ChangeCurrentTab>(changeCurrentTab),
    TypedReducer<AppState, RemoveTab>(removeTab),
    TypedReducer<AppState, OpenFile>(openFile),
    TypedReducer<AppState, SaveFile>(saveFile),
    TypedReducer<AppState, NewAuto>(newAuto),
  ],
);

AppState openFile(final AppState tabState, final OpenFile action) {
  // Json decode may fail so wrap with try/catch
  try {
    final Map<String, dynamic> decodedState =
        jsonDecode(action.fileContent) as Map<String, dynamic>;
    final AppState fileState = AppState.fromJson(decodedState);

    return fileState.copyWith(
      autoFileName: action.fileName,
      changesSaved: true,
    );
  } catch (e) {}

  return tabState;
}

AppState saveFile(final AppState tabState, final SaveFile action) =>
    tabState.copyWith(
      autoFileName: action.fileName,
      changesSaved: true,
    );

AppState newAuto(final AppState _tabState, final NewAuto action) =>
    AppState.initial();

AppState removeTab(final AppState appState, final RemoveTab removeTab) =>
    appState.copyWith(
      tabState: appState.tabState
          .whereIndexed(
            (final int index, final TabState element) =>
                removeTab.index != index,
          )
          .toList(),
      currentTabIndex: max(appState.currentTabIndex - 1, 0),
    );

AppState addTab(final AppState appState, final AddTab addTab) =>
    appState.copyWith(
      tabState: <TabState>[...appState.tabState, TabState.initial()],
      currentTabIndex: appState.tabState.length,
    );

AppState changeCurrentTab(
  final AppState appState,
  final ChangeCurrentTab changeCurrentTab,
) =>
    appState.copyWith(
      currentTabIndex: changeCurrentTab.index,
    );

AppState appStateReducer(final AppState state, final dynamic action) {
  AppState newState = applyReducers(state, action);

  //TODO: think of a workaround for this as it is quite an ugly fix for something that could be done with typed reducers or middleware
  //I think middleware is the way to go
  final TabState newTabState =
      tabStateReducer(newState.tabState[newState.currentTabIndex], action);

  newState = newState.copyWith(
    tabState: <TabState>[
      ...newState.tabState.sublist(0, newState.currentTabIndex),
      newTabState,
      ...newState.tabState.sublist(newState.currentTabIndex + 1),
    ],
  );
  if (unsavedChangesActions.contains(action.runtimeType)) {
    newState = newState.copyWith(changesSaved: false);
  }
  return newState;
}
