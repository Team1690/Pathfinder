import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:file_picker/file_picker.dart';
import 'package:pathfinder/services/pathfinder.dart';
import 'package:pathfinder/store/tab/store.dart';
import 'package:pathfinder/store/tab/tab_ui/tab_ui.dart';
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

ThunkAction pathUndoThunk() {
  return (Store store) {
    store.dispatch(PathUndo());
    store.dispatch(calculateSplineThunk());
  };
}

ThunkAction pathRedoThunk() {
  return (Store store) {
    store.dispatch(PathRedo());
    store.dispatch(calculateSplineThunk());
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
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        dialogTitle: "Select an auto file",
        allowedExtensions: ["auto", "*"],
        lockParentWindow: false,
        type: FileType.custom,
      );

      if (result?.paths.first == null) return;
      File file = File(result!.files.first.path ?? "");

      final content = await file.readAsString();

      store.dispatch(OpenFile(
        fileContent: content,
        fileName: file.path,
      ));
    } catch (e) {}
  };
}

ThunkAction saveFileThunk(bool isSaveAs) {
  return (Store store) async {
    try {
      var savingPath = store.state.tabState.ui.autoFileName;

      // In case of an initial save always open the 'save as' dialog
      if (savingPath == defaultAutoFileName) {
        isSaveAs = true;
      }

      if (isSaveAs) {
        var fileName = basename(savingPath);

        // Make sure the suggested file extension is auto
        if (extension(fileName) != ".$autoFileExtension") {
          fileName += ".$autoFileExtension";
        }

        final result = await FilePicker.platform.saveFile(
          dialogTitle: 'Choose where to save the auto file',
          fileName: fileName,
          type: FileType.custom,
          allowedExtensions: [autoFileExtension],
          lockParentWindow: false,
        );

        if (result == null) return;
        savingPath = result;
      }

      await File(savingPath).writeAsString(jsonEncode(store.state));

      store.dispatch(SaveFile(
        fileName: savingPath,
      ));
    } catch (e) {}
  };
}

ThunkAction newAutoThunk() {
  return (Store store) async {
    store.dispatch(NewAuto());
  };
}