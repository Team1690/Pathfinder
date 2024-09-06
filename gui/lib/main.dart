import "dart:convert";
import "dart:io";

import "package:flutter/foundation.dart";
import "package:flutter/material.dart";
import "package:flutter_redux/flutter_redux.dart";
import "package:pathfinder/store/app/app_reducer.dart";
import "package:pathfinder/store/app/app_state.dart";
import "package:pathfinder/views/home/home.dart";
import "package:redux/redux.dart";
import "package:redux_thunk/redux_thunk.dart";
import "package:redux_logging/redux_logging.dart";

//TODO: use redux persist for saving temp-state
const bool debug = false;
const String cacheFilePath = "./.temp-state";

void main() {
  // final persistor = Persistor(storage: FlutterStorage(key: "orbit-pathplanner"), serializer: serializer)
  if (kReleaseMode) {
    runAlgorithm();
  }
  runApp(App());
}

class App extends StatelessWidget {
  @override
  Widget build(final BuildContext context) => StoreProvider<AppState>(
        store: store,
        child: MaterialApp(
          theme: ThemeData.dark(),
          debugShowCheckedModeBanner: false,
          title: "Orbit Pathfinder",
          home: HomePage(),
        ),
      );
}

//TODO: simplify saving the app state use redux persist/other method
final Store<AppState> store = Store<AppState>(
  (final AppState state, final dynamic action) {
    final AppState newState = appStateReducer(state, action);
    saveCacheState(newState);

    return newState;
  },
  initialState: loadInitialStateFromCache(),
  middleware: <Middleware<AppState>>[
    thunkMiddleware,
    if (debug) LoggingMiddleware<dynamic>.printer(),
  ],
);

AppState loadInitialStateFromCache() {
  try {
    final File cacheFile = File(cacheFilePath);
    final Map<String, dynamic> jsonState =
        jsonDecode(cacheFile.readAsStringSync()) as Map<String, dynamic>;
    return AppState.fromJson(jsonState);
  } catch (e) {}

  return AppState.initial();
}

void saveCacheState(final AppState state) {
  final String stateJson = jsonEncode(state.toJson());
  File(cacheFilePath).writeAsString(stateJson);
}

void runAlgorithm() => Process.run("Pathfinder-algorithm.exe", <String>[]);
