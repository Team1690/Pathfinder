import 'package:pathfinder/rpc/protos/PathFinder.pb.dart' as rpc;
import 'package:pathfinder/store/tab/tab_actions.dart';
import 'package:pathfinder/store/tab/tab_thunk.dart';
import 'package:pathfinder/widgets/path_editor/field_editor.dart';
import 'package:pathfinder/utils/coordinates_convertion.dart';
import 'package:pathfinder/widgets/path_editor/temp_spline_point.dart';
import 'package:redux/redux.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:pathfinder/models/point.dart';
import 'package:pathfinder/models/segment.dart';
import 'package:pathfinder/store/app/app_state.dart';
import 'package:pathfinder/utils/coordinates_convertion.dart';

class PathViewModel {
  final List<Point> points;
  final List<Segment> segments;
  final int? selectedPointIndex;
  final Function(Offset) addPoint;
  final Function(int) deletePoint;
  final Function(int, Offset) finishDrag;
  final Function(int) selectPoint;
  final Function(int, Offset) finishInControlDrag;
  final Function(int, Offset) finishOutControlDrag;
  final Function(int, double) finishHeadingDrag;
  final Function(Offset) setFieldSizePixels;
  final List<Offset>? evaulatedPoints;

  PathViewModel({
    required this.points,
    required this.segments,
    required this.selectedPointIndex,
    required this.addPoint,
    required this.deletePoint,
    required this.finishDrag,
    required this.selectPoint,
    required this.evaulatedPoints,
    required this.finishInControlDrag,
    required this.finishOutControlDrag,
    required this.finishHeadingDrag,
    required this.setFieldSizePixels,
  });

  static PathViewModel fromStore(Store<AppState> store) {
    return PathViewModel(
      points: store.state.tabState.path.points
          .map((p) => p.toUiCoord(store))
          .toList(),
      segments: store.state.tabState.path.segments,
      evaulatedPoints: store.state.tabState.path.evaluatedPoints == null
          ? []
          : store.state.tabState.path.evaluatedPoints!
              .map((p) => metersToUiCoord(store, Offset(p.point.x, p.point.y)))
              .toList(),
      selectedPointIndex: (store.state.tabState.ui.selectedType == Point
          ? store.state.tabState.ui.selectedIndex
          : null),
      addPoint: (Offset position) {
        store.dispatch(addPointThunk(uiToMetersCoord(store, position), -1, -1));
      },
      deletePoint: (int index) {
        store.dispatch(removePointThunk(index));
      },
      finishDrag: (int index, Offset position) {
        store.dispatch(endDragThunk(index, uiToMetersCoord(store, position)));
      },
      selectPoint: (int index) {
        store.dispatch(ObjectSelected(index, Point));
      },
      finishInControlDrag: (int index, Offset position) {
        store.dispatch(
            endInControlDragThunk(index, uiToMetersCoord(store, position)));
      },
      finishOutControlDrag: (int index, Offset position) {
        store.dispatch(
            endOutControlDragThunk(index, uiToMetersCoord(store, position)));
      },
      finishHeadingDrag: (int index, double heading) {
        store.dispatch(endHeadingDragThunk(index, heading));
      },
      setFieldSizePixels: (Offset size) {
        if (store.state.tabState.ui.fieldSizePixels != size) {
          store.dispatch(SetFieldSizePixels(size));
        }
      },
    );
  }
}

StoreConnector<AppState, PathViewModel> pathEditor() {
  return new StoreConnector<AppState, PathViewModel>(
      converter: (store) => PathViewModel.fromStore(store),
      builder: (_, props) => _PathEditor(pathProps: props));
}

class DraggingPoint {
  final PointType type;
  final Offset position;

  DraggingPoint(this.type, this.position);
}

class FullDraggingPoint {
  int index;
  final DraggingPoint draggingPoint;

  FullDraggingPoint(this.index, this.draggingPoint);
}

const int DraggingTollerance = 2;

class _PathEditor extends StatefulWidget {
  final PathViewModel pathProps;

  _PathEditor({
    required this.pathProps,
  });

  @override
  _PathEditorState createState() => _PathEditorState();
}

class _PathEditorState extends State<_PathEditor> {
  Set<LogicalKeyboardKey> pressedKeys = {};
  bool shiftPressed = false;
  bool ctrlPressed = false;
  bool aPressed = false;
  List<FullDraggingPoint> dragPoints = [];

  _PathEditorState();

  int? getTappedPoint(Offset tapPosition, List<Point> points) {
    for (final entery in widget.pathProps.points.asMap().entries) {
      Point point = entery.value;
      int index = entery.key;

      if (checkSelectedPointTap(tapPosition, point, PointType.path) != null) {
        return index;
      }
    }
  }

  DraggingPoint? checkSelectedPointTap(
      Offset tapPosition, Point point, PointType pointType) {
    if (pointType == PointType.path) {
      double radius = pointSettings[PointType.path]!.radius;
      if ((tapPosition - point.position).distance <=
          radius + DraggingTollerance) {
        return DraggingPoint(PointType.path, point.position);
      }
    }

    if (pointType == PointType.heading) {
      Offset headingCenter = Offset.fromDirection(point.heading, headingLength);
      Offset headingPosition = point.position + headingCenter;
      if ((headingPosition - tapPosition).distance <
          pointSettings[PointType.heading]!.radius + DraggingTollerance) {
        return DraggingPoint(PointType.heading, headingCenter);
      }
    }

    if (pointType == PointType.inControl || pointType == PointType.outControl) {
      Offset inControlPosition = point.position + point.inControlPoint;
      if ((inControlPosition - tapPosition).distance <
          pointSettings[PointType.inControl]!.radius + DraggingTollerance) {
        return DraggingPoint(PointType.inControl, point.inControlPoint);
      }

      Offset outControlPosition = point.position + point.outControlPoint;
      if ((outControlPosition - tapPosition).distance <
          pointSettings[PointType.outControl]!.radius + DraggingTollerance) {
        return DraggingPoint(PointType.outControl, point.outControlPoint);
      }
    }
  }

  @override
  Widget build(final BuildContext context) {
    return RawKeyboardListener(
      autofocus: true,
      focusNode: FocusNode(),
      onKey: (final RawKeyEvent event) {
        setState(() {
          if (event is RawKeyDownEvent) {
            pressedKeys.add(event.logicalKey);
          } else if (event is RawKeyUpEvent) {
            pressedKeys.remove(event.logicalKey);
          }

          shiftPressed = pressedKeys.contains(LogicalKeyboardKey.shiftLeft);
          ctrlPressed = pressedKeys.contains(LogicalKeyboardKey.controlLeft) ||
              pressedKeys.contains(LogicalKeyboardKey.metaLeft);
          aPressed = pressedKeys.contains(LogicalKeyboardKey.keyA);
        });

        // if (ctrlPressed) {
        //   if (pressedKeys.contains(LogicalKeyboardKey.keyZ))
        //     _bloc.add(Undo());
        //   else if (pressedKeys.contains(LogicalKeyboardKey.keyY))
        //     _bloc.add(Redo());

        //   if (pressedKeys.contains(LogicalKeyboardKey.backspace)) {
        //     _bloc.add(ClearAllPoints());
        //     selectedPointIndex = null;
        //   }
        // }

        if (pressedKeys.contains(LogicalKeyboardKey.backspace) &&
            widget.pathProps.selectedPointIndex != null) {
          widget.pathProps.deletePoint(widget.pathProps.selectedPointIndex!);
        }
      },
      child: Center(
        child: Stack(
          children: [
            GestureDetector(
                child: FieldLoader(
                  widget.pathProps.points,
                  widget.pathProps.selectedPointIndex,
                  dragPoints,
                  shiftPressed,
                  ctrlPressed,
                  widget.pathProps.evaulatedPoints,
                  widget.pathProps.setFieldSizePixels,
                ),
                onTapUp: (final TapUpDetails detailes) {
                  final Offset tapPos = detailes.localPosition;

                  int? selectedPoint =
                      getTappedPoint(tapPos, widget.pathProps.points);
                  if (selectedPoint != null) {
                    widget.pathProps.selectPoint(selectedPoint);
                    return;
                  }

                  widget.pathProps.addPoint(tapPos);
                },
                onPanStart: (DragStartDetails details) {
                  for (final entery
                      in widget.pathProps.points.asMap().entries) {
                    Point point = entery.value;
                    int index = entery.key;

                    DraggingPoint? draggingPoint;
                    if (shiftPressed) {
                      draggingPoint = checkSelectedPointTap(
                          details.localPosition, point, PointType.heading);
                    }

                    if (ctrlPressed && draggingPoint == null) {
                      draggingPoint = checkSelectedPointTap(
                          details.localPosition, point, PointType.inControl);
                    }

                    if (draggingPoint == null) {
                      draggingPoint = checkSelectedPointTap(
                          details.localPosition, point, PointType.path);
                    }

                    if (draggingPoint != null) {
                      List<FullDraggingPoint> draggingPoints = [
                        FullDraggingPoint(index, draggingPoint)
                      ];
                      if (aPressed) {
                        if (draggingPoint.type == PointType.inControl) {
                          draggingPoints.add(FullDraggingPoint(
                              index,
                              DraggingPoint(PointType.outControl,
                                  -point.inControlPoint)));
                        } else if (draggingPoint.type == PointType.outControl) {
                          draggingPoints.add(FullDraggingPoint(
                              index,
                              DraggingPoint(PointType.inControl,
                                  -point.outControlPoint)));
                        }
                      }
                      setState(() {
                        dragPoints = draggingPoints;
                      });
                      return;
                    }
                  }
                },
                onPanUpdate: (DragUpdateDetails details) {
                  if (dragPoints.length > 0) {
                    setState(() {
                      dragPoints = dragPoints.asMap().entries.map((entery) {
                        int index = entery.key;
                        FullDraggingPoint draggingPoint = entery.value;

                        Offset delta = details.delta;
                        if ((draggingPoint.draggingPoint.type ==
                                    PointType.inControl ||
                                draggingPoint.draggingPoint.type ==
                                    PointType.outControl) &&
                            aPressed &&
                            index % 2 == 1) {
                          delta = -delta;
                        }
                        return FullDraggingPoint(
                            draggingPoint.index,
                            DraggingPoint(draggingPoint.draggingPoint.type,
                                draggingPoint.draggingPoint.position + delta));
                      }).toList();
                    });
                  }
                },
                onPanEnd: (DragEndDetails details) {
                  for (final draggingPoint in dragPoints) {
                    switch (draggingPoint.draggingPoint.type) {
                      case PointType.path:
                        widget.pathProps.finishDrag(draggingPoint.index,
                            draggingPoint.draggingPoint.position);
                        break;
                      case PointType.inControl:
                        widget.pathProps.finishInControlDrag(
                            draggingPoint.index,
                            draggingPoint.draggingPoint.position);
                        break;
                      case PointType.outControl:
                        widget.pathProps.finishOutControlDrag(
                            draggingPoint.index,
                            draggingPoint.draggingPoint.position);
                        break;
                      case PointType.heading:
                        Offset dragPosition =
                            draggingPoint.draggingPoint.position;
                        double dragHeading = dragPosition.direction;
                        widget.pathProps.finishHeadingDrag(
                            draggingPoint.index, dragHeading);
                        break;
                      default:
                        break;
                    }
                  }

                  setState(() {
                    dragPoints = [];
                  });
                }),
          ],
        ),
      ),
    );
  }
}
