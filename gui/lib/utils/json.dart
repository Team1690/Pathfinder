import "package:flutter/cupertino.dart";

//TODO: this should be a class extension
Map<String, dynamic> offsetToJson(final Offset o) => <String, dynamic>{
      "x": o.dx,
      "y": o.dy,
    };

Offset offsetFromJson(final Map<String, dynamic> j) =>
    Offset(j["x"] as double, j["y"] as double);
