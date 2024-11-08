import "package:pathfinder_gui/store/app/app_actions.dart";
import "package:pathfinder_gui/store/app/app_state.dart";
import "package:pathfinder_gui/store/tab/store.dart";
import "package:redux/redux.dart";

class TabMiddleware extends MiddlewareClass<AppState> {
  @override
  dynamic call(
    final Store<AppState> store,
    final dynamic action,
    final NextDispatcher next,
  ) {
    if (action is TabChangingAction) {
      store.dispatch(AnimationRunning(running: false));
    }
    next(action);
  }
}
