import "package:flutter/cupertino.dart";
import "package:pathfinder/store/app/app_state.dart";
import "package:pathfinder/utils/coordinates_convertion.dart";
import "package:redux/redux.dart";

class Robot {
  Robot({
    required this.width,
    required this.height,
    required this.maxAcceleration,
    required this.maxAngularAcceleration,
    required this.maxAngularVelocity,
    required this.skidAcceleration,
    required this.angularAccelerationPercentage,
    required this.maxJerk,
    required this.maxVelocity,
    required this.cycleTime,
  });

  factory Robot.initial() => Robot(
        width: 0.6,
        height: 0.6,
        maxAcceleration: 7.5,
        maxAngularAcceleration: 1,
        maxAngularVelocity: 3.141,
        skidAcceleration: 7.5,
        angularAccelerationPercentage: 0.1,
        maxJerk: 50,
        maxVelocity: 3,
        cycleTime: 0.02,
      );

  // Json
  Robot.fromJson(final Map<String, dynamic> json)
      : width = json["width"] as double,
        height = json["height"] as double,
        maxAcceleration = json["maxAcceleration"] as double,
        maxAngularAcceleration = json["maxAngularAcceleration"] as double,
        maxAngularVelocity = json["maxAngularVelocity"] as double,
        skidAcceleration = json["skidAcceleration"] as double,
        maxJerk = json["maxJerk"] as double,
        maxVelocity = json["maxVelocity"] as double,
        cycleTime = json["cycleTime"] as double,
        angularAccelerationPercentage =
            (json["angularAccelerationPercentage"] as double?) ?? 0.1;
  final double width;
  final double height;
  final double maxAcceleration;
  final double maxAngularAcceleration;
  final double maxAngularVelocity;
  final double skidAcceleration;
  final double maxJerk;
  final double maxVelocity;
  final double cycleTime;
  final double angularAccelerationPercentage;

  Robot copyWith({
    final double? width,
    final double? height,
    final double? maxAcceleration,
    final double? maxAngularAcceleration,
    final double? maxAngularVelocity,
    final double? skidAcceleration,
    final double? maxJerk,
    final double? maxVelocity,
    final double? cycleTime,
    final double? angularAccelerationPercentage,
  }) =>
      Robot(
        width: width ?? this.width,
        height: height ?? this.height,
        maxAcceleration: maxAcceleration ?? this.maxAcceleration,
        maxAngularAcceleration:
            maxAngularAcceleration ?? this.maxAngularAcceleration,
        maxAngularVelocity: maxAngularVelocity ?? this.maxAngularVelocity,
        skidAcceleration: skidAcceleration ?? this.skidAcceleration,
        maxJerk: maxJerk ?? this.maxJerk,
        maxVelocity: maxVelocity ?? this.maxVelocity,
        cycleTime: cycleTime ?? this.cycleTime,
        angularAccelerationPercentage:
            angularAccelerationPercentage ?? this.angularAccelerationPercentage,
      );

  @override
  int get hashCode => Object.hashAll(<dynamic>[
        width,
        height,
        maxAcceleration,
        maxAngularAcceleration,
        maxAngularVelocity,
        skidAcceleration,
        maxJerk,
        maxVelocity,
        cycleTime,
        angularAccelerationPercentage,
      ]);

  @override
  bool operator ==(final Object other) {
    if (other is Robot) {
      return width == other.width &&
          height == other.height &&
          maxAcceleration == other.maxAcceleration &&
          maxAngularAcceleration == maxAngularAcceleration &&
          maxAngularVelocity == maxAngularVelocity &&
          skidAcceleration == skidAcceleration &&
          maxJerk == maxJerk &&
          maxVelocity == maxVelocity &&
          cycleTime == cycleTime &&
          angularAccelerationPercentage == angularAccelerationPercentage;
    }

    return false;
  }

  Robot toUiCoord(final Store<AppState> store) {
    final Offset uiSize = metersToUiCoord(store, Offset(width, height));

    return copyWith(
      width: uiSize.dx,
      height: uiSize.dy,
    );
  }

  Map<String, dynamic> toJson() => <String, dynamic>{
        "width": width,
        "height": height,
        "maxAcceleration": maxAcceleration,
        "maxAngularAcceleration": maxAngularAcceleration,
        "maxAngularVelocity": maxAngularVelocity,
        "skidAcceleration": skidAcceleration,
        "maxJerk": maxJerk,
        "maxVelocity": maxVelocity,
        "cycleTime": cycleTime,
        "angularAccelerationPercentage": angularAccelerationPercentage,
      };
}
