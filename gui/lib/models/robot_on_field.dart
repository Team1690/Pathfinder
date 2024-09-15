import "dart:ui";

class RobotOnField {
  const RobotOnField(this.pos, this.heading, this.action);
  final Offset pos;
  final double heading;
  final String action;
}
