import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:pathfinder/store/app/app_reducer.dart';
import 'package:pathfinder/store/app/app_state.dart';
import 'package:pathfinder/views/home.dart';
import 'package:redux/redux.dart';
import 'package:redux_thunk/redux_thunk.dart';

void main() => runApp(App());

final store = Store<AppState>(appStateReducer,
    initialState: new AppState.initial(), middleware: [thunkMiddleware]);

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
