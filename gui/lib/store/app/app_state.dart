import "package:meta/meta.dart";

import "package:pathfinder/store/tab/tab_state.dart";

@immutable
class AppState {
  const AppState({
    required this.tabState,
  });
  factory AppState.initial() => AppState(
        tabState: TabState.initial(),
      );

  // Json
  AppState.fromJson(final Map<String, dynamic> json)
      : tabState = TabState.fromJson(json["tabState"] as Map<String, dynamic>);
  final TabState tabState;

  AppState copyWith({final TabState? tabState}) => AppState(
        tabState: tabState ?? this.tabState,
      );

  @override
  int get hashCode => tabState.hashCode;

  @override
  bool operator ==(final Object other) =>
      identical(this, other) || other is AppState && tabState == other.tabState;

  Map<String, dynamic> toJson() => <String, dynamic>{
        "tabState": tabState.toJson(),
      };
}
