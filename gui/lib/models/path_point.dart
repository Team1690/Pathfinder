import "dart:math";

import "package:flutter/cupertino.dart";
import "package:pathfinder/store/app/app_state.dart";
import "package:pathfinder/utils/offset_extensions.dart";
import "package:redux/redux.dart";

//TODO: move this value to constants
const double defaultControlLength = 1;

//TODO: add index to path point so to minimize as map :)
class PathPoint {
  PathPoint({
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
  factory PathPoint.initial(final Offset position) => PathPoint(
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
  PathPoint.fromJson(final dynamic json)
      : position =
            OffsetJson.fromJson(json["position"] as Map<String, dynamic>),
        inControlPoint =
            OffsetJson.fromJson(json["inControlPoint"] as Map<String, dynamic>),
        outControlPoint = OffsetJson.fromJson(
            json["outControlPoint"] as Map<String, dynamic>),
        heading = json["heading"] as double,
        useHeading = json["useHeading"] as bool,
        action = (json["action"] as String?) ?? "",
        actionTime = (json["actionTime"] as double?) ?? 0,
        cutSegment = json["cutSegment"] as bool,
        isStop = json["isStop"] as bool;
  //TODO: add pointtype getter? to pathpoint
  final Offset position;
  final Offset inControlPoint;
  final Offset outControlPoint;
  final double heading;
  final bool useHeading;
  final String action;
  final double actionTime;
  final bool cutSegment;
  final bool isStop;

  PathPoint copyWith({
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
      PathPoint(
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
        isStop,
      ]);

  @override
  bool operator ==(final Object other) {
    if (other is PathPoint) {
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

  PathPoint toUiCoord(final Store<AppState> store) => copyWith(
        position: store.state.currentTabState.ui.metersToPix(position),
        inControlPoint:
            store.state.currentTabState.ui.metersToPix(inControlPoint),
        outControlPoint:
            store.state.currentTabState.ui.metersToPix(outControlPoint),
      );

  Map<String, dynamic> toJson() => <String, dynamic>{
        "position": position.toJson(),
        "inControlPoint": inControlPoint.toJson(),
        "outControlPoint": outControlPoint.toJson(),
        "heading": heading,
        "useHeading": useHeading,
        "action": action,
        "actionTime": actionTime,
        "cutSegment": cutSegment,
        "isStop": isStop,
      };
}
