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

  Robot({
    required this.width,
    required this.height,
    required this.maxAcceleration,
    required this.maxAngularAcceleration,
    required this.maxAngularVelocity,
    required this.skidAcceleration,
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
          cycleTime == cycleTime;
    }

    return false;
  }
}
