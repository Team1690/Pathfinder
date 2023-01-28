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

// Point
Color selectedPointColor = Color(0xffeeeeee);

const stopPointColor = Color.fromARGB(204, 224, 68, 68);
Color selectedStopPointColor = Color.fromARGB(255, 255, 83, 83);

const selectedPointHightlightColor = Color(0xffeeeeee);
const double selectedPointHighlightRadius = 5;
const selectedPointHighlightOpacity = 5;

Color getPointColor(Color defaultColor, bool isStopPoint, isFirstPoint,
    isLastPoint, isSelected) {
  var color = defaultColor;
  var selectedColor = selectedPointColor;

  if (isStopPoint) {
    selectedColor = selectedStopPointColor;
    color = stopPointColor;
  } else if (isFirstPoint) {
    selectedColor = Color(0xff34A853).withGreen(230);
    color = Color(0xff34A853);
  } else if (isLastPoint) {
    selectedColor = Color(0xffAE4335).withRed(230);
    color = Color(0xffAE4335);
  }

  return isSelected ? selectedColor : color;
}

double convertRadiusToSigma(double radius) {
  return radius * 0.57735 + 0.5;
}

const List<String> autoActions = [
  "Intake",
  "Place High Cone",
  "Place Mid Cone",
  "Place Low Cone",
  "Place High Cube",
  "Place Mid Cube",
  "Place Low Cube",
];
