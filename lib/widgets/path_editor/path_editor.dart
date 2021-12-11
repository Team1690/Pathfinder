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
  final List<rpc.SplineResponse_Point>? evaulatedPoints;

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
  });

  static PathViewModel fromStore(Store<AppState> store) {
    return PathViewModel(
        points: store.state.tabState.path.points
            .map((p) => p.toUiCoord(store))
            .toList(),
        segments: store.state.tabState.path.segments,
        evaulatedPoints: store.state.tabState.path.evaluatedPoints,
        selectedPointIndex: (store.state.tabState.ui.selectedType == Point
            ? store.state.tabState.ui.selectedIndex
            : null),
        addPoint: (Offset position) {
          store.dispatch(addPointThunk(uiToMetersCoord(store, position)));
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
        });
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
  DraggingPoint? dragPoint;
  int? dragPointIndex;
  Offset ImageSize = Offset(0,0);

  _PathEditorState();

  int? getTappedPoint(Offset tapPosition, List<Point> points) {
    for (final entery in widget.pathProps.points.asMap().entries) {
      Point point = entery.value;
      int index = entery.key;

      double radius = pointSettings[PointType.path]!.radius;
      if ((tapPosition - point.position).distance <= radius) {
        return index;
      }
    }
  }

  DraggingPoint? checkSelectedPointTap(Offset tapPosition, Point point) {
    Offset headingPointCenter = Offset.fromDirection(point.heading, headingLength);
      if ((headingPointCenter - tapPosition).distance < pointSettings[PointType.heading]!.radius) {
        return DraggingPoint(PointType.heading, headingPointCenter);
      }

      if ((point.inControlPoint - tapPosition).distance < pointSettings[PointType.inControl]!.radius) {
        return DraggingPoint(PointType.inControl, point.inControlPoint);
      }

      if ((point.outControlPoint - tapPosition).distance < pointSettings[PointType.outControl]!.radius) {
        return DraggingPoint(PointType.outControl, point.outControlPoint);
      }
  }

  @override
  Widget build(final BuildContext context) {
    final PointSettings pointSetting = pointSettings[PointType.path]!;

    return RawKeyboardListener(
      autofocus: true,
      focusNode: FocusNode(),
      onKey: (final RawKeyEvent event) {
        setState(() {
          if (event is RawKeyDownEvent)
            pressedKeys.add(event.logicalKey);
          else if (event is RawKeyUpEvent) pressedKeys.remove(event.logicalKey);
          shiftPressed = pressedKeys.contains(LogicalKeyboardKey.shiftLeft);
          ctrlPressed = pressedKeys.contains(LogicalKeyboardKey.controlLeft) ||
              pressedKeys.contains(LogicalKeyboardKey.metaLeft);
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
              child: FieldLoader(widget.pathProps.points, widget.pathProps.selectedPointIndex, dragPoint, shiftPressed, ctrlPressed),
              onTapUp: (final TapUpDetails detailes) {
                final Offset tapPos = detailes.localPosition;

                int? selectedPoint = getTappedPoint(tapPos, widget.pathProps.points);
                if (selectedPoint != null) {
                  widget.pathProps.selectPoint(selectedPoint);
                  return;
                } 

                widget.pathProps.addPoint(tapPos);
              },
              onPanStart: (DragStartDetails details) {
                int? currentSelecedPointIndex = widget.pathProps.selectedPointIndex;
                if (currentSelecedPointIndex != null) {
                  DraggingPoint? draggingPoint = checkSelectedPointTap(details.localPosition, widget.pathProps.points[currentSelecedPointIndex]);
                  if (draggingPoint != null) {
                    setState(() {
                      dragPoint = draggingPoint;
                    });
                  }
                }

                int? selectedPoint = getTappedPoint(details.localPosition, widget.pathProps.points);
                if (selectedPoint != null) {
                  setState(() {
                    dragPointIndex = selectedPoint;
                    dragPoint = DraggingPoint(PointType.path, widget.pathProps.points[selectedPoint].position);
                  });
                }
              },
              onPanUpdate: (DragUpdateDetails details) {
                if (dragPoint != null) {
                  setState(() {
                    dragPoint = DraggingPoint(dragPoint!.type, Offset(dragPoint!.position.dx + details.delta.dx, dragPoint!.position.dy + details.delta.dy));
                  });
                }
              },
              onPanEnd: (DragEndDetails details) {
                if (dragPoint != null) {
                  switch (dragPoint!.type) {
                    case PointType.path:
                      widget.pathProps.finishDrag(dragPointIndex!, dragPoint!.position);
                      break;
                    case PointType.inControl:
                      widget.pathProps.finishInControlDrag(dragPointIndex!, dragPoint!.position);
                      break;
                    case PointType.outControl:
                      widget.pathProps.finishOutControlDrag(dragPointIndex!, dragPoint!.position);
                      break;
                    default:
                      break;
                  }
                }

                setState(() {
                  dragPointIndex = null;
                  dragPoint = null;
                });
              }
            ),

            for (final evaluatedPoint in widget.pathProps.evaulatedPoints ?? [])
              SplinePoint(point: evaluatedPoint)
          ],
        ),
      ),
    );
  }
}
