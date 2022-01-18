import 'dart:convert';
import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:pathfinder/services/pathfinder.dart';
import 'package:pathfinder/store/tab/store.dart';
import 'package:redux_thunk/redux_thunk.dart';
import 'package:redux/redux.dart';

ThunkAction addPointThunk(Offset? position, int segmentIndex, int insertIndex) {
  return (Store store) async {
    store.dispatch(AddPointToPath(position, segmentIndex, insertIndex));
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
  final bool? cutSegment,
  final bool? isStop,
  final String? action,
  final double? actionTime,
}) {
  return (Store store) async {
    store.dispatch(EditPoint(
      pointIndex: pointIndex,
      position: position,
      inControlPoint: inControlPoint,
      outControlPoint: outControlPoint,
      heading: heading,
      useHeading: useHeading,
      cutSegment: cutSegment,
      isStop: isStop,
      action: action,
      actionTime: actionTime,
    ));
    store.dispatch(updateSplineThunk());
  };
}

ThunkAction endDragThunk(int index, Offset position) {
  return editPointThunk(pointIndex: index, position: position);
}

ThunkAction endInControlDragThunk(int index, Offset position) {
  return editPointThunk(pointIndex: index, inControlPoint: position);
}

ThunkAction endOutControlDragThunk(int index, Offset position) {
  return editPointThunk(pointIndex: index, outControlPoint: position);
}

ThunkAction endControlDrag(int index, Offset inPosition, Offset outPosition) {
  return editPointThunk(
      pointIndex: index,
      outControlPoint: outPosition,
      inControlPoint: inPosition);
}

ThunkAction endHeadingDragThunk(int index, double heading) {
  return editPointThunk(pointIndex: index, heading: heading);
}

ThunkAction updateSplineThunk() {
  return (Store store) async {
    store.dispatch(calculateSplineThunk());
    // TODO: throttle the trejectory request before adding them to here
    // store.dispatch(calculateTrajectoryThunk());
  };
}

ThunkAction editSegmentThunk({
  required int index,
  required double? velocity,
  required bool? isHidden,
}) {
  return (Store store) {
    store.dispatch(
        EditSegment(index: index, velocity: velocity, isHidden: isHidden));
  };
}

ThunkAction calculateSplineThunk() {
  return (Store store) async {
    try {
      final res = await PathFinderService.calculateSpline(
        store.state.tabState.path.segments,
        store.state.tabState.path.points,
        0.1,
      );

      store.dispatch(SplineCalculated(res.evaluatedPoints));
    } catch (e) {
      store.dispatch(ServerError(e.toString()));
    }
  };
}

ThunkAction calculateTrajectoryThunk() {
  return (Store store) async {
    store.dispatch(TrajectoryInProgress());

    try {
      final res = await PathFinderService.calculateTrjactory(
        store.state.tabState.path.points,
        store.state.tabState.path.segments,
        store.state.tabState.robot,
        store.state.tabState.ui.trajectoryFileName,
      );

      store.dispatch(TrajectoryCalculated(res.swervePoints));
    } catch (e) {
      store.dispatch(ServerError(e.toString()));
    }
  };
}

ThunkAction openFileThunk() {
  return (Store store) async {
    FilePickerResult? file;
    file = await FilePicker.platform.pickFiles(withData: true);
    if (file != null) {
      store.dispatch(OpenFile(
        String.fromCharCodes(file.files.first.bytes!.toList()),
      ));
    }
  };
}

ThunkAction saveFileThunk() {
  return (Store store) async {
    String? filePath;
    filePath = await FilePicker.platform.saveFile(fileName: 'path.temp-state');

    if (filePath != null) {
      File file = File(filePath);
      file.writeAsStringSync(jsonEncode(store.state));
    }
  };
}
