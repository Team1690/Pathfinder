import "package:meta/meta.dart";

import "package:pathfinder/store/tab/tab_state.dart";

const String defaultAutoFileName = "untitled.$autoFileExtension";
const String autoFileExtension = "auto";

@immutable
class AppState {
  const AppState({
    required this.tabState,
    required this.currentTabIndex,
    required this.changesSaved,
    required this.autoFileName,
  });
  factory AppState.initial() => AppState(
        tabState: <TabState>[TabState.initial()],
        currentTabIndex: 0,
        changesSaved: true,
        autoFileName: defaultAutoFileName,
      );

  // Json
  AppState.fromJson(final Map<String, dynamic> json)
      : tabState = (json["tabState"] as List<dynamic>)
            .map(
              (final dynamic e) => TabState.fromJson(e as Map<String, dynamic>),
            )
            .toList(),
        changesSaved = json["changesSaved"] as bool,
        autoFileName = (json["autoFileName"] as String?) ?? defaultAutoFileName,
        currentTabIndex = json["currentTabIndex"] as int;

  final List<TabState> tabState;
  final int currentTabIndex;
  final bool changesSaved;
  final String autoFileName;

  TabState get currentTabState => tabState[currentTabIndex];

  AppState copyWith({
    final List<TabState>? tabState,
    final int? currentTabIndex,
    final bool? changesSaved,
    final String? autoFileName,
  }) =>
      AppState(
        tabState: tabState ?? this.tabState,
        currentTabIndex: currentTabIndex ?? this.currentTabIndex,
        changesSaved: changesSaved ?? this.changesSaved,
        autoFileName: autoFileName ?? this.autoFileName,
      );

  @override
  int get hashCode => tabState.hashCode;

  @override
  bool operator ==(final Object other) =>
      identical(this, other) ||
      other is AppState &&
          tabState == other.tabState &&
          currentTabIndex == other.currentTabIndex &&
          changesSaved == other.changesSaved &&
          autoFileName == other.autoFileName;

  Map<String, dynamic> toJson() => <String, dynamic>{
        "tabState": tabState.map((final TabState e) => e.toJson()).toList(),
        "currentTabIndex": currentTabIndex,
        "changesSaved": changesSaved,
        "autoFileName": autoFileName,
      };
}
