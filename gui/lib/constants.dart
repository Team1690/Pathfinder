import "package:flutter/material.dart";

// TODO find nice colors
final Color primaryColor = Colors.grey.shade800;
const Color secondaryColor = const Color(0xFF2A2D3E);

const double defaultPadding = 20;
const double defaultRadius = 10;

const Color primary = Color(0xff393939);
const Color secondary = Color(0xff0078D7);
const Color white = Color(0xffffffff);
const Color gray = Color(0xff545454);
const Color blue = Color(0xff7D8AFF);
const Color red = Color(0xffE58585);
const Color green = Color(0xff7CE27A);

const Map<int, Color> orbitColors = <int, Color>{
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

// Segment colors
List<Color> segmentColors = <Color>[
  const Color.fromARGB(255, 86, 86, 255),
  const Color.fromARGB(255, 255, 44, 44),
  const Color.fromARGB(255, 61, 255, 43),
  const Color.fromARGB(255, 255, 217, 0),
  const Color.fromARGB(255, 0, 247, 255),
  const Color.fromARGB(255, 255, 0, 255),
];

/// Gets the segment color from [segmentColors] depending on [index]
Color getSegmentColor(final int index) =>
    segmentColors[index % segmentColors.length];

// Point
const Color selectedPointColor = const Color(0xffeeeeee);

const Color stopPointColor = Color.fromARGB(204, 224, 68, 68);
const Color selectedStopPointColor = const Color.fromARGB(255, 255, 83, 83);

const Color selectedPointHightlightColor = Color(0xffeeeeee);
const double selectedPointHighlightRadius = 5;
const int selectedPointHighlightOpacity = 5;
//TODO: introduce Point type enum
Color getPointColor(
  final Color defaultColor,
  final bool isStopPoint,
  final bool isFirstPoint,
  final bool isLastPoint,
  final bool isSelected,
) {
  Color color = defaultColor;
  Color selectedColor = selectedPointColor;

  if (isStopPoint) {
    selectedColor = selectedStopPointColor;
    color = stopPointColor;
  } else if (isFirstPoint) {
    selectedColor = const Color(0xff34A853).withGreen(230);
    color = const Color(0xff34A853);
  } else if (isLastPoint) {
    selectedColor = const Color(0xffAE4335).withRed(230);
    color = const Color(0xffAE4335);
  }

  return isSelected ? selectedColor : color;
}

//TODO: some how make this more nice enum?
const List<String> autoActions = <String>[
  "Stop To Shoot",
  "Force Shoot",
  "Intake autoDrive",
  "Deflect",
];
