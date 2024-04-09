import "package:flutter/cupertino.dart";
import "package:pathfinder/utils/json.dart";

const double officialFieldWidth = 16.54;
const double officialFieldHeight = 8.21;

class Field {
  const Field({
    required this.size,
  });

  factory Field.initial() => const Field(
        size: Offset(officialFieldWidth, officialFieldHeight),
      );

  Field.fromJson(final Map<String, dynamic> json)
      : size = offsetFromJson(json["size"] as Map<String, dynamic>);
  final Offset size;

  Field copyWith({
    final Offset? size,
  }) =>
      Field(
        size: size ?? this.size,
      );

  Map<String, dynamic> toJson() => <String, dynamic>{
        "size": offsetToJson(size),
      };
}
