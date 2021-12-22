import 'package:flutter/cupertino.dart';
import 'package:pathfinder/utils/json.dart';

const officialFieldWidth = 16.4846;
const officialFieldHeight = 8.1026;

class Field {
  final Offset size;

  const Field({
    required this.size,
  });

  factory Field.initial() {
    return Field(
      size: Offset(officialFieldWidth, officialFieldHeight),
    );
  }

  Field copyWith({
    Offset? size,
  }) {
    return Field(
      size: size ?? this.size,
    );
  }

  Field.fromJson(Map<String, dynamic> json)
      : size = offsetFromJson(json['size']);

  Map<String, dynamic> toJson() {
    return {
      'size': offsetToJson(size),
    };
  }
}
