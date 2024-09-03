import "package:flutter/material.dart";

// TODO find nice colors
const Color primaryColor = Color.fromRGBO(66, 66, 66, 1);
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

/// Orbit blue in different degrees of opacity
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

/// Segment colors for path and timeline
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

//TODO: some how make this more nice enum?
const List<String> autoActions = <String>[
  "Stop To Shoot",
  "Force Shoot",
  "Intake autoDrive",
  "Deflect",
];
