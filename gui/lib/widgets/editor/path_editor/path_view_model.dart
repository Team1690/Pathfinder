import "package:flutter/gestures.dart";
import "package:pathfinder/models/point.dart";
import "package:pathfinder/models/robot.dart";
import "package:pathfinder/models/segment.dart";
import "package:pathfinder/models/spline_point.dart";
import "package:pathfinder/store/app/app_state.dart";
import "package:pathfinder/store/tab/tab_actions.dart";
import "package:pathfinder/store/tab/tab_thunk.dart";
import "package:pathfinder/utils/coordinates_convertion.dart";
import "package:redux/redux.dart";

class PathViewModel {
  PathViewModel({
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
  });
  final List<Point> points;
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

  static PathViewModel fromStore(final Store<AppState> store) => PathViewModel(
        points: store.state.tabState.path.points
            .map((final Point p) => p.toUiCoord(store))
            .toList(),
        segments: store.state.tabState.path.segments,
        evaulatedPoints: store.state.tabState.path.evaluatedPoints
            .map((final SplinePoint p) => p.toUiCoord(store))
            .toList(),
        selectedPointIndex: (store.state.tabState.ui.selectedType == Point
            ? store.state.tabState.ui.selectedIndex
            : null),
        robot: store.state.tabState.robot.toUiCoord(store),
        addPoint: (final Offset position) {
          store.dispatch(
            addPointThunk(
              uiToFieldOrigin(store, uiToMetersCoord(store, position)),
              -1,
              -1,
            ),
          );
        },
        deletePoint: (final int index) {
          store.dispatch(removePointThunk(index));
        },
        finishDrag: (final int index, final Offset position) {
          store.dispatch(ObjectSelected(index, Point));
          store.dispatch(
            endDragThunk(
              index,
              uiToFieldOrigin(store, uiToMetersCoord(store, position)),
            ),
          );
        },
        selectPoint: (final int index) {
          store.dispatch(ObjectSelected(index, Point));
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
              uiToMetersCoord(store, inPosition),
              uiToMetersCoord(store, outPosition),
            ),
          );
        },
        finishInControlDrag: (final int index, final Offset position) {
          store.dispatch(
            endInControlDragThunk(index, uiToMetersCoord(store, position)),
          );
        },
        finishOutControlDrag: (final int index, final Offset position) {
          store.dispatch(
            endOutControlDragThunk(index, uiToMetersCoord(store, position)),
          );
        },
        finishHeadingDrag: (final int index, final double heading) {
          store.dispatch(endHeadingDragThunk(index, heading));
        },
        setFieldSizePixels: (final Offset size) {
          if (store.state.tabState.ui.fieldSizePixels != size) {
            store.dispatch(SetFieldSizePixels(size));
          }
        },
        headingToggle: store.state.tabState.ui.headingToggle,
        toggleHeading: () {
          store.dispatch(ToggleHeading());
        },
        controlToggle: store.state.tabState.ui.controlToggle,
        toggleControl: () {
          store.dispatch(ToggleControl());
        },
        fieldSizePixels: store.state.tabState.ui.fieldSizePixels,
        saveFile: () => store.dispatch(saveFileThunk(false)),
        saveFileAs: () => store.dispatch(saveFileThunk(true)),
        pathUndo: () => store.dispatch(pathUndoThunk()),
        pathRedo: () => store.dispatch(pathRedoThunk()),
        imageZoom: store.state.tabState.ui.zoomLevel,
        imageOffset: store.state.tabState.ui.pan,
        setImageZoom: (final double zoom) =>
            store.dispatch((SetZoomLevel(zoom))),
        setImageOffset: (final Offset pan) => store.dispatch((SetPan(pan))),
        setZoomAndOffset: (final double zoom, final Offset pan) =>
            store.dispatch((SetZoomLevel(zoom, pan: pan))),
      );
}
