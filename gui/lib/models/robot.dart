import 'package:flutter/cupertino.dart';
import 'package:pathfinder/utils/coordinates_convertion.dart';
import 'package:redux/redux.dart';

class Robot {
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

  factory Robot.initial() {
    return Robot(
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
  }

  Robot copyWith({
    double? width,
    double? height,
    double? maxAcceleration,
    double? maxAngularAcceleration,
    double? maxAngularVelocity,
    double? skidAcceleration,
    double? maxJerk,
    double? maxVelocity,
    double? cycleTime,
    double? angularAccelerationPercentage,
  }) {
    return Robot(
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
  }

  @override // TODO: implement hashCode
  int get hashCode => super.hashCode;

  @override
  bool operator ==(Object other) {
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

  Robot toUiCoord(Store store) {
    final uiSize = metersToUiCoord(store, Offset(width, height));

    return copyWith(
      width: uiSize.dx,
      height: uiSize.dy,
    );
  }

  // Json
  Robot.fromJson(Map<String, dynamic> json)
      : width = json['width'],
        height = json['height'],
        maxAcceleration = json['maxAcceleration'],
        maxAngularAcceleration = json['maxAngularAcceleration'],
        maxAngularVelocity = json['maxAngularVelocity'],
        skidAcceleration = json['skidAcceleration'],
        maxJerk = json['maxJerk'],
        maxVelocity = json['maxVelocity'],
        cycleTime = json['cycleTime'],
        angularAccelerationPercentage =
            json['angularAccelerationPercentage'] ?? 0.1;

  Map<String, dynamic> toJson() {
    return {
      'width': width,
      'height': height,
      'maxAcceleration': maxAcceleration,
      'maxAngularAcceleration': maxAngularAcceleration,
      'maxAngularVelocity': maxAngularVelocity,
      'skidAcceleration': skidAcceleration,
      'maxJerk': maxJerk,
      'maxVelocity': maxVelocity,
      'cycleTime': cycleTime,
      'angularAccelerationPercentage': angularAccelerationPercentage,
    };
  }
}