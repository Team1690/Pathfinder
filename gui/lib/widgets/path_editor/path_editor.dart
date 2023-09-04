import "dart:async";
import "dart:math";

import "package:collection/collection.dart";
import "package:flutter/gestures.dart";
import "package:pathfinder/models/path.dart";
import "package:pathfinder/models/robot.dart";
import "package:pathfinder/store/tab/tab_actions.dart";
import "package:pathfinder/store/tab/tab_thunk.dart";
import "package:pathfinder/widgets/path_editor/field_editor.dart";
import "package:pathfinder/utils/coordinates_convertion.dart";
import "package:redux/redux.dart";
import "package:flutter/material.dart";
import "package:flutter/services.dart";
import "package:flutter_redux/flutter_redux.dart";
import "package:pathfinder/models/point.dart";
import "package:pathfinder/models/segment.dart";
import "package:pathfinder/store/app/app_state.dart";

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

StoreConnector<AppState, PathViewModel> pathEditor() =>
    new StoreConnector<AppState, PathViewModel>(
      converter: PathViewModel.fromStore,
      builder: (final _, final PathViewModel props) =>
          _PathEditor(pathProps: props),
    );

class DraggingPoint {
  DraggingPoint(this.type, this.position);
  final PointType type;
  final Offset position;
}

class FullDraggingPoint {
  FullDraggingPoint(this.index, this.draggingPoint);
  int index;
  final DraggingPoint draggingPoint;
}

const int DraggingTollerance = 2;

class _PathEditor extends StatefulWidget {
  _PathEditor({
    required this.pathProps,
  });
  final PathViewModel pathProps;

  @override
  _PathEditorState createState() => _PathEditorState();
}

class _PathEditorState extends State<_PathEditor> {
  _PathEditorState();
  Set<LogicalKeyboardKey> pressedKeys = <LogicalKeyboardKey>{};
  FullDraggingPoint? dragPoint;
  List<FullDraggingPoint> dragPoints = <FullDraggingPoint>[];

  bool isScrolling = false;

  Timer? scrollTimer;

  Offset localImageOffsetAddition = Offset.zero;
  double localImageZoomAddition = 0;

  final double imageZoomDiff = 0.1;
  final double imageOffsetDiff = 10;

  int? getTappedPoint(
    final Offset tapPosition,
    final List<Point> points,
    final List<Segment> segments,
  ) {
    for (final MapEntry<int, Point> entery
        in widget.pathProps.points.asMap().entries) {
      final Point point = entery.value;
      final int index = entery.key;
      if (checkSelectedPointTap(
            tapPosition,
            point,
            index,
            PointType.path,
            segments,
          ) !=
          null) {
        return index;
      }
    }
    return null;
  }

  DraggingPoint? checkSelectedPointTap(
    final Offset tapPosition,
    final Point point,
    final int index,
    final PointType pointType,
    final List<Segment> segments,
  ) {
    final Offset realTapPosition =
        (tapPosition - widget.pathProps.imageOffset) /
            widget.pathProps.imageZoom;
    final (int, Segment)? segment = segments
        .mapIndexed(
          (final int index, final Segment element) => (index, element),
        )
        .where(
          (final (int, Segment) segment) =>
              segment.$2.pointIndexes.contains(index),
        )
        .singleOrNull;
    // if(point selection click be ignored) return null;
    if (segment != null && // Click isn't for a new point
            segment.$2.isHidden // Segment is hidden
        ) {
      // If a segment is hidden it's first point is still shown so it should be clickable so
      final bool isFirstPointInSegment = segment.$2.pointIndexes.first == index;
      final bool isFirstSegment = segments.firstOrNull == segment.$2;
      if (!isFirstPointInSegment ||
          isFirstSegment ||
          isFirstPointInSegment && segments[segment.$1 - 1].isHidden) {
        return null;
      }
    }

    if (pointType == PointType.path) {
      final double radius =
          (pointSettings[PointType.path]!.radius * widget.pathProps.imageZoom) +
              DraggingTollerance;
      if ((realTapPosition - point.position).distance <=
          radius + DraggingTollerance) {
        return DraggingPoint(PointType.path, point.position);
      }
    }

    if (pointType == PointType.heading && point.useHeading) {
      final Offset headingCenter =
          Offset.fromDirection(point.heading, headingLength);
      final Offset headingPosition = point.position + headingCenter;
      final double radius = (pointSettings[PointType.heading]!.radius *
              widget.pathProps.imageZoom) +
          DraggingTollerance;
      if ((headingPosition - realTapPosition).distance < radius) {
        return DraggingPoint(PointType.heading, headingCenter);
      }
    }

    if (pointType == PointType.inControl) {
      final Offset inControlPosition = point.position + point.inControlPoint;
      final double radius = (pointSettings[PointType.inControl]!.radius *
              widget.pathProps.imageZoom) +
          DraggingTollerance;
      if ((inControlPosition - realTapPosition).distance < radius) {
        return DraggingPoint(PointType.inControl, point.inControlPoint);
      }
    }

    if (pointType == PointType.outControl) {
      final Offset outControlPosition = point.position + point.outControlPoint;
      final double radius = (pointSettings[PointType.outControl]!.radius *
              widget.pathProps.imageZoom) +
          DraggingTollerance;
      if ((outControlPosition - realTapPosition).distance < radius) {
        return DraggingPoint(PointType.outControl, point.outControlPoint);
      }
    }
    return null;
  }

  @override
  void dispose() {
    if (scrollTimer != null) {
      scrollTimer!.cancel();
    }

    super.dispose();
  }

  @override
  Widget build(final BuildContext context) => RawKeyboardListener(
        autofocus: true,
        focusNode: FocusNode(),
        onKey: (final RawKeyEvent event) {
          setState(() {
            if (event is RawKeyDownEvent) {
              if (!pressedKeys.contains(event.logicalKey)) {
                if (event.logicalKey == LogicalKeyboardKey.keyH) {
                  widget.pathProps.toggleHeading();
                } else if (event.logicalKey == LogicalKeyboardKey.keyG) {
                  widget.pathProps.toggleControl();
                } else if (event.logicalKey == LogicalKeyboardKey.escape) {
                  widget.pathProps.unSelectPoint();
                }

                pressedKeys.add(event.logicalKey);
              }
            } else if (event is RawKeyUpEvent) {
              if (event.logicalKey == LogicalKeyboardKey.backspace &&
                  (pressedKeys.contains(LogicalKeyboardKey.shiftLeft) ||
                      pressedKeys.contains(LogicalKeyboardKey.shiftRight)) &&
                  widget.pathProps.selectedPointIndex != null) {
                widget.pathProps
                    .deletePoint(widget.pathProps.selectedPointIndex!);
              }

              if (event.logicalKey == LogicalKeyboardKey.keyZ) {
                if (pressedKeys.contains(LogicalKeyboardKey.controlLeft) ||
                    pressedKeys.contains(LogicalKeyboardKey.controlRight)) {
                  widget.pathProps.pathUndo();
                }
              }

              if (event.logicalKey == LogicalKeyboardKey.keyY) {
                if (pressedKeys.contains(LogicalKeyboardKey.controlLeft) ||
                    pressedKeys.contains(LogicalKeyboardKey.controlRight)) {
                  widget.pathProps.pathRedo();
                }
              }

              if (event.logicalKey == LogicalKeyboardKey.keyS) {
                // Handle ctrl press
                if (pressedKeys.contains(LogicalKeyboardKey.controlLeft) ||
                    pressedKeys.contains(LogicalKeyboardKey.controlRight)) {
                  // Handle ctrl+shift
                  if (pressedKeys.contains(LogicalKeyboardKey.shiftLeft) ||
                      pressedKeys.contains(LogicalKeyboardKey.shiftRight)) {
                    widget.pathProps.saveFileAs();
                  } else {
                    widget.pathProps.saveFile();
                  }
                }
              }

              if (event.logicalKey == LogicalKeyboardKey.equal) {
                if (pressedKeys.contains(LogicalKeyboardKey.controlLeft) ||
                    pressedKeys.contains(LogicalKeyboardKey.controlRight)) {
                  widget.pathProps
                      .setImageZoom(widget.pathProps.imageZoom + imageZoomDiff);
                }
              }

              if (event.logicalKey == LogicalKeyboardKey.minus) {
                if (pressedKeys.contains(LogicalKeyboardKey.controlLeft) ||
                    pressedKeys.contains(LogicalKeyboardKey.controlRight)) {
                  widget.pathProps
                      .setImageZoom(widget.pathProps.imageZoom - imageZoomDiff);
                }
              }

              if (event.logicalKey == LogicalKeyboardKey.arrowRight) {
                if (pressedKeys.contains(LogicalKeyboardKey.controlLeft) ||
                    pressedKeys.contains(LogicalKeyboardKey.controlRight)) {
                  widget.pathProps.setImageOffset(
                    widget.pathProps.imageOffset + Offset(imageOffsetDiff, 0),
                  );
                }
              }

              if (event.logicalKey == LogicalKeyboardKey.arrowLeft) {
                if (pressedKeys.contains(LogicalKeyboardKey.controlLeft) ||
                    pressedKeys.contains(LogicalKeyboardKey.controlRight)) {
                  widget.pathProps.setImageOffset(
                    widget.pathProps.imageOffset - Offset(imageOffsetDiff, 0),
                  );
                }
              }

              if (event.logicalKey == LogicalKeyboardKey.arrowUp) {
                if (pressedKeys.contains(LogicalKeyboardKey.controlLeft) ||
                    pressedKeys.contains(LogicalKeyboardKey.controlRight)) {
                  widget.pathProps.setImageOffset(
                    widget.pathProps.imageOffset + Offset(0, imageOffsetDiff),
                  );
                }
              }

              if (event.logicalKey == LogicalKeyboardKey.arrowDown) {
                if (pressedKeys.contains(LogicalKeyboardKey.controlLeft) ||
                    pressedKeys.contains(LogicalKeyboardKey.controlRight)) {
                  widget.pathProps.setImageOffset(
                    widget.pathProps.imageOffset - Offset(0, imageOffsetDiff),
                  );
                }
              }

              if (event.logicalKey == LogicalKeyboardKey.digit0) {
                if (pressedKeys.contains(LogicalKeyboardKey.controlLeft) ||
                    pressedKeys.contains(LogicalKeyboardKey.controlRight)) {
                  widget.pathProps.setImageZoom(1);
                  widget.pathProps.setImageOffset(Offset.zero);
                }
              }

              pressedKeys.remove(event.logicalKey);
            }
          });
        },
        child: Center(
          child: Stack(
            children: <Widget>[
              Listener(
                onPointerSignal: (final PointerSignalEvent pointerSignal) {
                  if (pointerSignal is PointerScrollEvent) {
                    if (scrollTimer != null) {
                      scrollTimer!.cancel();
                    }

                    // Set a timer that will sync the local state with the global state
                    scrollTimer =
                        new Timer(const Duration(milliseconds: 100), () {
                      if (isScrolling) {
                        if (localImageOffsetAddition != Offset.zero ||
                            localImageZoomAddition != 0) {
                          widget.pathProps.setZoomAndOffset(
                            widget.pathProps.imageZoom + localImageZoomAddition,
                            widget.pathProps.imageOffset +
                                localImageOffsetAddition,
                          );

                          setState(() {
                            localImageOffsetAddition = Offset.zero;
                            localImageZoomAddition = 0;
                            isScrolling = false;
                          });
                        }
                      }
                    });

                    final double currentZoom =
                        widget.pathProps.imageZoom + localImageZoomAddition;
                    final Offset currentOffset =
                        widget.pathProps.imageOffset + localImageOffsetAddition;

                    final double delta = pointerSignal.scrollDelta.dy * 0.01;

                    final double newZoom = currentZoom + delta;
                    final Offset mousePosition =
                        flipYAxis(pointerSignal.localPosition) +
                            Offset(0, widget.pathProps.fieldSizePixels.dy);

                    final Offset finalOffset = currentOffset +
                        (mousePosition - currentOffset) *
                            (1 - newZoom / currentZoom);

                    if (newZoom < 0.4) return;
                    if (newZoom > 8) return;

                    setState(() {
                      isScrolling = true;
                      localImageOffsetAddition =
                          finalOffset - widget.pathProps.imageOffset;
                      localImageZoomAddition =
                          newZoom - widget.pathProps.imageZoom;
                    });
                  }
                },
                child: GestureDetector(
                  child: ClipRect(
                    clipBehavior: Clip.hardEdge,
                    child: FieldLoader(
                      widget.pathProps.points,
                      widget.pathProps.segments,
                      widget.pathProps.selectedPointIndex,
                      dragPoints,
                      widget.pathProps.headingToggle,
                      widget.pathProps.controlToggle,
                      widget.pathProps.evaulatedPoints,
                      widget.pathProps.setFieldSizePixels,
                      widget.pathProps.robot,
                      widget.pathProps.imageZoom + localImageZoomAddition,
                      widget.pathProps.imageOffset + localImageOffsetAddition,
                    ),
                  ),
                  onTapUp: (final TapUpDetails details) {
                    final Offset tapPos = flipYAxisByField(
                      details.localPosition,
                      widget.pathProps.fieldSizePixels,
                    );

                    final int? selectedPoint = getTappedPoint(
                      tapPos,
                      widget.pathProps.points,
                      widget.pathProps.segments,
                    );

                    if (widget.pathProps.selectedPointIndex != null &&
                        widget.pathProps.selectedPointIndex! >= 0 &&
                        selectedPoint == widget.pathProps.selectedPointIndex) {
                      widget.pathProps.unSelectPoint();
                      return;
                    }

                    if (selectedPoint != null) {
                      widget.pathProps.selectPoint(selectedPoint);
                      return;
                    }

                    if (pressedKeys.contains(LogicalKeyboardKey.controlRight) ||
                        pressedKeys.contains(LogicalKeyboardKey.controlLeft)) {
                      final Offset realTapPosition =
                          (tapPos - widget.pathProps.imageOffset) /
                              widget.pathProps.imageZoom;
                      widget.pathProps.addPoint(realTapPosition);
                      return;
                    }

                    widget.pathProps.unSelectPoint();
                  },
                  onPanStart: (final DragStartDetails details) {
                    setState(() {
                      localImageOffsetAddition = Offset.zero;
                      localImageZoomAddition = 0;
                    });

                    final Offset tapPos = flipYAxisByField(
                      details.localPosition,
                      widget.pathProps.fieldSizePixels,
                    );

                    for (final MapEntry<int, Point> entery
                        in widget.pathProps.points.asMap().entries) {
                      final Point point = entery.value;
                      final int index = entery.key;

                      DraggingPoint? draggingPoint;

                      bool controlToggle = widget.pathProps.controlToggle;
                      bool headingToggle = widget.pathProps.headingToggle;

                      if (widget.pathProps.selectedPointIndex != null &&
                          widget.pathProps.selectedPointIndex! >= 0) {
                        controlToggle =
                            widget.pathProps.selectedPointIndex == index;
                        headingToggle =
                            widget.pathProps.selectedPointIndex == index;
                      }
                      final List<Segment> segments = widget.pathProps.segments;
                      if (headingToggle) {
                        draggingPoint = checkSelectedPointTap(
                          tapPos,
                          point,
                          index,
                          PointType.heading,
                          segments,
                        );
                      }

                      if (controlToggle && draggingPoint == null) {
                        draggingPoint = checkSelectedPointTap(
                          tapPos,
                          point,
                          index,
                          PointType.inControl,
                          segments,
                        );
                      }

                      if (controlToggle && draggingPoint == null) {
                        draggingPoint = checkSelectedPointTap(
                          tapPos,
                          point,
                          index,
                          PointType.outControl,
                          segments,
                        );
                      }

                      draggingPoint ??= checkSelectedPointTap(
                        tapPos,
                        point,
                        index,
                        PointType.path,
                        segments,
                      );

                      if (draggingPoint != null) {
                        final FullDraggingPoint fullDraggingPoint =
                            FullDraggingPoint(index, draggingPoint);

                        setState(() {
                          dragPoint = fullDraggingPoint;
                        });

                        break;
                      }
                    }
                  },
                  onPanUpdate: (final DragUpdateDetails details) {
                    if (dragPoint != null) {
                      FullDraggingPoint currentDragPoint = dragPoint!;
                      setState(() {
                        currentDragPoint = FullDraggingPoint(
                          currentDragPoint.index,
                          DraggingPoint(
                            currentDragPoint.draggingPoint.type,
                            currentDragPoint.draggingPoint.position +
                                (flipYAxis(details.delta) /
                                    widget.pathProps.imageZoom),
                          ),
                        );
                        dragPoint = currentDragPoint;
                        dragPoints = <FullDraggingPoint>[currentDragPoint];

                        if (!widget.pathProps.points[currentDragPoint.index]
                                .isStop ||
                            pressedKeys.contains(LogicalKeyboardKey.keyF)) {
                          if (currentDragPoint.draggingPoint.type ==
                              PointType.inControl) {
                            dragPoints.add(
                              FullDraggingPoint(
                                currentDragPoint.index,
                                DraggingPoint(
                                  PointType.outControl,
                                  Offset.fromDirection(
                                    currentDragPoint
                                            .draggingPoint.position.direction +
                                        pi,
                                    widget
                                        .pathProps
                                        .points[currentDragPoint.index]
                                        .outControlPoint
                                        .distance,
                                  ),
                                ),
                              ),
                            );
                          } else if (currentDragPoint.draggingPoint.type ==
                              PointType.outControl) {
                            dragPoints.add(
                              FullDraggingPoint(
                                currentDragPoint.index,
                                DraggingPoint(
                                  PointType.inControl,
                                  Offset.fromDirection(
                                    currentDragPoint
                                            .draggingPoint.position.direction +
                                        pi,
                                    widget
                                        .pathProps
                                        .points[currentDragPoint.index]
                                        .inControlPoint
                                        .distance,
                                  ),
                                ),
                              ),
                            );
                          }
                        }
                      });
                    } else {
                      if (pressedKeys
                              .contains(LogicalKeyboardKey.controlRight) ||
                          pressedKeys
                              .contains(LogicalKeyboardKey.controlLeft)) {
                        setState(() {
                          localImageOffsetAddition = localImageOffsetAddition +
                              flipYAxis(details.delta);
                        });
                      }
                    }
                  },
                  onPanEnd: (final DragEndDetails details) {
                    if (localImageOffsetAddition != Offset.zero ||
                        localImageZoomAddition != 0) {
                      widget.pathProps.setZoomAndOffset(
                        widget.pathProps.imageZoom + localImageZoomAddition,
                        widget.pathProps.imageOffset + localImageOffsetAddition,
                      );
                      setState(() {
                        localImageOffsetAddition = Offset.zero;
                        localImageZoomAddition = 0;
                      });
                    }
                    FullDraggingPoint? previusDraggingPoint;

                    for (final FullDraggingPoint draggingPoint in dragPoints) {
                      switch (draggingPoint.draggingPoint.type) {
                        case PointType.path:
                          widget.pathProps.finishDrag(
                            draggingPoint.index,
                            draggingPoint.draggingPoint.position,
                          );
                          break;
                        case PointType.inControl:
                          if (widget
                              .pathProps.points[draggingPoint.index].isStop) {
                            widget.pathProps.finishInControlDrag(
                              draggingPoint.index,
                              draggingPoint.draggingPoint.position,
                            );
                            break;
                          }

                          if (previusDraggingPoint == null) {
                            previusDraggingPoint = draggingPoint;
                            break;
                          }

                          widget.pathProps.finishControlDrag(
                            draggingPoint.index,
                            draggingPoint.draggingPoint.position,
                            previusDraggingPoint.draggingPoint.position,
                          );
                          break;
                        case PointType.outControl:
                          if (widget
                              .pathProps.points[draggingPoint.index].isStop) {
                            widget.pathProps.finishOutControlDrag(
                              draggingPoint.index,
                              draggingPoint.draggingPoint.position,
                            );
                            break;
                          }

                          if (previusDraggingPoint == null) {
                            previusDraggingPoint = draggingPoint;
                            break;
                          }

                          widget.pathProps.finishControlDrag(
                            draggingPoint.index,
                            previusDraggingPoint.draggingPoint.position,
                            draggingPoint.draggingPoint.position,
                          );
                          break;
                        case PointType.heading:
                          final Offset dragPosition =
                              draggingPoint.draggingPoint.position;
                          final double dragHeading = dragPosition.direction;
                          widget.pathProps.finishHeadingDrag(
                            draggingPoint.index,
                            dragHeading,
                          );
                          break;
                        default:
                          break;
                      }
                    }

                    setState(() {
                      dragPoints = <FullDraggingPoint>[];
                      dragPoint = null;
                    });
                  },
                ),
              ),
            ],
          ),
        ),
      );
}
