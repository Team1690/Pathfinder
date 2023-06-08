import "package:pathfinder/models/path.dart";
import "package:pathfinder/store/tab/store.dart";

const String initialActionName = "Initial";
const int maxSavedHistory = 50;

class HistoryStamp {
  const HistoryStamp({
    required this.action,
    required this.path,
  });

  factory HistoryStamp.fromReducer(
    final TabAction action,
    final Path path,
  ) =>
      HistoryStamp(
        action: action.toString(),
        path: path,
      );

  factory HistoryStamp.initial() => HistoryStamp(
        action: initialActionName,
        path: Path.initial(),
      );

  // Json
  HistoryStamp.fromJson(final Map<String, dynamic> json)
      : action = json["action"] as String,
        path = Path.fromJson(json["path"] as Map<String, dynamic>);
  final String action;
  final Path path;

  Map<String, dynamic> toJson() => <String, dynamic>{
        "action": action,
        "path": path,
      };
}

class History {
  const History({
    required this.pathHistory,
    required this.currentStateIndex,
  });

  factory History.initial() => History(
        pathHistory: <HistoryStamp>[HistoryStamp.initial()],
        currentStateIndex: 0,
      );

  // Json
  History.fromJson(final Map<String, dynamic> json)
      : pathHistory = List<HistoryStamp>.from(
          (json["tabHistory"] as List<Map<String, dynamic>>)
              .map(HistoryStamp.fromJson),
        ),
        currentStateIndex = json["currentStateIndex"] as int;
  final List<HistoryStamp> pathHistory;
  final int currentStateIndex;

  History copyWith({
    final List<HistoryStamp>? pathHistory,
    final int? currentStateIndex,
  }) =>
      History(
        pathHistory: pathHistory ?? this.pathHistory,
        currentStateIndex: currentStateIndex ?? this.currentStateIndex,
      );

  Map<String, dynamic> toJson() => <String, dynamic>{
        "tabHistory": pathHistory,
        "currentStateIndex": currentStateIndex,
      };
}
