import 'package:meta/meta.dart';

import 'package:pathfinder/store/tab/tab_state.dart';

@immutable
class AppState {
  final TabState tabState;

  const AppState({
    required this.tabState,
  });

  factory AppState.initial() {
    return AppState(
      tabState: TabState.initial(),
    );
  }

  AppState copyWith({TabState? tabState}) {
    return AppState(
      tabState: tabState ?? this.tabState,
    );
  }

  @override
  int get hashCode => tabState.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) || other is AppState && tabState == other.tabState;

  // Json
  AppState.fromJson(Map<String, dynamic> json)
      : tabState = TabState.fromJson(json['tabState']);

  Map<String, dynamic> toJson() {
    return {
      'tabState': tabState.toJson(),
    };
  }
}