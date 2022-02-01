import 'package:pathfinder/models/path.dart';

const maxSavedHistory = 150;

class History {
  final List<Path> tabHistory;
  final int currentStateIndex;

  const History({
    required this.tabHistory,
    required this.currentStateIndex,
  });

  factory History.initial() {
    return History(tabHistory: [Path.initial()], currentStateIndex: 0);
  }

  History copyWith({
    List<Path>? tabHistory,
    int? currentStateIndex,
  }) {
    return History(
      tabHistory: tabHistory ?? this.tabHistory,
      currentStateIndex: currentStateIndex ?? this.currentStateIndex,
    );
  }

  // Json
  History.fromJson(Map<String, dynamic> json)
      : tabHistory =
            List<Path>.from(json['tabHistory'].map((p) => Path.fromJson(p))),
        currentStateIndex = json['currentStateIndex'];

  Map<String, dynamic> toJson() {
    return {
      'tabHistory': tabHistory,
      'currentStateIndex': currentStateIndex,
    };
  }
}
