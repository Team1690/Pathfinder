import "package:meta/meta.dart";
import "package:pathfinder/shortcuts/help.dart";
import "package:pathfinder/models/history.dart";
import "package:pathfinder/models/path_model.dart";
import "package:pathfinder/models/robot.dart";
import "package:pathfinder/models/tab_ui.dart";

//TODO: state classes should only have states as their init params, decide on a format for these
@immutable
class TabState {
  const TabState({
    required this.path,
    required this.robot,
    required this.ui,
    required this.history,
  });

  factory TabState.initial() => TabState(
        path: PathModel.initial(),
        robot: Robot.initial(),
        ui: TabUI.initial(),
        history: History.initial(),
      );

  TabState.fromJson(final Map<String, dynamic> json)
      : path = PathModel.fromJson(json["path"] as Map<String, dynamic>),
        robot = Robot.fromJson(json["robot"] as Map<String, dynamic>),
        ui = TabUI.fromJson(json["ui"] as Map<String, dynamic>),
        history = History.fromJson(json["history"] as Map<String, dynamic>);
  final PathModel path;
  final Robot robot;
  final TabUI ui;
  final History history;

  TabState copyWith({
    final PathModel? path,
    final Robot? robot,
    final TabUI? ui,
    final History? history,
    final Help? help,
  }) =>
      TabState(
        path: path ?? this.path,
        robot: robot ?? this.robot,
        ui: ui ?? this.ui,
        history: history ?? this.history,
      );

  Map<String, dynamic> toJson() => <String, dynamic>{
        "path": path.toJson(),
        "robot": robot.toJson(),
        "ui": ui.toJson(),
        "history": history.toJson(),
      };
}
