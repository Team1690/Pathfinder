import 'package:flutter/cupertino.dart';
import 'package:pathfinder/services/pathfinder.dart';
import 'package:pathfinder/store/tab/store.dart';
import 'package:redux_thunk/redux_thunk.dart';
import 'package:redux/redux.dart';

ThunkAction addPointThunk(Offset position) {
  return (Store store) async {
    store.dispatch(AddPointToPath(position));
    store.dispatch(updateSplineThunk());
  };
}

ThunkAction removePointThunk(int index) {
  return (Store store) async {
    store.dispatch(DeletePointFromPath(index));
    store.dispatch(updateSplineThunk());
  };
}

ThunkAction editPointThunk({
  required final int pointIndex,
  final Offset? position,
  final Offset? inControlPoint,
  final Offset? outControlPoint,
  final double? heading,
  final bool? useHeading,
  final List<String>? actions
}) {
  return (Store store) async {
    store.dispatch(EditPoint(
      pointIndex: pointIndex,
      position: position,
      inControlPoint: inControlPoint,
      outControlPoint: outControlPoint,
      heading: heading,
      useHeading: useHeading,
      actions: actions
    ));
    store.dispatch(updateSplineThunk());
  };
}

ThunkAction endDragThunk(int index, Offset position) {
  return editPointThunk(pointIndex:  index, position: position);
}

ThunkAction endInControlDragThunk(int index, Offset position) {
  return editPointThunk(pointIndex:  index, inControlPoint: Offset(position.dx, position.dy));
}

ThunkAction endOutControlDragThunk(int index, Offset position) {
  return editPointThunk(pointIndex:  index, outControlPoint: Offset(position.dx, position.dy));
}

ThunkAction endHeadingDragThunk(int index, double heading) {
  return editPointThunk(pointIndex:  index, heading: heading);
}

ThunkAction updateSplineThunk() {
  return (Store store) async {
    try {
      final res = await PathFinderService.calculateSpline(
        store.state.tabState.path.points,
        0.1,
      );

      store.dispatch(SplineCalculated(res.evaluatedPoints));
    } catch (e) {
      store.dispatch(ServerError(e.toString()));
    }
  };
}
