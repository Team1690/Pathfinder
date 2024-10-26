import "package:flutter/cupertino.dart";
import "package:redux/redux.dart";
import "package:pathfinder_gui/store/app/app_state.dart";
import "package:pathfinder_gui/utils/offset_extensions.dart";

class SplinePoint {
  SplinePoint({
    required this.position,
    required this.segmentIndex,
  });

  SplinePoint.fromJson(final dynamic json)
      : position =
            OffsetJson.fromJson(json["position"] as Map<String, dynamic>),
        segmentIndex = json["segmentIndex"] as int;

  final Offset position;
  final int segmentIndex;

//TODO: meters to pix should be a much easier function
  SplinePoint toUiCoord(final Store<AppState> store) => copyWith(
        position: store.state.currentTabState.ui.metersToPix(position),
      );

  SplinePoint copyWith({final Offset? position, final int? segmentIndex}) =>
      SplinePoint(
        position: position ?? this.position,
        segmentIndex: segmentIndex ?? this.segmentIndex,
      );

  dynamic toJson() => <String, dynamic>{
        "position": position.toJson(),
        "segmentIndex": segmentIndex,
      };
}
