import "dart:async";
import "dart:math";
import "package:collection/collection.dart";
import "package:flutter/gestures.dart";
import "package:pathfinder/models/shortcut.dart";
import "package:pathfinder/widgets/editor/field_editor/field_loader.dart";
import "package:pathfinder/utils/coordinates_convertion.dart";
import "package:flutter/material.dart";
import "package:flutter/services.dart";
import "package:flutter_redux/flutter_redux.dart";
import "package:pathfinder/models/point.dart";
import "package:pathfinder/models/segment.dart";
import "package:pathfinder/store/app/app_state.dart";
import "package:pathfinder/widgets/editor/field_editor/point_type.dart";
import "package:pathfinder/widgets/editor/path_editor/dragging_point.dart";
import "package:pathfinder/widgets/editor/path_editor/full_dragging_point.dart";
import "package:pathfinder/widgets/editor/path_editor/path_view_model.dart";

StoreConnector<AppState, PathViewModel> pathEditor() =>
    new StoreConnector<AppState, PathViewModel>(
      converter: PathViewModel.fromStore,
      builder: (final _, final PathViewModel props) =>
          PathEditor(pathProps: props),
    );

const int DraggingTollerance = 2;

const double minZoom = 0.4;
const double maxZoom = 8.0;

class PathEditor extends StatefulWidget {
  PathEditor({
    required this.pathProps,
  });
  final PathViewModel pathProps;

  @override
  _PathEditorState createState() => _PathEditorState();
}

class _PathEditorState extends State<PathEditor> {
  _PathEditorState();
  FullDraggingPoint? dragPoint;
  List<FullDraggingPoint> dragPoints = <FullDraggingPoint>[];

  bool isScrolling = false;

  Timer? scrollTimer;

  Offset localImageOffsetAddition = Offset.zero;
  double localImageZoomAddition = 0;

  final double imageZoomDiff = 0.1;
  final double imageOffsetDiff = 10;

  Offset scale(final double scaler, final Offset offset) =>
      offset.scale(scaler, scaler);

  Offset getZoomOffset(
    final Offset size,
    final double zoom,
    final Offset imageOffset,
  ) =>
      Offset(
        (1 - zoom) * (size.dx / 2 - imageOffset.dx),
        (1 - zoom) * (size.dy / 2 - imageOffset.dy),
      );

  void moveZoomByDiff(
    final double diff,
  ) {
    // This is just an equation for receiving zoom offset accorind to actualOffset
    // imageOffetWithoutZoomOffset - getZoomOffset(fieldSizePixels,imageZoomBeforeDiff, imageOffetWithoutZoomOffset) = imageOffset
    // imageOffetWithoutZoomOffset - (1 - zoom) * (size / 2 - imageOffetWithoutZoomOffset)                           = imageOffset
    // The variable is imageOffetWithoutZoomOffset and you know:
    // imageZoomBeforeDiff (widget.pathProps.imageZoom), imageOffset (widget.pathProps.imageOffset) and fieldSizePixels (widget.pathProps.fieldSizePixels)
    final Offset offsetWithoutZoomOffset = widget.pathProps.imageOffset -
        scale(
          1 / widget.pathProps.imageZoom,
          widget.pathProps.imageOffset -
              scale(
                1 - widget.pathProps.imageZoom,
                scale(
                  0.5,
                  widget.pathProps.fieldSizePixels,
                ),
              ),
        );

    final Offset oldZoomOffset = getZoomOffset(
      widget.pathProps.fieldSizePixels,
      widget.pathProps.imageZoom,
      widget.pathProps.imageOffset - offsetWithoutZoomOffset,
    );

    final Offset newImageZoomOffset = getZoomOffset(
      widget.pathProps.fieldSizePixels,
      widget.pathProps.imageZoom + diff,
      widget.pathProps.imageOffset - oldZoomOffset,
    );

    final Offset newImageOffset =
        widget.pathProps.imageOffset - oldZoomOffset + newImageZoomOffset;

    widget.pathProps.setImageOffset(
      newImageOffset,
    );
  }

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
  Widget build(final BuildContext context) => CallbackShortcuts(
        bindings: <ShortcutActivator, VoidCallback>{
          noZoomShortcut.activator!: () {
            widget.pathProps.setImageZoom(1);
            widget.pathProps.setImageOffset(Offset.zero);
          },
          toggleHeading.activator!: () {
            widget.pathProps.toggleHeading();
          },
          toggleControl.activator!: () {
            widget.pathProps.toggleControl();
          },
          unSelectPoint.activator!: () {
            widget.pathProps.unSelectPoint();
          },
          deletePoint.activator!: () {
            if (widget.pathProps.selectedPointIndex != null) {
              widget.pathProps
                  .deletePoint(widget.pathProps.selectedPointIndex!);
            }
          },
          undo.activator!: () {
            widget.pathProps.pathUndo();
          },
          redo.activator!: () {
            widget.pathProps.pathRedo();
          },
          save.activator!: () {
            widget.pathProps.saveFile();
          },
          saveAs.activator!: () {
            widget.pathProps.saveFileAs();
          },
          zoomIn.activator!: () {
            if (widget.pathProps.imageZoom + imageZoomDiff > maxZoom) return;
            widget.pathProps
                .setImageZoom(widget.pathProps.imageZoom + imageZoomDiff);
            moveZoomByDiff(imageZoomDiff);
          },
          zoomOut.activator!: () {
            if (widget.pathProps.imageZoom - imageZoomDiff < minZoom) return;
            widget.pathProps
                .setImageZoom(widget.pathProps.imageZoom - imageZoomDiff);
            moveZoomByDiff(-imageZoomDiff);
          },
          panUp.activator!: () {
            widget.pathProps.setImageOffset(
              widget.pathProps.imageOffset - Offset(0, imageOffsetDiff),
            );
          },
          panDown.activator!: () {
            widget.pathProps.setImageOffset(
              widget.pathProps.imageOffset + Offset(0, imageOffsetDiff),
            );
          },
          panLeft.activator!: () {
            widget.pathProps.setImageOffset(
              widget.pathProps.imageOffset + Offset(imageOffsetDiff, 0),
            );
          },
          panRight.activator!: () {
            widget.pathProps.setImageOffset(
              widget.pathProps.imageOffset - Offset(imageOffsetDiff, 0),
            );
          },
          animateRobot.activator!: () {
            widget.pathProps.animateRobot();
          },
          copyPoint.activator!: () {
            if (widget.pathProps.selectedPointIndex != null) {
              widget.pathProps.copyPoint(widget.pathProps.selectedPointIndex!);
            }
          },
          pastePoint.activator!: () {
            if (widget.pathProps.selectedPointIndex != null) {
              widget.pathProps
                  .pastePoint(widget.pathProps.selectedPointIndex! + 1);
            } else {
              widget.pathProps.pastePoint(widget.pathProps.points.length);
            }
          },
        },
        child: Focus(
          autofocus: true,
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
                              widget.pathProps.imageZoom +
                                  localImageZoomAddition,
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
                          widget.pathProps.imageOffset +
                              localImageOffsetAddition;

                      final double delta = pointerSignal.scrollDelta.dy * -0.01;

                      final double newZoom = currentZoom + delta;
                      final Offset mousePosition =
                          flipYAxis(pointerSignal.localPosition) +
                              Offset(0, widget.pathProps.fieldSizePixels.dy);

                      final Offset finalOffset = currentOffset +
                          (mousePosition - currentOffset) *
                              (1 - newZoom / currentZoom);

                      if (newZoom < minZoom) return;
                      if (newZoom > maxZoom) return;

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
                        widget.pathProps.robotOnField,
                      ),
                    ),
                    onSecondaryTapDown: (final TapDownDetails details) {
                      final Offset tapPos = flipYAxisByField(
                        details.localPosition,
                        widget.pathProps.fieldSizePixels,
                      );

                      widget.pathProps.selectRobotOnField(tapPos);
                    },
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
                          selectedPoint ==
                              widget.pathProps.selectedPointIndex) {
                        widget.pathProps.unSelectPoint();
                        return;
                      }

                      if (selectedPoint != null) {
                        widget.pathProps.selectPoint(selectedPoint);
                        return;
                      }

                      if (RawKeyboard.instance.keysPressed.contains(
                            LogicalKeyboardKey.controlLeft,
                          ) ||
                          RawKeyboard.instance.keysPressed.contains(
                            LogicalKeyboardKey.controlRight,
                          )) {
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
                        final List<Segment> segments =
                            widget.pathProps.segments;
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
                              RawKeyboard.instance.keysPressed.contains(
                                LogicalKeyboardKey.keyF,
                              )) {
                            if (currentDragPoint.draggingPoint.type ==
                                PointType.inControl) {
                              dragPoints.add(
                                FullDraggingPoint(
                                  currentDragPoint.index,
                                  DraggingPoint(
                                    PointType.outControl,
                                    Offset.fromDirection(
                                      currentDragPoint.draggingPoint.position
                                              .direction +
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
                                      currentDragPoint.draggingPoint.position
                                              .direction +
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
                        if (RawKeyboard.instance.keysPressed.contains(
                              LogicalKeyboardKey.controlLeft,
                            ) ||
                            RawKeyboard.instance.keysPressed.contains(
                              LogicalKeyboardKey.controlRight,
                            )) {
                          setState(() {
                            localImageOffsetAddition =
                                localImageOffsetAddition +
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
                          widget.pathProps.imageOffset +
                              localImageOffsetAddition,
                        );
                        setState(() {
                          localImageOffsetAddition = Offset.zero;
                          localImageZoomAddition = 0;
                        });
                      }
                      FullDraggingPoint? previusDraggingPoint;

                      for (final FullDraggingPoint draggingPoint
                          in dragPoints) {
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
        ),
      );
}

const Shortcut noZoomShortcut = Shortcut(
  shortcut: "Ctrl + 0",
  description: "Reset zoom",
  activator: SingleActivator(LogicalKeyboardKey.digit0, control: true),
);
const Shortcut toggleHeading = Shortcut(
  shortcut: "h",
  description:
      "Toggles ability to move heading points without selecting specific point",
  activator: SingleActivator(LogicalKeyboardKey.keyH),
);
const Shortcut toggleControl = Shortcut(
  shortcut: "g",
  description:
      "Toggles ability to move control points without selecting specific point",
  activator: SingleActivator(LogicalKeyboardKey.keyG),
);
const Shortcut unSelectPoint = Shortcut(
  shortcut: "On Point + ESC",
  description: "Unselect the current selected point",
  activator: SingleActivator(LogicalKeyboardKey.escape),
);
const Shortcut deletePoint = Shortcut(
  shortcut: "On Point + Ctrl + Backspace",
  description: "Delete the current selected point",
  activator: SingleActivator(LogicalKeyboardKey.backspace, control: true),
);
const Shortcut undo = Shortcut(
  shortcut: "Ctrl + z",
  description: "Undo the last action",
  activator: SingleActivator(LogicalKeyboardKey.keyZ, control: true),
);
const Shortcut redo = Shortcut(
  description: "Redo the last action",
  shortcut: "Ctrl + y",
  activator: SingleActivator(LogicalKeyboardKey.keyY, control: true),
);
const Shortcut save = Shortcut(
  description: "Save file",
  shortcut: "Ctrl + s",
  activator: SingleActivator(LogicalKeyboardKey.keyS, control: true),
);
const Shortcut saveAs = Shortcut(
  description: "Save file as",
  shortcut: "Ctrl + Shift + s",
  activator:
      SingleActivator(LogicalKeyboardKey.escape, control: true, shift: true),
);
const Shortcut zoomIn = Shortcut(
  description: "Zoom in",
  shortcut: "Ctrl + =",
  activator: SingleActivator(LogicalKeyboardKey.equal, control: true),
);
const Shortcut zoomOut = Shortcut(
  description: "Zoom out",
  shortcut: "Ctrl + -",
  activator: SingleActivator(LogicalKeyboardKey.minus, control: true),
);
const Shortcut panUp = Shortcut(
  description: "Pan up",
  shortcut: "Ctrl + Up_Arrow",
  activator: SingleActivator(LogicalKeyboardKey.arrowUp, control: true),
);
const Shortcut panDown = Shortcut(
  description: "Pan down",
  shortcut: "Ctrl + Down_Arrow",
  activator: SingleActivator(LogicalKeyboardKey.arrowDown, control: true),
);
const Shortcut panLeft = Shortcut(
  description: "Pan left",
  shortcut: "Ctrl + Left_Arrow",
  activator: SingleActivator(LogicalKeyboardKey.arrowLeft, control: true),
);
const Shortcut panRight = Shortcut(
  description: "Pan right",
  shortcut: "Ctrl + Right_Arrow",
  activator: SingleActivator(LogicalKeyboardKey.arrowRight, control: true),
);
const Shortcut addPoint = Shortcut(
  description: "Add point",
  shortcut: "Ctrl + Mouse press",
);
const Shortcut stopPointToggle = Shortcut(
  description: "On stop point, the control points become collinear",
  shortcut: "On Stop Point + Control Point Pressed + f",
);
const Shortcut mouseDragPan = Shortcut(
  shortcut: "Ctrl + Mouse Drag",
  description: "Pan with mouse",
);

const Shortcut deleteTab = Shortcut(
  shortcut: "Long Press a tab",
  description: "Deletes the pressed tab",
);

const Shortcut animateRobot = Shortcut(
  shortcut: "Ctrl + A",
  description: "Animates robot in field",
  activator: SingleActivator(LogicalKeyboardKey.keyA, control: true),
);
const Shortcut copyPoint = Shortcut(
  shortcut: "On Point + Ctrl + C",
  description: "Copies the current selected point",
  activator: SingleActivator(LogicalKeyboardKey.keyC, control: true),
);

const Shortcut pastePoint = Shortcut(
  shortcut: "On Point + Ctrl + V",
  description: "Pastes the current selected point",
  activator: SingleActivator(LogicalKeyboardKey.keyV, control: true),
);

const List<Shortcut> shortcuts = <Shortcut>[
  stopPointToggle,
  panUp,
  panDown,
  panLeft,
  panRight,
  noZoomShortcut,
  zoomIn,
  zoomOut,
  toggleHeading,
  toggleControl,
  unSelectPoint,
  deletePoint,
  addPoint,
  undo,
  redo,
  save,
  saveAs,
  deleteTab,
  animateRobot,
  copyPoint,
  pastePoint,
];
