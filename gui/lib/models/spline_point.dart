import "package:flutter/cupertino.dart";
import "package:pathfinder/store/app/app_state.dart";
import "package:pathfinder/utils/coordinates_convertion.dart";
import "package:pathfinder/utils/offset_extensions.dart";
import "package:redux/redux.dart";

class SplinePoint {
  SplinePoint({
    required this.position,
    required this.segmentIndex,
  });

  SplinePoint.fromJson(final Map<String, dynamic> json)
      : position =
            OffsetJson.fromJson(json["position"] as Map<String, dynamic>),
        segmentIndex = json["segmentIndex"] as int;
  final Offset position;
  final int segmentIndex;

  SplinePoint toUiCoord(final Store<AppState> store) => copyWith(
        position: fieldToUiOrigin(store, metersToUiCoord(store, position)),
      );

  SplinePoint copyWith({final Offset? position, final int? segmentIndex}) =>
      SplinePoint(
        position: position ?? this.position,
        segmentIndex: segmentIndex ?? this.segmentIndex,
      );

  Map<String, dynamic> toJson() => <String, dynamic>{
        "position": position.toJson(),
        "segmentIndex": segmentIndex,
      };
}
