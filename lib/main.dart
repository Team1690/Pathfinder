import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:pathfinder/store/app/app_reducer.dart';
import 'package:pathfinder/store/app/app_state.dart';
import 'package:pathfinder/views/home.dart';
import 'package:redux/redux.dart';
import 'package:redux_thunk/redux_thunk.dart';

const cacheFilePath = ".temp-state";

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
  appStateReducer,
  initialState: loadInitialStateFromCache(),
  middleware: [
    thunkMiddleware,
    saveCacheMiddleware,
  ],
);

AppState loadInitialStateFromCache() {
  try {
    final jsonState = jsonDecode(File(cacheFilePath).readAsStringSync());
    return AppState.fromJson(jsonState);
  } catch (e) {}

  return AppState.initial();
}

dynamic saveCacheMiddleware(store, action, next) {
  final stateJson = jsonEncode(store.state.toJson());
  File(cacheFilePath).writeAsString(stateJson);

  return next(action);
}
