import 'package:flutter/material.dart';
import 'package:pathfinder/views/home.dart';

void main() => runApp(App());

class App extends StatelessWidget {
  @override
  Widget build(final BuildContext context) {
    return MaterialApp(
        theme: ThemeData.light(),
        debugShowCheckedModeBanner: false,
        title: 'Orbit Pathfinder',
        home: HomePage());
  }
}
