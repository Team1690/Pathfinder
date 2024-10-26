import "package:pathfinder_gui/store/tab/tab_state.dart";

//TODO: move to constants
const String defaultAutoFileName = "untitled.$autoFileExtension";
const String autoFileExtension = "auton";

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

  final List<TabState> tabState;
  final int currentTabIndex;
  final bool changesSaved;
  final String autoFileName;

  TabState get currentTabState => tabState[currentTabIndex];

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

  static AppState fromJson(final dynamic json) => json == null
      ? AppState.initial()
      : AppState(
          tabState: (json["tabState"] as List<dynamic>)
              .map(TabState.fromJson)
              .toList(),
          changesSaved: json["changesSaved"] as bool,
          autoFileName: json["autoFileName"] as String,
          currentTabIndex: json["currentTabIndex"] as int,
        );

  dynamic toJson() => <String, dynamic>{
        "tabState": tabState.map((final TabState e) => e.toJson()).toList(),
        "currentTabIndex": currentTabIndex,
        "changesSaved": changesSaved,
        "autoFileName": autoFileName,
      };
}
