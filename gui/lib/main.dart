import "dart:io";

import "package:flutter/foundation.dart";
import "package:flutter/material.dart";
import "package:flutter_redux/flutter_redux.dart";
import "package:pathfinder/store/app/app_reducer.dart";
import "package:pathfinder/store/app/app_state.dart";
import "package:pathfinder/views/home/home.dart";
import "package:redux/redux.dart";
import "package:redux_persist/redux_persist.dart";
import "package:redux_persist_flutter/redux_persist_flutter.dart";
import "package:redux_thunk/redux_thunk.dart";

void runAlgorithm() => Process.run("Pathfinder-algorithm.exe", <String>[]);

void main() async {
  final Persistor<AppState> persistor = Persistor<AppState>(
    storage: FlutterStorage(key: "orbit-pathplanner"),
    serializer: JsonSerializer<AppState>(AppState.fromJson),
    throttleDuration: null,
  );

  final AppState initialAppState =
      (await persistor.load()) ?? AppState.initial();

  final Store<AppState> store = Store<AppState>(
    appStateReducer,
    initialState: initialAppState,
    middleware: <Middleware<AppState>>[
      thunkMiddleware,
      persistor.createMiddleware(),
      // LoggingMiddleware<AppState>.printer(),
    ],
  );

  if (kReleaseMode) {
    runAlgorithm();
  }
  runApp(
    App(
      store: store,
    ),
  );
}

class App extends StatelessWidget {
  const App({super.key, required this.store});

  final Store<AppState> store;
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
