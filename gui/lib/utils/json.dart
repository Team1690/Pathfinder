import "package:flutter/cupertino.dart";

Map<String, dynamic> offsetToJson(final Offset o) => <String, dynamic>{
      "x": o.dx,
      "y": o.dy,
    };

Offset offsetFromJson(final Map<String, dynamic> j) =>
    Offset(j["x"] as double, j["y"] as double);
