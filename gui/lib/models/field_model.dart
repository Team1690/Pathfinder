import "package:flutter/cupertino.dart";
import "package:pathfinder/utils/offset_extensions.dart";

//TODO: move to constants
const double officialFieldWidth = 16.54;
const double officialFieldHeight = 8.21;

//TODO: this seems constant like help remove this from state?
class FieldModel {
  const FieldModel({
    required this.size,
  });

  factory FieldModel.initial() => const FieldModel(
        size: Offset(officialFieldWidth, officialFieldHeight),
      );

  FieldModel.fromJson(final Map<String, dynamic> json)
      : size = OffsetJson.fromJson(json["size"] as Map<String, dynamic>);
  final Offset size;

  FieldModel copyWith({
    final Offset? size,
  }) =>
      FieldModel(
        size: size ?? this.size,
      );

  Map<String, dynamic> toJson() => <String, dynamic>{
        "size": size.toJson(),
      };
}
