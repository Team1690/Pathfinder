import 'package:meta/meta.dart';

import 'package:pathfinder/store/tab/tab_state.dart';

@immutable
class AppState {
  final TabState tabState;

  const AppState({
    required this.tabState,
  });

  factory AppState.initial() {
    return AppState(
      tabState: TabState.initial(),
    );
  }

  AppState copyWith({TabState? tabState}) {
    return AppState(
      tabState: tabState ?? this.tabState,
    );
  }
}
