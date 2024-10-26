import "package:flutter/material.dart";
import "package:orbit_standard_library/orbit_standard_library.dart";
import "package:pathfinder_gui/models/path_point.dart";
import "package:pathfinder_gui/models/robot.dart";
import "package:pathfinder_gui/models/robot_on_field.dart";
import "package:pathfinder_gui/models/segment.dart";
import "package:pathfinder_gui/models/spline_point.dart";
import "package:pathfinder_gui/store/app/app_state.dart";
import "package:pathfinder_gui/store/tab/tab_actions.dart";
import "package:pathfinder_gui/store/tab/tab_thunk.dart";
import "package:redux/redux.dart";

//TODO: change name to editor model
//TODO: again dispatchees shoudn't be part of the model
class PathEditorModel {
  PathEditorModel({
    required this.points,
    required this.segments,
    required this.selectedPointIndex,
    required this.robot,
    required this.addPoint,
    required this.deletePoint,
    required this.finishDrag,
    required this.selectPoint,
    required this.unSelectPoint,
    required this.evaulatedPoints,
    required this.finishControlDrag,
    required this.finishInControlDrag,
    required this.finishOutControlDrag,
    required this.finishHeadingDrag,
    required this.setFieldSizePixels,
    required this.headingToggle,
    required this.toggleHeading,
    required this.controlToggle,
    required this.toggleControl,
    required this.fieldSizePixels,
    required this.saveFile,
    required this.saveFileAs,
    required this.pathUndo,
    required this.pathRedo,
    required this.imageZoom,
    required this.imageOffset,
    required this.setImageZoom,
    required this.setImageOffset,
    required this.setZoomAndOffset,
    required this.robotOnField,
    required this.selectRobotOnField,
    required this.animateRobot,
    required this.copyPoint,
    required this.pastePoint,
  });
  final List<PathPoint> points;
  final List<Segment> segments;
  final int? selectedPointIndex;
  final Robot robot;
  final Function(Offset) addPoint;
  final Function(int) deletePoint;
  final Function(int, Offset) finishDrag;
  final Function(int) selectPoint;
  final Function() unSelectPoint;
  final Function(int, Offset, Offset) finishControlDrag;
  final Function(int, Offset) finishInControlDrag;
  final Function(int, Offset) finishOutControlDrag;
  final Function(int, double) finishHeadingDrag;
  final Function(Offset) setFieldSizePixels;
  final List<SplinePoint> evaulatedPoints;
  final bool headingToggle;
  final Function() toggleHeading;
  final bool controlToggle;
  final Function() toggleControl;
  final Offset fieldSizePixels;
  final Function() saveFile;
  final Function() saveFileAs;
  final Function() pathUndo;
  final Function() pathRedo;
  final double imageZoom;
  final Offset imageOffset;
  final Function(double) setImageZoom;
  final Function(Offset) setImageOffset;
  final Function(double, Offset) setZoomAndOffset;
  final Optional<RobotOnField> robotOnField;
  final void Function(Offset) selectRobotOnField;
  final void Function() animateRobot;
  final void Function(int) copyPoint;
  final void Function(int) pastePoint;

  static PathEditorModel fromStore(final Store<AppState> store) =>
      PathEditorModel(
        points: store.state.tabState[store.state.currentTabIndex].path.points
            .map((final PathPoint p) => p.toUiCoord(store))
            .toList(),
        segments:
            store.state.tabState[store.state.currentTabIndex].path.segments,
        evaulatedPoints: store
            .state.tabState[store.state.currentTabIndex].path.splinePoints
            .map((final SplinePoint p) => p.toUiCoord(store))
            .toList(),
        selectedPointIndex: (store.state.tabState[store.state.currentTabIndex]
                    .ui.selectedType ==
                PathPoint
            ? store.state.tabState[store.state.currentTabIndex].ui.selectedIndex
            : null),
        robot: store.state.tabState[store.state.currentTabIndex].robot
            .toUiCoord(store),
        addPoint: (final Offset position) {
          store.dispatch(
            addPointThunk(
              store.state.currentTabState.ui.pixToMeters(position),
              -1,
              -1,
            ),
          );
        },
        deletePoint: (final int index) {
          store.dispatch(removePointThunk(index));
        },
        finishDrag: (final int index, final Offset position) {
          store.dispatch(ObjectSelected(index, PathPoint));
          store.dispatch(
            endDragThunk(
              index,
              store.state.currentTabState.ui.pixToMeters(position),
            ),
          );
        },
        selectPoint: (final int index) {
          store.dispatch(ObjectSelected(index, PathPoint));
        },
        unSelectPoint: () {
          store.dispatch(ObjectUnselected());
        },
        finishControlDrag: (
          final int index,
          final Offset inPosition,
          final Offset outPosition,
        ) {
          store.dispatch(
            endControlDrag(
              index,
              store.state.currentTabState.ui.pixToMeters(inPosition),
              store.state.currentTabState.ui.pixToMeters(outPosition),
            ),
          );
        },
        finishInControlDrag: (final int index, final Offset position) {
          store.dispatch(
            endInControlDragThunk(
                index, store.state.currentTabState.ui.pixToMeters(position)),
          );
        },
        finishOutControlDrag: (final int index, final Offset position) {
          store.dispatch(
            endOutControlDragThunk(
                index, store.state.currentTabState.ui.pixToMeters(position)),
          );
        },
        finishHeadingDrag: (final int index, final double heading) {
          store.dispatch(endHeadingDragThunk(index, heading));
        },
        setFieldSizePixels: (final Offset size) {
          if (store.state.tabState[store.state.currentTabIndex].ui
                  .fieldSizePixels !=
              size) {
            store.dispatch(SetFieldSizePixels(size));
          }
        },
        headingToggle:
            store.state.tabState[store.state.currentTabIndex].ui.headingToggle,
        toggleHeading: () {
          store.dispatch(ToggleHeading());
        },
        controlToggle:
            store.state.tabState[store.state.currentTabIndex].ui.controlToggle,
        toggleControl: () {
          store.dispatch(ToggleControl());
        },
        fieldSizePixels: store
            .state.tabState[store.state.currentTabIndex].ui.fieldSizePixels,
        saveFile: () => store.dispatch(saveFileThunk(false)),
        saveFileAs: () => store.dispatch(saveFileThunk(true)),
        pathUndo: () => store.dispatch(pathUndoThunk()),
        pathRedo: () => store.dispatch(pathRedoThunk()),
        imageZoom:
            store.state.tabState[store.state.currentTabIndex].ui.zoomLevel,
        imageOffset: store.state.tabState[store.state.currentTabIndex].ui.pan,
        setImageZoom: (final double zoom) =>
            store.dispatch((SetZoomLevel(zoom))),
        setImageOffset: (final Offset pan) => store.dispatch((SetPan(pan))),
        setZoomAndOffset: (final double zoom, final Offset pan) =>
            store.dispatch((SetZoomLevel(zoom, pan: pan))),
        robotOnField:
            store.state.tabState[store.state.currentTabIndex].path.robotOnField,
        selectRobotOnField: (final Offset position) {
          store.dispatch(setRobotOnFieldThunk(SetRobotOnField(position)));
        },
        animateRobot: () => store.dispatch(animateRobotOnFieldThunk()),
        copyPoint: (final int copyIndex) =>
            store.dispatch(CopyPoint(copyIndex)),
        pastePoint: (final int pasteIndex) =>
            store.dispatch(pastePointThunk(pasteIndex)),
      );
}
