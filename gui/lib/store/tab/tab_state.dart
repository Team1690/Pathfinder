import 'package:meta/meta.dart';
import 'package:pathfinder/models/history.dart';

import 'package:pathfinder/models/path.dart';
import 'package:pathfinder/models/field.dart';
import 'package:pathfinder/models/robot.dart';
import 'package:pathfinder/store/tab/tab_ui/tab_ui.dart';

@immutable
class TabState {
  final Path path;
  final Robot robot;
  final Field field;
  final TabUI ui;
  final History history;

  const TabState({
    required this.path,
    required this.robot,
    required this.field,
    required this.ui,
    required this.history,
  });

  factory TabState.initial() {
    return TabState(
      path: Path.initial(),
      robot: Robot.initial(),
      field: Field.initial(),
      ui: TabUI.initial(),
      history: History.initial(),
    );
  }

  TabState copyWith({
    Path? path,
    Robot? robot,
    Field? field,
    TabUI? ui,
    History? history,
  }) {
    return TabState(
      path: path ?? this.path,
      robot: robot ?? this.robot,
      field: field ?? this.field,
      ui: ui ?? this.ui,
      history: history ?? this.history,
    );
  }

  TabState.fromJson(Map<String, dynamic> json)
      : path = Path.fromJson(json['path']),
        robot = Robot.fromJson(json['robot']),
        field = Field.fromJson(json['field']),
        ui = TabUI.fromJson(json['ui']),
        history = History.fromJson(json['history']);

  Map<String, dynamic> toJson() {
    return {
      'path': path.toJson(),
      'robot': robot.toJson(),
      'field': field.toJson(),
      'ui': ui.toJson(),
      'history': history.toJson(),
    };
  }
}