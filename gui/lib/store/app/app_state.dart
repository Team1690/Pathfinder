import "package:meta/meta.dart";

import "package:pathfinder/store/tab/tab_state.dart";

@immutable
class AppState {
  const AppState({
    required this.tabState,
    required this.currentTabIndex,
  });
  factory AppState.initial() => AppState(
        tabState: <TabState>[TabState.initial()],
        currentTabIndex: 0,
      );

  // Json
  AppState.fromJson(final Map<String, dynamic> json)
      : tabState = (json["tabState"] as List<dynamic>)
            .map(
              (final dynamic e) => TabState.fromJson(e as Map<String, dynamic>),
            )
            .toList(),
        currentTabIndex = json["currentTabIndex"] as int;
  final List<TabState> tabState;
  final int currentTabIndex;

  AppState copyWith({
    final List<TabState>? tabState,
    final int? currentTabIndex,
  }) =>
      AppState(
        tabState: tabState ?? this.tabState,
        currentTabIndex: currentTabIndex ?? this.currentTabIndex,
      );

  @override
  int get hashCode => tabState.hashCode;

  @override
  bool operator ==(final Object other) =>
      identical(this, other) ||
      other is AppState &&
          tabState == other.tabState &&
          currentTabIndex == other.currentTabIndex;

  Map<String, dynamic> toJson() => <String, dynamic>{
        "tabState": tabState.map((final TabState e) => e.toJson()).toList(),
        "currentTabIndex": currentTabIndex,
      };
}
