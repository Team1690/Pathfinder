import "dart:ui";

extension OffsetJson on Offset {
  Map<String, dynamic> toJson() => <String, dynamic>{
        "x": dx,
        "y": dy,
      };

  static Offset fromJson(final Map<String, dynamic> json) => Offset(
        json["x"] as double,
        json["y"] as double,
      );

  Offset scaleBy(final double scaler) => scale(scaler, scaler);
}
