import 'dart:async';
import 'dart:ui';

import 'package:pathfinder/rpc/protos/PathFinder.pb.dart' as rpc;
import 'package:pathfinder/store/tab/tab_actions.dart';
import 'package:pathfinder/store/tab/tab_thunk.dart';
import 'package:pathfinder/widgets/path_editor/full_path_point.dart';
import 'package:pathfinder/widgets/path_editor/temp_spline_point.dart';
import 'package:redux/redux.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:pathfinder/models/point.dart';
import 'package:pathfinder/models/segment.dart';
import 'package:pathfinder/store/app/app_state.dart';
import 'package:pathfinder/widgets/path_editor/dashed_line_painter.dart';
import 'package:pathfinder/widgets/path_editor/heading_line_painter.dart';
import 'package:pathfinder/widgets/path_editor/path_point.dart';

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
      points: store.state.tabState.path.points,
      segments: store.state.tabState.path.segments,
      evaulatedPoints: store.state.tabState.path.evaluatedPoints,
      selectedPointIndex: (store.state.tabState.ui.selectedType == Point
          ? store.state.tabState.ui.selectedIndex
          : null),
      addPoint: (Offset position) {
        store.dispatch(addPointThunk(position));
      },
      deletePoint: (int index) {
        store.dispatch(removePointThunk(index));
      },
      finishDrag: (int index, Offset position) {
        store.dispatch(endDragThunk(index, position));
      },
      selectPoint: (int index) {
        store.dispatch(ObjectSelected(index, Point));
      },
      finishInControlDrag: (int index, Offset position) {
        store.dispatch(endInControlDragThunk(index, position));
      },
      finishOutControlDrag: (int index, Offset position) {
        store.dispatch(endOutControlDragThunk(index, position));
      }
    );
  }
}

StoreConnector<AppState, PathViewModel> pathEditor() {
  return new StoreConnector<AppState, PathViewModel>(
      converter: (store) => PathViewModel.fromStore(store),
      builder: (_, props) => _PathEditor(pathProps: props));
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
  Offset? dragPoint;

  _PathEditorState();

  @override
  Widget build(final BuildContext context) {
    // TODO maintain focus when pressing on points
    Point? selectedPoint;
    if (widget.pathProps.selectedPointIndex != null) {
      selectedPoint =
          widget.pathProps.points[widget.pathProps.selectedPointIndex!];
    }

    return RawKeyboardListener(
      autofocus: true,
      focusNode: FocusNode(),
      onKey: (final RawKeyEvent event) {
        // setState(() {
        //   if (event is RawKeyDownEvent)
        //     pressedKeys.add(event.logicalKey);
        //   else if (event is RawKeyUpEvent) pressedKeys.remove(event.logicalKey);

        //   shiftPressed = pressedKeys.contains(LogicalKeyboardKey.shiftLeft);
        //   ctrlPressed = pressedKeys.contains(LogicalKeyboardKey.controlLeft) ||
        //       pressedKeys.contains(LogicalKeyboardKey.metaLeft);
        // });

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
              child: const Image(
                image: const AssetImage('assets/images/frc_2020_field.png'),
              ),
              onTapDown: (final TapDownDetails detailes) {
                // Add point to board
                final Offset tapPos = detailes.localPosition;
                widget.pathProps.addPoint(tapPos);
              },
              onPanStart: (_) {},
            ),

            // Draw dragging point
            if (dragPoint != null)
              Positioned(
                top: dragPoint!.dy - PathPoint.pathPointRadius,
                left: dragPoint!.dx - PathPoint.pathPointRadius,
                child: Container(
                  width: 2 * PathPoint.pathPointRadius,
                  height: 2 * PathPoint.pathPointRadius,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: PathPoint.noneControlPointColor,
                  ),
                ),
              ),

            ...[
              for (final entery in widget.pathProps.points.asMap().entries)
                FullPathPoint(
                  key: Key(entery.key.toString()),
                  point: entery.value,
                  onDrag: (final DragUpdateDetails details) {
                    // Drag point on bored
                    setState(() {
                      if (dragPoint == null) {
                        Offset basePoint = entery.value.position;
                        dragPoint = Offset(basePoint.dx + details.delta.dx,
                            basePoint.dy + details.delta.dy);
                      } else {
                        dragPoint = Offset(dragPoint!.dx + details.delta.dx,
                            dragPoint!.dy + details.delta.dy);
                      }
                    });
                  },
                  onDragEnd: (_) {
                    // Finish to drag point on bored
                    widget.pathProps.finishDrag(entery.key, dragPoint!);
                    setState(() {
                      dragPoint = null;
                    });
                  },
                  onTap: () {
                    widget.pathProps.selectPoint(entery.key);
                  },
                  isSelected: entery.key == widget.pathProps.selectedPointIndex,
                  onInControlDragEnd: (Offset position) {
                    widget.pathProps.finishInControlDrag(entery.key, position);
                  },
                  onOutControlDragEnd: (Offset position) {
                    print(position);
                    widget.pathProps.finishOutControlDrag(entery.key, position);
                  },
                )
            ],

            for (final evaluatedPoint in widget.pathProps.evaulatedPoints ?? [])
              SplinePoint(point: evaluatedPoint)
          ],
        ),
      ),
    );
  }
}
