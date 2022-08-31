import 'package:flutter/cupertino.dart';

dynamic offsetToJson(Offset o) {
  return {
    'x': o.dx,
    'y': o.dy,
  };
}

Offset offsetFromJson(Map j) {
  return Offset(j['x'], j['y']);
}
