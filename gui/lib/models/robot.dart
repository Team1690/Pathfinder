import "package:flutter/cupertino.dart";
import "package:pathfinder_gui/store/app/app_state.dart";
import "package:redux/redux.dart";

class Robot {
  Robot({
    required this.width,
    required this.height,
    required this.maxVelocity,
    required this.maxAcceleration,
    required this.skidAcceleration,
    required this.maxJerk,
    required this.cycleTime,
    required this.angularAccelerationPercentage,
  });

  factory Robot.initial() => Robot(
        width: 0.48,
        height: 0.41,
        maxVelocity: 5.3,
        maxAcceleration: 7.5,
        skidAcceleration: 7.5,
        maxJerk: 50,
        cycleTime: 0.02,
        angularAccelerationPercentage: 0.1,
      );

  Robot.fromJson(final dynamic json)
      : width = json["width"] as double,
        height = json["height"] as double,
        maxAcceleration = json["maxAcceleration"] as double,
        skidAcceleration = json["skidAcceleration"] as double,
        maxJerk = json["maxJerk"] as double,
        maxVelocity = json["maxVelocity"] as double,
        cycleTime = json["cycleTime"] as double,
        angularAccelerationPercentage =
            json["angularAccelerationPercentage"] as double;

  final double width;
  final double height;
  final double maxVelocity;
  final double maxAcceleration;
  final double skidAcceleration;
  final double maxJerk;
  final double cycleTime;
  final double angularAccelerationPercentage;

  Robot copyWith({
    final double? width,
    final double? height,
    final double? maxVelocity,
    final double? maxAcceleration,
    final double? skidAcceleration,
    final double? maxJerk,
    final double? cycleTime,
    final double? angularAccelerationPercentage,
  }) =>
      Robot(
        width: width ?? this.width,
        height: height ?? this.height,
        maxVelocity: maxVelocity ?? this.maxVelocity,
        maxAcceleration: maxAcceleration ?? this.maxAcceleration,
        skidAcceleration: skidAcceleration ?? this.skidAcceleration,
        maxJerk: maxJerk ?? this.maxJerk,
        cycleTime: cycleTime ?? this.cycleTime,
        angularAccelerationPercentage:
            angularAccelerationPercentage ?? this.angularAccelerationPercentage,
      );

  @override
  int get hashCode => Object.hashAll(<dynamic>[
        width,
        height,
        maxVelocity,
        maxAcceleration,
        skidAcceleration,
        maxJerk,
        cycleTime,
        angularAccelerationPercentage,
      ]);

  @override
  bool operator ==(final Object other) =>
      other is Robot &&
      width == other.width &&
      height == other.height &&
      maxVelocity == other.maxVelocity &&
      maxAcceleration == other.maxAcceleration &&
      skidAcceleration == other.skidAcceleration &&
      maxJerk == other.maxJerk &&
      cycleTime == other.cycleTime &&
      angularAccelerationPercentage == other.angularAccelerationPercentage;

  Robot toUiCoord(final Store<AppState> store) {
    final Offset uiSize =
        store.state.currentTabState.ui.metersToPix(Offset(width, height));

    return copyWith(
      width: uiSize.dx,
      height: uiSize.dy,
    );
  }

  dynamic toJson() => <String, dynamic>{
        "width": width,
        "height": height,
        "maxVelocity": maxVelocity,
        "maxAcceleration": maxAcceleration,
        "skidAcceleration": skidAcceleration,
        "maxJerk": maxJerk,
        "cycleTime": cycleTime,
        "angularAccelerationPercentage": angularAccelerationPercentage,
      };
}
