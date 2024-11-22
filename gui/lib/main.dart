import "dart:convert";
import "dart:developer";
import "dart:io";

import "package:flutter/foundation.dart";
import "package:flutter/material.dart";
import "package:flutter_redux/flutter_redux.dart";
import "package:pathfinder_gui/store/app/tab_middleware.dart";
import "package:redux/redux.dart";
import "package:redux_persist/redux_persist.dart";
import "package:redux_persist_flutter/redux_persist_flutter.dart";
import "package:redux_thunk/redux_thunk.dart";
import "package:window_manager/window_manager.dart";
import "package:pathfinder_gui/store/app/app_state.dart";
import "package:pathfinder_gui/views/home/home.dart";
import "package:pathfinder_gui/store/app/app_reducer.dart";

void runBackgroundProcessManager() =>
    Process.run("pathfinder_manager.exe", <String>[]);

void main(final List<String> args) async {
  // in release mode run the process manager which runs the algorithm and other processes
  if (kReleaseMode) {
    runBackgroundProcessManager();
  }
  //a persistor persists the state between uses of the app, we save this state in the document
  //dir supplied by the system and save only when there's a change to the state
  final Persistor<AppState> persistor = Persistor<AppState>(
    storage: FlutterStorage(key: "orbit-pathplanner"),
    serializer: JsonSerializer<AppState>(AppState.fromJson),
    throttleDuration: null,
  );

  //load initial state
  AppState initialAppState = AppState.initial();
  try {
    initialAppState = (await persistor.load()) ?? initialAppState;
  } catch (e, trace) {
    if (kDebugMode) {
      debugPrint(e.toString() + " :-: " + trace.toString());
    }
  }

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
      TabMiddleware(),
    ],
  );

  WidgetsFlutterBinding.ensureInitialized();
  await windowManager.ensureInitialized();
  await windowManager.setMinimumSize(const Size(683, 384));
  await windowManager.maximize();

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
