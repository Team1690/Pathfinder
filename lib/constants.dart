import 'package:flutter/material.dart';

// TODO find nice colors
final Color primaryColor = Colors.grey.shade800;
const secondaryColor = const Color(0xFF2A2D3E);

const double defaultPadding = 20;
const double defaultRadius = 10;

const Color primary = Color(0xff393939);
const Color secondary = Color(0xff0078D7);
const Color white = Color(0xffffffff);
const Color gray = Color(0xff545454);
const Color blue = Color(0xff7D8AFF);
const Color red = Color(0xffE58585);
const Color green = Color(0xff7CE27A);

const Map<int, Color> orbitColors = {
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

// Sement colors
List<Color> segmentColors = [
  Color.fromARGB(255, 86, 86, 255),
  Color.fromARGB(255, 255, 44, 44),
  Color.fromARGB(255, 61, 255, 43),
  Color.fromARGB(255, 255, 217, 0),
];

Color getSegmentColor(int index) {
  final colorIndex = index % segmentColors.length;
  return segmentColors[colorIndex];
}

// Selected point
Color selectedPointColor = Color(0xffeeeeee);
const double selectedPointHighlightRadius = 5;
const selectedPointHighlightOpacity = 5;

// UI utils
double convertRadiusToSigma(double radius) {
  return radius * 0.57735 + 0.5;
}
