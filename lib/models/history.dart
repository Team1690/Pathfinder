import 'package:pathfinder/store/tab/store.dart';

class History {
  final List<TabState> tabHistory;
  final int currentStateIndex;

  const History({
    required this.tabHistory,
    required this.currentStateIndex,
  });

  factory History.initial() {
    return History(tabHistory: [], currentStateIndex: 0);
  }

  History copyWith({
    List<TabState>? tabHistory,
    int? currentStateIndex,
  }) {
    return History(
      tabHistory: tabHistory ?? this.tabHistory,
      currentStateIndex: currentStateIndex ?? this.currentStateIndex,
    );
  }

  // Json
  History.fromJson(Map<String, dynamic> json)
      : tabHistory = List<TabState>.from(
            json['tabHistory'].map((p) => TabState.fromJson(p))),
        currentStateIndex = json['currentStateIndex'];

  Map<String, dynamic> toJson() {
    return {
      'tabHistory': tabHistory,
      'currentStateIndex': currentStateIndex,
    };
  }
}
