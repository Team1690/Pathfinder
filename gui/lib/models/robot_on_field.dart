import "dart:ui";

import "package:orbit_standard_library/orbit_standard_library.dart";

class RobotOnField {
  const RobotOnField(this.pos, this.heading);
  final Offset pos;
  final double heading;
}

Map<String, dynamic> robotToJson(final Optional<RobotOnField> robot) =>
    switch (robot) {
      Some<RobotOnField>(some: final RobotOnField roobt) => <String, dynamic>{
          "robot": <String, dynamic>{
            "x": roobt.pos.dx,
            "y": roobt.pos.dy,
            "heading": roobt.heading,
          },
        },
      None<RobotOnField>() => <String, dynamic>{
          "robot": null,
        },
    };

Optional<RobotOnField> robotOnFieldFromJson(final dynamic json) =>
    switch (json) {
      null => None<RobotOnField>(),
      <String, dynamic>{
        "x": final double x,
        "y": final double y,
        "heading": final double heading,
      } =>
        Some<RobotOnField>(RobotOnField(Offset(x, y), heading)),
      _ => throw Exception("Invalid robot json")
    };
