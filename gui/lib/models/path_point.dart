import "dart:math";

import "package:flutter/cupertino.dart";
import "package:pathfinder_gui/store/app/app_state.dart";
import "package:pathfinder_gui/utils/offset_extensions.dart";
import "package:pathfinder_gui/views/editor/point_type.dart";
import "package:redux/redux.dart";

//TODO: move this value to constants
const double defaultControlLength = 1;

class PathPoint {
  PathPoint({
    required this.position,
    required this.inControlPoint,
    required this.outControlPoint,
    required this.heading,
    required this.useHeading,
    required this.cutSegment,
    required this.isStop,
    required this.action,
    required this.actionTime,
  });
  factory PathPoint.initial(final Offset position) => PathPoint(
        position: position,
        inControlPoint: Offset.fromDirection(pi / 4, defaultControlLength),
        outControlPoint:
            Offset.fromDirection((pi / 4) + pi, defaultControlLength),
        heading: 0,
        useHeading: true,
        cutSegment: false,
        isStop: false,
        action: "",
        actionTime: 0,
      );

  PathPoint.fromJson(final dynamic json)
      : position =
            OffsetJson.fromJson(json["position"] as Map<String, dynamic>),
        inControlPoint =
            OffsetJson.fromJson(json["inControlPoint"] as Map<String, dynamic>),
        outControlPoint = OffsetJson.fromJson(
          json["outControlPoint"] as Map<String, dynamic>,
        ),
        heading = json["heading"] as double,
        useHeading = json["useHeading"] as bool,
        cutSegment = json["cutSegment"] as bool,
        isStop = json["isStop"] as bool,
        action = json["action"] as String,
        actionTime = json["actionTime"] as double;

  final Offset position;
  final Offset inControlPoint;
  final Offset outControlPoint;
  final double heading;
  final bool useHeading;
  final bool cutSegment;
  final bool isStop;
  final String action;
  final double actionTime;

  PointType pointType(final int indexInPath, final int pathLength) {
    if (isStop) return PointType.stop;
    if (indexInPath == 0) return PointType.first;
    if (indexInPath == pathLength - 1) return PointType.last;
    return PointType.regular;
  }

  PathPoint copyWith({
    final Offset? position,
    final Offset? inControlPoint,
    final Offset? outControlPoint,
    final double? heading,
    final bool? useHeading,
    final bool? cutSegment,
    final bool? isStop,
    final String? action,
    final double? actionTime,
  }) =>
      PathPoint(
        position: position ?? this.position,
        inControlPoint: inControlPoint ?? this.inControlPoint,
        outControlPoint: outControlPoint ?? this.outControlPoint,
        heading: heading ?? this.heading,
        useHeading: useHeading ?? this.useHeading,
        cutSegment: cutSegment ?? this.cutSegment,
        isStop: isStop ?? this.isStop,
        action: action ?? this.action,
        actionTime: actionTime ?? this.actionTime,
      );

  @override
  int get hashCode => Object.hashAll(<dynamic>[
        position,
        inControlPoint,
        outControlPoint,
        heading,
        useHeading,
        cutSegment,
        isStop,
        action,
        actionTime,
      ]);

  @override
  bool operator ==(final Object other) =>
      other is PathPoint &&
      position == other.position &&
      inControlPoint == other.inControlPoint &&
      outControlPoint == other.outControlPoint &&
      heading == other.heading &&
      useHeading == other.useHeading &&
      cutSegment == other.cutSegment &&
      isStop == other.isStop &&
      action == other.action &&
      actionTime == other.actionTime;

  PathPoint toUiCoord(final Store<AppState> store) => copyWith(
        position: store.state.currentTabState.ui.metersToPix(position),
        inControlPoint:
            store.state.currentTabState.ui.metersToPix(inControlPoint),
        outControlPoint:
            store.state.currentTabState.ui.metersToPix(outControlPoint),
      );

  dynamic toJson() => <String, dynamic>{
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
