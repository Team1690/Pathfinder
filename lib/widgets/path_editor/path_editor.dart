import 'package:pathfinder/rpc/protos/PathFinder.pb.dart' as rpc;
import 'package:pathfinder/store/tab/tab_thunk.dart';
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
  final Function(Offset) addPoint;
  final Function(int) deletePoint;
  final Function(int, Offset) finishDrag;
  final List<rpc.SplineResponse_Point>? evaulatedPoints;

  PathViewModel({
    required this.points,
    required this.segments,
    required this.addPoint,
    required this.deletePoint,
    required this.finishDrag,
    required this.evaulatedPoints,
  });

  static PathViewModel fromStore(Store<AppState> store) {
    return PathViewModel(
        points: store.state.tabState.path.points,
        segments: store.state.tabState.path.segments,
        evaulatedPoints: store.state.tabState.path.evaluatedPoints,
        addPoint: (Offset position) {
          store.dispatch(addPointThunk(position));
        },
        deletePoint: (int index) {
          store.dispatch(removePointThunk(index));
        },
        finishDrag: (int index, Offset position) {
          store.dispatch(editPointThunk(index, position));
        }
        );
  }
}

StoreConnector<AppState, PathViewModel> pathEditor() {
  return new StoreConnector<AppState, PathViewModel>(
      converter: (store) => PathViewModel.fromStore(store),
      builder: (_, pathProps) => _PathEditor(pathProps: pathProps));
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
  int? selectedPointIndex;
  Offset? dragPoint;

  _PathEditorState();

  // renders waypoint and its corresponding control points
  Widget pointWidget({
    required final Point point,
    required final int index,
  }) {
    return
      PathPoint(
        point: point.position,
        onDrag: (final DragUpdateDetails details) {
          // Drag point on bored
          setState(() {
            if (dragPoint == null) {
              Offset basePoint = widget.pathProps.points[index].position;
              dragPoint = Offset(basePoint.dx + details.delta.dx, basePoint.dy + details.delta.dy);
            } else {
              dragPoint = Offset(dragPoint!.dx + details.delta.dx, dragPoint!.dy + details.delta.dy);
            }
          });
        },
        onDragEnd: (_) {
          // Finish to drag point on bored
          widget.pathProps.finishDrag(index, dragPoint!);
          setState(() {
            dragPoint = null;
          });
        },
        onTap: () {
          // Edit point black lines
          if (ctrlPressed)
            // _bloc.add(LineSectionEvent(waypointIndex: index));
            print("TODO");
          else
            setState(
              () => selectedPointIndex =
                  selectedPointIndex != index ? index : null,
            );
        },
        controlPoint: false,
      );
  }

  @override
  Widget build(final BuildContext context) {
    // TODO maintain focus when pressing on points
    Point? selectedPoint;
    if (selectedPointIndex != null) {
      selectedPoint = widget.pathProps.points[selectedPointIndex!];
    }

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

        if (pressedKeys.contains(LogicalKeyboardKey.backspace) && selectedPointIndex != null) {
          widget.pathProps.deletePoint(selectedPointIndex!);
          selectedPointIndex = null;
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
              for (int i = 0; i < widget.pathProps.points.length; i++)
                // Draw dot circle
                pointWidget(
                  point: widget.pathProps.points[i],
                  index: i,
                ),
              for (final waypoint in widget.pathProps.points)
                // Draw red line
                CustomPaint(
                  painter: HeadingLinePainter(
                    heading: waypoint.heading,
                    position: waypoint.position,
                  ),
                ),

            // Draw inControlPoint black line for selected point
            if (selectedPointIndex != null)
              CustomPaint(
                painter: DashedLinePainter(
                  start: selectedPoint!.position,
                  end: Offset(
                    selectedPoint.position.dx + selectedPoint.inControlPoint.dx,
                    selectedPoint.position.dy + selectedPoint.inControlPoint.dy
                  ),
                ),
              ),
            // Draw OutControlPoint black line for selected point
            if (selectedPointIndex != null)
              CustomPaint(
                painter: DashedLinePainter(
                  start: selectedPoint!.position,
                  end: Offset(
                    selectedPoint.position.dx + selectedPoint.outControlPoint.dx,
                    selectedPoint.position.dy + selectedPoint.outControlPoint.dy
                  ),
                ),
              ),
            ],

            for (final evaluatedPoint in widget.pathProps.evaulatedPoints ?? [])
              SplinePoint(point: evaluatedPoint)
          ],
        ),
      ),
    );
  }
}
