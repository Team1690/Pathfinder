import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:pathfinder/store/app/app_reducer.dart';
import 'package:pathfinder/store/app/app_state.dart';
import 'package:pathfinder/store/tab/store.dart';
import 'package:pathfinder/views/home.dart';
import 'package:redux/redux.dart';
import 'package:redux_thunk/redux_thunk.dart';
import 'package:redux_logging/redux_logging.dart';

const debug = false;
const cacheFilePath = "./.temp-state";

void main() => runApp(App());

class App extends StatelessWidget {
  @override
  Widget build(final BuildContext context) {
    return StoreProvider(
        store: store,
        child: MaterialApp(
          theme: ThemeData.dark(),
          debugShowCheckedModeBanner: false,
          title: 'Orbit Pathfinder',
          home: HomePage(),
        ));
  }
}

final store = Store<AppState>(
  (AppState state, dynamic action) {
    var newState = appStateReducer(state, action);
    saveCacheState(newState);

    if (unsavedChanegsActions.contains(action.runtimeType)) {
      newState = newState.copyWith(
        tabState: newState.tabState.copyWith(
          ui: newState.tabState.ui.copyWith(
            changesSaved: false,
          ),
        ),
      );
    }

    return newState;
  },
  initialState: loadInitialStateFromCache(),
  middleware: [
    thunkMiddleware,
    if (debug) LoggingMiddleware.printer(),
  ],
);

AppState loadInitialStateFromCache() {
  try {
    final cacheFile = File(cacheFilePath);
    final jsonState = jsonDecode(cacheFile.readAsStringSync());

    return AppState.fromJson(jsonState);
  } catch (e) {}

  return AppState.initial();
}

dynamic saveCacheState(state) {
  final stateJson = jsonEncode(state.toJson());
  File(cacheFilePath).writeAsString(stateJson);
}
