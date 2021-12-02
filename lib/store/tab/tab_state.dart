import 'package:meta/meta.dart';

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

  const TabState({
    required this.path,
    required this.robot,
    required this.field,
    required this.ui,
  });

  factory TabState.initial() {
    return TabState(
      path: Path.initial(),
      robot: Robot(),
      field: Field(),
      ui: TabUI.initial(),
    );
  }

  TabState copyWith({
    Path? path,
    Robot? robot,
    Field? field,
    TabUI? ui,
  }) {
    return TabState(
      path: path ?? this.path,
      robot: robot ?? this.robot,
      field: field ?? this.field,
      ui: ui ?? this.ui,
    );
  }
  
  //TODD Implement operator == and hashCode
}

// Path, history, robot, ui, params (optimization, trajectory), field
