import 'package:pathfinder/models/path.dart';
import 'package:pathfinder/store/tab/store.dart';

const initialActionName = "Initial";
const maxSavedHistory = 50;

class HistoryStamp {
  final String action;
  final Path path;

  const HistoryStamp({
    required this.action,
    required this.path,
  });

  factory HistoryStamp.fromReducer(
    TabAction action,
    Path path,
  ) {
    return HistoryStamp(
      action: action.toString(),
      path: path,
    );
  }

  factory HistoryStamp.initial() {
    return HistoryStamp(
      action: initialActionName,
      path: Path.initial(),
    );
  }

  // Json
  HistoryStamp.fromJson(Map<String, dynamic> json)
      : action = json['action'],
        path = Path.fromJson(json['path']);

  Map<String, dynamic> toJson() {
    return {
      'action': action,
      'path': path,
    };
  }
}

class History {
  final List<HistoryStamp> pathHistory;
  final int currentStateIndex;

  const History({
    required this.pathHistory,
    required this.currentStateIndex,
  });

  factory History.initial() {
    return History(pathHistory: [HistoryStamp.initial()], currentStateIndex: 0);
  }

  History copyWith({
    List<HistoryStamp>? pathHistory,
    int? currentStateIndex,
  }) {
    return History(
      pathHistory: pathHistory ?? this.pathHistory,
      currentStateIndex: currentStateIndex ?? this.currentStateIndex,
    );
  }

  // Json
  History.fromJson(Map<String, dynamic> json)
      : pathHistory = List<HistoryStamp>.from(
            json['tabHistory'].map((p) => HistoryStamp.fromJson(p))),
        currentStateIndex = json['currentStateIndex'];

  Map<String, dynamic> toJson() {
    return {
      'tabHistory': pathHistory,
      'currentStateIndex': currentStateIndex,
    };
  }
}
