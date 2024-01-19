import "dart:convert";
import "dart:io";
import "package:flutter/material.dart";
import "package:grpc/grpc.dart";
import "package:path/path.dart";
import "package:file_picker/file_picker.dart";
import "package:pathfinder/main.dart";
import "package:pathfinder/rpc/protos/PathFinder.pb.dart";
import "package:pathfinder/services/pathfinder.dart";
import "package:pathfinder/store/app/app_actions.dart";
import "package:pathfinder/store/app/app_state.dart";
import "package:pathfinder/store/tab/store.dart";
import "package:pathfinder/store/tab/tab_ui/tab_ui.dart";
import "package:redux_thunk/redux_thunk.dart";
import "package:redux/redux.dart";

ThunkAction<AppState> addPointThunk(
  final Offset? position,
  final int segmentIndex,
  final int insertIndex,
) =>
    (final Store<AppState> store) async {
      store.dispatch(AddPointToPath(position, segmentIndex, insertIndex));
      store.dispatch(updateSplineThunk());
    };

ThunkAction<AppState> removePointThunk(final int index) =>
    (final Store<AppState> store) async {
      store.dispatch(DeletePointFromPath(index));
      store.dispatch(updateSplineThunk());
    };

ThunkAction<AppState> editPointThunk({
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
}) =>
    (final Store<AppState> store) async {
      store.dispatch(
        EditPoint(
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
        ),
      );
      store.dispatch(updateSplineThunk());
    };

ThunkAction<AppState> endDragThunk(final int index, final Offset position) =>
    editPointThunk(pointIndex: index, position: position);

ThunkAction<AppState> endInControlDragThunk(
  final int index,
  final Offset position,
) =>
    editPointThunk(pointIndex: index, inControlPoint: position);

ThunkAction<AppState> endOutControlDragThunk(
  final int index,
  final Offset position,
) =>
    editPointThunk(pointIndex: index, outControlPoint: position);

ThunkAction<AppState> endControlDrag(
  final int index,
  final Offset inPosition,
  final Offset outPosition,
) =>
    editPointThunk(
      pointIndex: index,
      outControlPoint: outPosition,
      inControlPoint: inPosition,
    );

ThunkAction<AppState> endHeadingDragThunk(
  final int index,
  final double heading,
) =>
    editPointThunk(pointIndex: index, heading: heading);

ThunkAction<AppState> updateSplineThunk() =>
    (final Store<AppState> store) async {
      store.dispatch(calculateSplineThunk());
      // store.dispatch(calculateTrajectoryThunk());
    };

ThunkAction<AppState> editSegmentThunk({
  required final int index,
  required final double? velocity,
  required final bool? isHidden,
}) =>
    (final Store<AppState> store) {
      store.dispatch(
        EditSegment(index: index, velocity: velocity, isHidden: isHidden),
      );
    };

ThunkAction<AppState> pathUndoThunk() => (final Store<AppState> store) {
      store.dispatch(PathUndo());
      store.dispatch(calculateSplineThunk());
    };

ThunkAction<AppState> pathRedoThunk() => (final Store<AppState> store) {
      store.dispatch(PathRedo());
      store.dispatch(calculateSplineThunk());
    };

void reconnect(
  final dynamic Function(Store<AppState>) thunk,
  final Object error,
) {
  if (error is GrpcError && error.code == StatusCode.unavailable && !isDev) {
    runAlgorithm();
    store.dispatch(thunk);
    return;
  }
}

ThunkAction<AppState> calculateSplineThunk() =>
    (final Store<AppState> store) async {
      try {
        final SplineResponse res = await PathFinderService.calculateSpline(
          store.state.tabState[store.state.currentTabIndex].path.segments,
          store.state.tabState[store.state.currentTabIndex].path.points,
          0.1,
        );

        store.dispatch(SplineCalculated(res.evaluatedPoints));
      } catch (e) {
        reconnect(calculateSplineThunk(), e);
        store.dispatch(ServerError(e.toString()));
      }
    };

ThunkAction<AppState> calculateTrajectoryThunk() =>
    (final Store<AppState> store) async {
      store.dispatch(TrajectoryInProgress());

      try {
        final TrajectoryResponse res =
            await PathFinderService.calculateTrjactory(
          store.state.tabState[store.state.currentTabIndex].path.points,
          store.state.tabState[store.state.currentTabIndex].path.segments,
          store.state.tabState[store.state.currentTabIndex].robot,
          store.state.tabState[store.state.currentTabIndex].ui
              .trajectoryFileName,
        );

        store.dispatch(TrajectoryCalculated(res.swervePoints));
      } catch (e) {
        reconnect(calculateTrajectoryThunk(), e);
        store.dispatch(ServerError(e.toString()));
      }
    };

ThunkAction<AppState> openFileThunk() => (final Store<AppState> store) async {
      try {
        final FilePickerResult? result = await FilePicker.platform.pickFiles(
          dialogTitle: "Select an auto file",
          allowedExtensions: <String>["auto", "*"],
          lockParentWindow: false,
          type: FileType.custom,
        );

        if (result?.paths.first == null) return;
        final File file = File(result!.files.first.path ?? "");

        final String content = await file.readAsString();

        store.dispatch(
          OpenFile(
            fileContent: content,
            fileName: file.path,
          ),
        );
      } catch (e) {}
    };

ThunkAction<AppState> saveFileThunk(bool isSaveAs) =>
    (final Store<AppState> store) async {
      try {
        String savingPath = store.state.autoFileName;

        // In case of an initial save always open the 'save as' dialog
        if (savingPath == defaultAutoFileName) {
          isSaveAs = true;
        }

        if (isSaveAs) {
          String fileName = basename(savingPath);

          // Make sure the suggested file extension is auto
          if (extension(fileName) != ".$autoFileExtension") {
            fileName += ".$autoFileExtension";
          }

          final String? result = await FilePicker.platform.saveFile(
            dialogTitle: "Choose where to save the auto file",
            fileName: fileName,
            type: FileType.custom,
            allowedExtensions: <String>[autoFileExtension],
            lockParentWindow: false,
          );

          if (result == null) return;
          savingPath = result;
        }

        await File(savingPath).writeAsString(jsonEncode(store.state));

        store.dispatch(
          SaveFile(
            fileName: savingPath,
          ),
        );
      } catch (e) {}
    };

ThunkAction<AppState> newAutoThunk() => (final Store<AppState> store) async {
      store.dispatch(NewAuto());
    };
