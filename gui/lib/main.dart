import "dart:convert";
import "dart:developer";
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

void main(final List<String> args) async {
  //TODO: add a try catch here for future changes of fromJson
  //a persistor persists the state between uses of the app, we save this state in the document
  //dir supplied by the system and save only when there's a change to the state
  final Persistor<AppState> persistor = Persistor<AppState>(
    storage: FlutterStorage(key: "orbit-pathplanner"),
    serializer: JsonSerializer<AppState>(AppState.fromJson),
    throttleDuration: null,
  );

  //load initial state
  AppState initialAppState = (await persistor.load()) ?? AppState.initial();

  //if we supply args meaning that we opened an auto file with this app then decode the file and open it
  if (args.isNotEmpty) {
    try {
      final File autonFile = File(args[0]);
      final String content = await autonFile.readAsBytes().then(
            (final Uint8List value) => String.fromCharCodes(gzip.decode(value)),
          );
      final dynamic decodedState = jsonDecode(content);
      final AppState fileState = AppState.fromJson(decodedState);
      initialAppState = fileState.copyWith(
        changesSaved: true,
        autoFileName: autonFile.path,
      );
    } catch (e) {
      log(e.toString());
    }
  }

  //create store with reducer and middleware
  final Store<AppState> store = Store<AppState>(
    appStateReducer,
    initialState: initialAppState,
    middleware: <Middleware<AppState>>[
      thunkMiddleware,
      persistor.createMiddleware(),
      //* when debugging redux:
      // LoggingMiddleware<AppState>.printer(),
    ],
  );

  //in debug mode we only want to debug the gui
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
