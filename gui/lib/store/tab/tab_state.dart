import "package:meta/meta.dart";
import "package:pathfinder/shortcuts/help.dart";
import "package:pathfinder/models/history.dart";
import "package:pathfinder/models/path.dart";
import "package:pathfinder/models/field.dart";
import "package:pathfinder/models/robot.dart";
import "package:pathfinder/store/tab/tab_ui/tab_ui.dart";

//TODO: state classes should only have states as their init params, decide on a format for these
@immutable
class TabState {
  const TabState({
    required this.path,
    required this.robot,
    required this.field,
    required this.ui,
    required this.history,
  });

  factory TabState.initial() => TabState(
        path: Path.initial(),
        robot: Robot.initial(),
        field: Field.initial(),
        ui: TabUI.initial(),
        history: History.initial(),
      );

  TabState.fromJson(final Map<String, dynamic> json)
      : path = Path.fromJson(json["path"] as Map<String, dynamic>),
        robot = Robot.fromJson(json["robot"] as Map<String, dynamic>),
        field = Field.fromJson(json["field"] as Map<String, dynamic>),
        ui = TabUI.fromJson(json["ui"] as Map<String, dynamic>),
        history = History.fromJson(json["history"] as Map<String, dynamic>);
  final Path path;
  final Robot robot;
  final Field field;
  final TabUI ui;
  final History history;

  TabState copyWith({
    final Path? path,
    final Robot? robot,
    final Field? field,
    final TabUI? ui,
    final History? history,
    final Help? help,
  }) =>
      TabState(
        path: path ?? this.path,
        robot: robot ?? this.robot,
        field: field ?? this.field,
        ui: ui ?? this.ui,
        history: history ?? this.history,
      );

  Map<String, dynamic> toJson() => <String, dynamic>{
        "path": path.toJson(),
        "robot": robot.toJson(),
        "field": field.toJson(),
        "ui": ui.toJson(),
        "history": history.toJson(),
      };
}
