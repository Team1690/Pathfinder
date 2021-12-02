import 'package:redux/redux.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:pathfinder/models/point.dart';
import 'package:pathfinder/models/segment.dart';
import 'package:pathfinder/store/app/app_state.dart';
import 'package:pathfinder/store/tab/store.dart';
import 'package:pathfinder/widgets/path_editor/dashed_line_painter.dart';
import 'package:pathfinder/widgets/path_editor/heading_line_painter.dart';
import 'package:pathfinder/widgets/path_editor/path_point.dart';

class PathViewModel {
  final List<Point> points;
  final List<Segment> segments;
  final Function(Offset) addPoint;

  PathViewModel({
    required this.points,
    required this.segments,
    required this.addPoint,
  });

  static PathViewModel fromStore(Store<AppState> store) {
    return PathViewModel(
        points: store.state.tabState.path.points,
        segments: store.state.tabState.path.segments,
        addPoint: (Offset position) {
          store.dispatch(AddPointToPath(position: position));
        });
  }
}

StoreConnector<AppState, PathViewModel> pathEditor() {
  return new StoreConnector<AppState, PathViewModel>(
      converter: (store) => PathViewModel.fromStore(store),
      builder: (_, pathProps) => _PathEditor(pathProps: pathProps)
      // onDidChange: () => null,
      );
}

class _PathEditor extends StatefulWidget {
  final PathViewModel pathProps;
  // Key? key;

  _PathEditor({
    required this.pathProps,
  });
  //   key
  // }) : super(key: key);

  @override
  _PathEditorState createState() => _PathEditorState();
}

class _PathEditorState extends State<_PathEditor> {
  Set<LogicalKeyboardKey> pressedKeys = {};
  bool shiftPressed = false;
  bool ctrlPressed = false;
  int? selectedPointIndex;
  // final PathViewModel props;

  _PathEditorState();

  // final PathEditorBloc _bloc = PathEditorBloc();

  // renders waypoint and its corresponding control points
  List<Widget> points({
    required final Point point,
    required final int index,
    required final int numberOfWaypoints,
  }) =>
      [
        PathPoint(
          point: point.position,
          onDrag: (final DragUpdateDetails details) {
            // Drag point on bored
            // if (shiftPressed)
            // _bloc.add(
            //   WaypointHeadingDrag(
            //     pointIndex: index,
            //     mousePositionRelativeToPoint: details.localPosition,
            //   ),
            // );
            // else
            // _bloc.add(
            //   WaypointDrag(pointIndex: index, mouseDelta: details.delta),
            // );
          },
          onDragEnd: (_) => {
            // Finish to drag point on bored
            // _bloc.add(PointDragEnd())
          },
          onTap: () {
            // Edit point black lines
            // if (ctrlPressed && index >= 1)
            //   _bloc.add(LineSectionEvent(waypointIndex: index));
            // else
            //   setState(
            //     () => selectedPointIndex =
            //         selectedPointIndex != index ? index : null,
            //   );
          },
          controlPoint: false,
        ),
        if (selectedPointIndex == index) ...[
          if (index > 0) ...[
            PathPoint(
              point: point.inControlPoint,
              onDrag: (final DragUpdateDetails details) {
                if (shiftPressed) {
                  // _bloc.add(ControlPointTangentialDrag(
                  //   waypointIndex: index,
                  //   pointType: ControlPointType.In,
                  //   mouseDelta: details.delta,
                  // ));
                } else {
                  // _bloc.add(ControlPointDrag(
                  //   waypointIndex: index,
                  //   pointType: ControlPointType.In,
                  //   mouseDelta: details.delta,
                  // ));
                }
              },
              // onDragEnd: (_) => _bloc.add(PointDragEnd()),
              onDragEnd: (_) => Null,
              controlPoint: true,
              onTap: () {},
            ),
            CustomPaint(
              painter: DashedLinePainter(
                start: point.position,
                end: point.inControlPoint,
              ),
            ),
          ],
          if (index < numberOfWaypoints - 1) ...[
            PathPoint(
              point: point.outControlPoint,
              onDrag: (final DragUpdateDetails details) {
                if (shiftPressed) {
                  // _bloc.add(ControlPointTangentialDrag(
                  //     waypointIndex: index,
                  //     pointType: ControlPointType.Out,
                  //     mouseDelta: details.delta));
                } else {
                  // _bloc.add(ControlPointDrag(
                  //   waypointIndex: index,
                  //   pointType: ControlPointType.Out,
                  //   mouseDelta: details.delta,
                  // ));
                }
              },
              // onDragEnd: (_) => _bloc.add(PointDragEnd()),
              onDragEnd: (_) => Null,
              controlPoint: true,
              onTap: () {},
            ),
            CustomPaint(
              painter: DashedLinePainter(
                start: point.position,
                end: point.outControlPoint,
              ),
            ),
          ],
        ],
      ];

  @override
  Widget build(final BuildContext context) {
    // TODO maintain focus when pressing on points
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

        // if (pressedKeys.contains(LogicalKeyboardKey.backspace) &&
        //     selectedPointIndex != null) {
        //   _bloc.add(DeletePoint(selectedPointIndex!));
        //   selectedPointIndex = null;
        // }
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
                // _bloc.add(AddPointEvent(tapPos));
              },
              onPanStart: (_) {},
            ),
            // if (state is OnePointDefined)
            //   PathPoint(
            //     point: state.point,
            //     onDrag: (final DragUpdateDetails details) {
            //       _bloc.add(
            //           WaypointDrag(pointIndex: 0, mouseDelta: details.delta));
            //     },
            //     onDragEnd: (_) => _bloc.add(PointDragEnd()),
            //     controlPoint: false,
            //     onTap: () {},
            //   ),
            // if (state is PathDefined) ...[
            ...[
              for (int i = 0; i < widget.pathProps.points.length; i++)
                ...points(
                  point: widget.pathProps.points[i],
                  index: i,
                  numberOfWaypoints: widget.pathProps.points.length,
                ),
              // for (final segment in path.segments)
              //   CustomPaint(
              //     painter: CubicBezierPainter(cubicBezier: cubicBezier),
              //   ),
              for (final waypoint in widget.pathProps.points)
                CustomPaint(
                  painter: HeadingLinePainter(
                    heading: waypoint.heading,
                    position: waypoint.position,
                  ),
                ),
            ],
          ],
        ),
      ),
    );
  }
}
