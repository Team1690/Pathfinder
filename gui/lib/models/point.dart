import "dart:math";

import "package:flutter/cupertino.dart";
import "package:pathfinder/store/app/app_state.dart";
import "package:pathfinder/utils/coordinates_convertion.dart";
import "package:pathfinder/utils/json.dart";
import "package:redux/redux.dart";

const double defaultControlLength = 1;

class Point {
  Point({
    required this.position,
    required this.inControlPoint,
    required this.outControlPoint,
    required this.heading,
    required this.useHeading,
    required this.action,
    required this.actionTime,
    required this.cutSegment,
    required this.isStop,
  });
  factory Point.initial(final Offset position) => Point(
        position: position,
        inControlPoint: Offset.fromDirection(pi / 4, defaultControlLength),
        outControlPoint:
            Offset.fromDirection((pi / 4) + pi, defaultControlLength),
        heading: 0,
        useHeading: true,
        action: "",
        actionTime: 0,
        cutSegment: false,
        isStop: false,
      );

  // Json
  Point.fromJson(final Map<String, dynamic> json)
      : position = offsetFromJson(json["position"] as Map<String, dynamic>),
        inControlPoint =
            offsetFromJson(json["inControlPoint"] as Map<String, dynamic>),
        outControlPoint =
            offsetFromJson(json["outControlPoint"] as Map<String, dynamic>),
        heading = json["heading"] as double,
        useHeading = json["useHeading"] as bool,
        action = (json["action"] as String?) ?? "",
        actionTime = (json["actionTime"] as double?) ?? 0,
        cutSegment = json["cutSegment"] as bool,
        isStop = json["isStop"] as bool;
  final Offset position;
  final Offset inControlPoint;
  final Offset outControlPoint;
  final double heading;
  final bool useHeading;
  final String action;
  final double actionTime;
  final bool cutSegment;
  final bool isStop;

  Point copyWith({
    final Offset? position,
    final Offset? inControlPoint,
    final Offset? outControlPoint,
    final double? heading,
    final bool? useHeading,
    final String? action,
    final double? actionTime,
    final bool? cutSegment,
    final bool? isStop,
  }) =>
      Point(
        position: position ?? this.position,
        inControlPoint: inControlPoint ?? this.inControlPoint,
        outControlPoint: outControlPoint ?? this.outControlPoint,
        heading: heading ?? this.heading,
        useHeading: useHeading ?? this.useHeading,
        action: action ?? this.action,
        actionTime: actionTime ?? this.actionTime,
        cutSegment: cutSegment ?? this.cutSegment,
        isStop: isStop ?? this.isStop,
      );

  @override
  int get hashCode => Object.hashAll(<dynamic>[
        position,
        inControlPoint,
        outControlPoint,
        heading,
        useHeading,
        action,
        actionTime,
        cutSegment,
        isStop
      ]);

  @override
  bool operator ==(final Object other) {
    if (other is Point) {
      return position == other.position &&
          inControlPoint == other.inControlPoint &&
          outControlPoint == other.outControlPoint &&
          heading == other.heading &&
          useHeading == other.useHeading &&
          cutSegment == other.cutSegment &&
          isStop == other.isStop &&
          action == other.action &&
          actionTime == other.actionTime;
    }

    return false;
  }

  Point toUiCoord(final Store<AppState> store) => copyWith(
        position: fieldToUiOrigin(store, metersToUiCoord(store, position)),
        inControlPoint: metersToUiCoord(store, inControlPoint),
        outControlPoint: metersToUiCoord(store, outControlPoint),
      );

  Map<String, dynamic> toJson() => <String, dynamic>{
        "position": offsetToJson(position),
        "inControlPoint": offsetToJson(inControlPoint),
        "outControlPoint": offsetToJson(outControlPoint),
        "heading": heading,
        "useHeading": useHeading,
        "action": action,
        "actionTime": actionTime,
        "cutSegment": cutSegment,
        "isStop": isStop,
      };
}
