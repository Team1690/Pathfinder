import 'package:flutter/cupertino.dart';
import 'package:pathfinder/services/pathfinder.dart';
import 'package:pathfinder/store/tab/store.dart';
import 'package:redux_thunk/redux_thunk.dart';
import 'package:redux/redux.dart';

ThunkAction addPointThunk(Offset position) {
  return (Store store) async {
    store.dispatch(AddPointToPath(position: position));
    store.dispatch(updateSplineThunk());
  };
}

ThunkAction removePointThunk(int index) {
  return (Store store) async {
    store.dispatch(DeletePointFromPath(index: index));
    store.dispatch(updateSplineThunk());
  };
}

ThunkAction updateSplineThunk() {
  return (Store store) async {
    try {
      final res = await PathFinderService.calculateSpline(
        store.state.tabState.path.points,
        10,
      );

      store.dispatch(SplineCalculated(res.evaluatedPoints));
    } catch (e) {
      store.dispatch(ServerError(e.toString()));
    }
  };
}
