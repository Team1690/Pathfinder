import 'package:flutter/material.dart';
import 'package:pathfinder/path_editor/path_editor.dart';

void main() => runApp(MyApp());

final Map<int, Color> orbitColors = {
  50: Color.fromRGBO(0, 0, 200, .1),
  100: Color.fromRGBO(0, 0, 200, .2),
  200: Color.fromRGBO(0, 0, 200, .3),
  300: Color.fromRGBO(0, 0, 200, .4),
  400: Color.fromRGBO(0, 0, 200, .5),
  500: Color.fromRGBO(0, 0, 200, .6),
  600: Color.fromRGBO(0, 0, 200, .7),
  700: Color.fromRGBO(0, 0, 200, .8),
  800: Color.fromRGBO(0, 0, 200, .9),
  900: Color.fromRGBO(0, 0, 200, 1),
};

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: MaterialColor(0xFF0000C8, orbitColors),
        ),
        // home: MyHomePage(title: 'Orbit Pathfinder'),
        home: Scaffold(
          appBar: AppBar(title: Text("Orbit Pathfinder")),
          body: PathEditor(),
        ));
  }
}
