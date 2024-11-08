import "dart:async";
import "dart:math";

import "package:collection/collection.dart";
import "package:flutter/gestures.dart";
import "package:pathfinder_gui/constants.dart";
import "package:pathfinder_gui/utils/offset_extensions.dart";
import "package:pathfinder_gui/views/editor/point_type.dart";
import "package:pathfinder_gui/shortcuts/shortcut_def.dart";
import "package:pathfinder_gui/views/editor/painter/field_loader.dart";
import "package:pathfinder_gui/utils/coordinates_conversion.dart";
import "package:flutter/material.dart";
import "package:flutter/services.dart";
import "package:flutter_redux/flutter_redux.dart";
import "package:pathfinder_gui/models/path_point.dart";
import "package:pathfinder_gui/models/segment.dart";
import "package:pathfinder_gui/store/app/app_state.dart";
import "package:pathfinder_gui/views/editor/dragging_point.dart";
import "package:pathfinder_gui/views/editor/path_editor/path_editor_model.dart";

const double _minZoom = 0.4;
const double _maxZoom = 8.0;

const double _imageZoomDiff = 0.1;
const double _imageOffsetDiff = 10;

class PathEditor extends StatefulWidget {
  @override
  _PathEditorState createState() => _PathEditorState();
}

class _PathEditorState extends State<PathEditor> {
  DraggingPoint? dragPoint;
  List<DraggingPoint> dragPoints = <DraggingPoint>[];
  bool isScrolling = false;
  Timer? scrollTimer;

  Offset localImageOffsetAddition = Offset.zero;
  double localImageZoomAddition = 0;

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
    final PathEditorModel pathProps,
  ) {
    //TODO: bad comment to explain this

    // This is just an equation for receiving zoom offset accorind to actualOffset
    // imageOffetWithoutZoomOffset - getZoomOffset(fieldSizePixels,imageZoomBeforeDiff, imageOffetWithoutZoomOffset) = imageOffset
    // imageOffetWithoutZoomOffset - (1 - zoom) * (size / 2 - imageOffetWithoutZoomOffset)                           = imageOffset
    // The variable is imageOffetWithoutZoomOffset and you know:
    // imageZoomBeforeDiff (widget.pathProps.imageZoom), imageOffset (widget.pathProps.imageOffset) and fieldSizePixels (widget.pathProps.fieldSizePixels)
    final Offset offsetWithoutZoomOffset = pathProps.imageOffset -
        pathProps.imageOffset -
        pathProps.fieldSizePixels
            .scaleBy(0.5)
            .scaleBy(1 - pathProps.imageZoom)
            .scaleBy(1 / pathProps.imageZoom);

    final Offset oldZoomOffset = getZoomOffset(
      pathProps.fieldSizePixels,
      pathProps.imageZoom,
      pathProps.imageOffset - offsetWithoutZoomOffset,
    );

    final Offset newImageZoomOffset = getZoomOffset(
      pathProps.fieldSizePixels,
      pathProps.imageZoom + diff,
      pathProps.imageOffset - oldZoomOffset,
    );

    final Offset newImageOffset =
        pathProps.imageOffset - oldZoomOffset + newImageZoomOffset;

    pathProps.setImageOffset(
      newImageOffset,
    );
  }

//TODO: maybe points and segments don't need to be params
  int? getTappedPoint(
    final Offset tapPosition,
    final List<PathPoint> points,
    final List<Segment> segments,
    final PathEditorModel pathProps,
  ) {
    int? tappedIndex;
    points.forEachIndexed((final int index, final PathPoint pathPoint) {
      if (checkSelectedPointTap(
            tapPosition,
            pathPoint,
            index,
            PointType.regular,
            segments,
            pathProps,
          ) !=
          null) {
        tappedIndex = index;
      }
    });
    return tappedIndex;
  }

  DraggingPoint? checkSelectedPointTap(
    final Offset tapPosition,
    final PathPoint point,
    final int index,
    final PointType pointType,
    final List<Segment> segments,
    final PathEditorModel pathProps,
  ) {
    final Offset realTapPosition =
        (tapPosition - pathProps.imageOffset) / pathProps.imageZoom;

    final (int, Segment)? segment = segments
        .mapIndexed(
          (final int segIndex, final Segment element) => (segIndex, element),
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

    final double radius = pointType.radius * pathProps.imageZoom;
    Offset pointPosition = point.position;
    Offset pointCenter = point.position;

    if (pointType == PointType.heading && point.useHeading) {
      pointCenter = Offset.fromDirection(point.heading, headingArmLength);
      pointPosition = point.position + pointCenter;
    }
    if (pointType == PointType.controlIn) {
      pointPosition = point.position + point.inControlPoint;
      pointCenter = point.inControlPoint;
    }
    if (pointType == PointType.controlOut) {
      pointPosition = point.position + point.outControlPoint;
      pointCenter = point.outControlPoint;
    }
    if ((pointPosition - realTapPosition).distance <= radius) {
      return DraggingPoint(type: pointType, position: pointCenter);
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
  Widget build(final BuildContext context) =>
      StoreConnector<AppState, PathEditorModel>(
        converter: PathEditorModel.fromStore,
        builder: (final BuildContext context, final PathEditorModel model) =>
            CallbackShortcuts(
          bindings: <ShortcutActivator, VoidCallback>{
            noZoomShortcut.activator!: () {
              model.setImageZoom(1);
              model.setImageOffset(Offset.zero);
            },
            toggleHeading.activator!: model.toggleHeading,
            toggleControl.activator!: model.toggleControl,
            unSelectPoint.activator!: model.unSelectPoint,
            deletePoint.activator!: () {
              if (model.selectedPointIndex != null) {
                model.deletePoint(model.selectedPointIndex!);
              }
            },
            undo.activator!: model.pathUndo,
            redo.activator!: model.pathRedo,
            save.activator!: model.saveFile,
            saveAs.activator!: model.saveFileAs,
            zoomIn.activator!: () {
              if (model.imageZoom + _imageZoomDiff > _maxZoom) return;
              model.setImageZoom(model.imageZoom + _imageZoomDiff);
              moveZoomByDiff(_imageZoomDiff, model);
            },
            zoomOut.activator!: () {
              if (model.imageZoom - _imageZoomDiff < _minZoom) return;
              model.setImageZoom(model.imageZoom - _imageZoomDiff);
              moveZoomByDiff(-_imageZoomDiff, model);
            },
            panUp.activator!: () {
              model.setImageOffset(
                model.imageOffset - const Offset(0, _imageOffsetDiff),
              );
            },
            panDown.activator!: () {
              model.setImageOffset(
                model.imageOffset + const Offset(0, _imageOffsetDiff),
              );
            },
            panLeft.activator!: () {
              model.setImageOffset(
                model.imageOffset + const Offset(_imageOffsetDiff, 0),
              );
            },
            panRight.activator!: () {
              model.setImageOffset(
                model.imageOffset - const Offset(_imageOffsetDiff, 0),
              );
            },
            animateRobot.activator!: model.animateRobot,
            copyPoint.activator!: () {
              if (model.selectedPointIndex != null) {
                model.copyPoint(model.selectedPointIndex!);
              }
            },
            pastePoint.activator!: () {
              if (model.selectedPointIndex != null) {
                model.pastePoint(model.selectedPointIndex! + 1);
              } else {
                model.pastePoint(model.points.length);
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
                              model.setZoomAndOffset(
                                model.imageZoom + localImageZoomAddition,
                                model.imageOffset + localImageOffsetAddition,
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
                            model.imageZoom + localImageZoomAddition;
                        final Offset currentOffset =
                            model.imageOffset + localImageOffsetAddition;

                        final double delta =
                            pointerSignal.scrollDelta.dy * -0.01;

                        final double newZoom = currentZoom + delta;
                        final Offset mousePosition =
                            flipYAxis(pointerSignal.localPosition) +
                                Offset(0, model.fieldSizePixels.dy);

                        final Offset finalOffset = currentOffset +
                            (mousePosition - currentOffset) *
                                (1 - newZoom / currentZoom);

                        if (newZoom < _minZoom) return;
                        if (newZoom > _maxZoom) return;

                        setState(() {
                          isScrolling = true;
                          localImageOffsetAddition =
                              finalOffset - model.imageOffset;
                          localImageZoomAddition = newZoom - model.imageZoom;
                        });
                      }
                    },
                    child: GestureDetector(
                      child: ClipRect(
                        clipBehavior: Clip.hardEdge,
                        child: FieldLoader(
                          model.points,
                          model.segments,
                          model.selectedPointIndex,
                          dragPoints,
                          model.headingToggle,
                          model.controlToggle,
                          model.evaulatedPoints,
                          model.setFieldSizePixels,
                          model.robot,
                          model.imageZoom + localImageZoomAddition,
                          model.imageOffset + localImageOffsetAddition,
                          model.robotOnField,
                        ),
                      ),
                      onSecondaryTapDown: (final TapDownDetails details) {
                        final Offset tapPos = flipYAxisByField(
                          details.localPosition,
                          model.fieldSizePixels,
                        );

                        model.selectRobotOnField(tapPos);
                      },
                      onTapUp: (final TapUpDetails details) {
                        final Offset tapPos = flipYAxisByField(
                          details.localPosition,
                          model.fieldSizePixels,
                        );

                        final int? selectedPoint = getTappedPoint(
                          tapPos,
                          model.points,
                          model.segments,
                          model,
                        );

                        if (model.selectedPointIndex != null &&
                            model.selectedPointIndex! >= 0 &&
                            selectedPoint == model.selectedPointIndex) {
                          model.unSelectPoint();
                          return;
                        }

                        if (selectedPoint != null) {
                          model.selectPoint(selectedPoint);
                          return;
                        }

                        if (HardwareKeyboard.instance.logicalKeysPressed
                                .contains(
                              LogicalKeyboardKey.controlLeft,
                            ) ||
                            HardwareKeyboard.instance.logicalKeysPressed
                                .contains(
                              LogicalKeyboardKey.controlRight,
                            )) {
                          final Offset realTapPosition =
                              (tapPos - model.imageOffset) / model.imageZoom;
                          model.addPoint(realTapPosition);
                          return;
                        }

                        model.unSelectPoint();
                      },
                      onPanStart: (final DragStartDetails details) {
                        setState(() {
                          localImageOffsetAddition = Offset.zero;
                          localImageZoomAddition = 0;
                        });

                        final Offset tapPos = flipYAxisByField(
                          details.localPosition,
                          model.fieldSizePixels,
                        );

                        for (final MapEntry<int, PathPoint> entery
                            in model.points.asMap().entries) {
                          final PathPoint point = entery.value;
                          final int index = entery.key;

                          DraggingPoint? draggingPoint;

                          bool controlToggle = model.controlToggle;
                          bool headingToggle = model.headingToggle;

                          if (model.selectedPointIndex != null &&
                              model.selectedPointIndex! >= 0) {
                            controlToggle = model.selectedPointIndex == index;
                            headingToggle = model.selectedPointIndex == index;
                          }
                          final List<Segment> segments = model.segments;
                          if (headingToggle) {
                            draggingPoint = checkSelectedPointTap(
                              tapPos,
                              point,
                              index,
                              PointType.heading,
                              segments,
                              model,
                            );
                          }

                          if (controlToggle && draggingPoint == null) {
                            draggingPoint = checkSelectedPointTap(
                              tapPos,
                              point,
                              index,
                              PointType.controlIn,
                              segments,
                              model,
                            );
                          }

                          if (controlToggle && draggingPoint == null) {
                            draggingPoint = checkSelectedPointTap(
                              tapPos,
                              point,
                              index,
                              PointType.controlOut,
                              segments,
                              model,
                            );
                          }

                          draggingPoint ??= checkSelectedPointTap(
                            tapPos,
                            point,
                            index,
                            PointType.regular,
                            segments,
                            model,
                          );

                          if (draggingPoint != null) {
                            final DraggingPoint fullDraggingPoint =
                                DraggingPoint(
                              type: draggingPoint.type,
                              position: draggingPoint.position,
                              index: index,
                            );

                            setState(() {
                              dragPoint = fullDraggingPoint;
                            });

                            break;
                          }
                        }
                      },
                      onPanUpdate: (final DragUpdateDetails details) {
                        if (dragPoint != null) {
                          DraggingPoint currentDragPoint = dragPoint!;
                          setState(() {
                            currentDragPoint = DraggingPoint(
                              type: currentDragPoint.type,
                              position: currentDragPoint.position +
                                  (flipYAxis(details.delta) / model.imageZoom),
                              index: currentDragPoint.index,
                            );
                            dragPoint = currentDragPoint;
                            dragPoints = <DraggingPoint>[currentDragPoint];

                            if (!model.points[currentDragPoint.index].isStop ||
                                HardwareKeyboard.instance.logicalKeysPressed
                                    .contains(
                                  LogicalKeyboardKey.keyF,
                                )) {
                              if (currentDragPoint.type ==
                                  PointType.controlIn) {
                                dragPoints.add(
                                  DraggingPoint(
                                    type: PointType.controlOut,
                                    position: Offset.fromDirection(
                                      currentDragPoint.position.direction + pi,
                                      model.points[currentDragPoint.index]
                                          .outControlPoint.distance,
                                    ),
                                    index: currentDragPoint.index,
                                  ),
                                );
                              } else if (currentDragPoint.type ==
                                  PointType.controlOut) {
                                dragPoints.add(
                                  DraggingPoint(
                                    type: PointType.controlIn,
                                    position: Offset.fromDirection(
                                      currentDragPoint.position.direction + pi,
                                      model.points[currentDragPoint.index]
                                          .inControlPoint.distance,
                                    ),
                                    index: currentDragPoint.index,
                                  ),
                                );
                              }
                            }
                          });
                        } else {
                          if (HardwareKeyboard.instance.logicalKeysPressed
                                  .contains(
                                LogicalKeyboardKey.controlLeft,
                              ) ||
                              HardwareKeyboard.instance.logicalKeysPressed
                                  .contains(
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
                          model.setZoomAndOffset(
                            model.imageZoom + localImageZoomAddition,
                            model.imageOffset + localImageOffsetAddition,
                          );
                          setState(() {
                            localImageOffsetAddition = Offset.zero;
                            localImageZoomAddition = 0;
                          });
                        }
                        DraggingPoint? previusDraggingPoint;

                        for (final DraggingPoint draggingPoint in dragPoints) {
                          switch (draggingPoint.type) {
                            case PointType.first:
                            case PointType.last:
                            case PointType.stop:
                            case PointType.regular:
                              model.finishDrag(
                                draggingPoint.index,
                                draggingPoint.position,
                              );
                              break;
                            case PointType.controlIn:
                              if (model.points[draggingPoint.index].isStop) {
                                model.finishInControlDrag(
                                  draggingPoint.index,
                                  draggingPoint.position,
                                );
                                break;
                              }

                              if (previusDraggingPoint == null) {
                                previusDraggingPoint = draggingPoint;
                                break;
                              }

                              model.finishControlDrag(
                                draggingPoint.index,
                                draggingPoint.position,
                                previusDraggingPoint.position,
                              );
                              break;
                            case PointType.controlOut:
                              if (model.points[draggingPoint.index].isStop) {
                                model.finishOutControlDrag(
                                  draggingPoint.index,
                                  draggingPoint.position,
                                );
                                break;
                              }

                              if (previusDraggingPoint == null) {
                                previusDraggingPoint = draggingPoint;
                                break;
                              }

                              model.finishControlDrag(
                                draggingPoint.index,
                                previusDraggingPoint.position,
                                draggingPoint.position,
                              );
                              break;
                            case PointType.heading:
                              final Offset dragPosition =
                                  draggingPoint.position;
                              final double dragHeading = dragPosition.direction;
                              model.finishHeadingDrag(
                                draggingPoint.index,
                                dragHeading,
                              );
                              break;
                            default:
                              break;
                          }
                        }

                        setState(() {
                          dragPoints = <DraggingPoint>[];
                          dragPoint = null;
                        });
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
}
