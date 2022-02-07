import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:pathfinder/utils/coordinates_convertion.dart';
import 'package:pathfinder/utils/json.dart';
import 'package:redux/redux.dart';

const double defaultControlLength = 1;

class Point {
  final Offset position;
  final Offset inControlPoint;
  final Offset outControlPoint;
  final double heading;
  final bool useHeading;
  final String action;
  final double actionTime;
  final bool cutSegment;
  final bool isStop;

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

  factory Point.initial(Offset position) {
    return Point(
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
  }

  Point copyWith({
    Offset? position,
    Offset? inControlPoint,
    Offset? outControlPoint,
    double? heading,
    bool? useHeading,
    String? action,
    double? actionTime,
    bool? cutSegment,
    bool? isStop,
  }) {
    return Point(
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
  }

  @override // TODO: implement hashCode
  int get hashCode => super.hashCode;

  @override
  bool operator ==(Object other) {
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

  Point toUiCoord(Store store) {
    return copyWith(
      position: fieldToUiOrigin(store, metersToUiCoord(store, position)),
      inControlPoint: metersToUiCoord(store, inControlPoint),
      outControlPoint: metersToUiCoord(store, outControlPoint),
    );
  }

  // Json
  Point.fromJson(Map<String, dynamic> json)
      : position = offsetFromJson(json['position']),
        inControlPoint = offsetFromJson(json['inControlPoint']),
        outControlPoint = offsetFromJson(json['outControlPoint']),
        heading = json['heading'],
        useHeading = json['useHeading'],
        action = json['action'] ?? "",
        actionTime = json['actionTime'] ?? 0,
        cutSegment = json['cutSegment'],
        isStop = json['isStop'];

  Map<String, dynamic> toJson() {
    return {
      'position': offsetToJson(position),
      'inControlPoint': offsetToJson(inControlPoint),
      'outControlPoint': offsetToJson(outControlPoint),
      'heading': heading,
      'useHeading': useHeading,
      'action': action,
      'actionTime': actionTime,
      'cutSegment': cutSegment,
      'isStop': isStop,
    };
  }
}
