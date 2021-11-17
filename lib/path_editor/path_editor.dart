import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pathfinder/path_editor/dashed_line_painter.dart';
import 'package:pathfinder/path_editor/heading_line_painter.dart';
import 'package:pathfinder/path_editor/path_point.dart';
import 'package:pathfinder/path_editor/waypoint.dart';
import 'package:pathfinder/path_editor_bloc/path_editor_bloc.dart';
import 'package:pathfinder/path_editor_bloc/path_editor_event.dart';
import 'package:pathfinder/path_editor_bloc/path_editor_state.dart';

import 'package:pathfinder/cubic_bezier/cubic_bezier_painter.dart';

class PathEditor extends StatefulWidget {
  PathEditor({Key? key}) : super(key: key);

  @override
  _PathEditorState createState() => _PathEditorState();
}

class _PathEditorState extends State<PathEditor> {
  Set<LogicalKeyboardKey> pressedKeys = {};
  bool shiftPressed = false;
  bool ctrlPressed = false;
  int? selectedPointIndex;

  final PathEditorBloc _bloc = PathEditorBloc();

  // renders waypoint and its corresponding control points
  List<Widget> points({
    required final Waypoint waypoint,
    required final int index,
    required final int numberOfWaypoints,
  }) =>
      [
        PathPoint(
          point: waypoint.position,
          onDrag: (final DragUpdateDetails details) {
            _bloc.add(
                WaypointDrag(pointIndex: index, mouseDelta: details.delta));
          },
          onDragEnd: (_) => _bloc.add(PointDragEnd()),
          onTap: () {
            if (ctrlPressed && index >= 1)
              _bloc.add(LineSectionEvent(waypointIndex: index));
            else
              setState(
                () => selectedPointIndex =
                    selectedPointIndex != index ? index : null,
              );
          },
          controlPoint: false,
        ),
        if (selectedPointIndex == index) ...[
          if (index > 0) ...[
            PathPoint(
              point: waypoint.inControlPoint,
              onDrag: (final DragUpdateDetails details) {
                if (shiftPressed) {
                  _bloc.add(ControlPointTangentialDrag(
                    waypointIndex: index,
                    pointType: ControlPointType.In,
                    mouseDelta: details.delta,
                  ));
                } else {
                  _bloc.add(ControlPointDrag(
                    waypointIndex: index,
                    pointType: ControlPointType.In,
                    mouseDelta: details.delta,
                  ));
                }
              },
              onDragEnd: (_) => _bloc.add(PointDragEnd()),
              controlPoint: true,
              onTap: () {},
            ),
            CustomPaint(
              painter: DashedLinePainter(
                start: waypoint.position,
                end: waypoint.inControlPoint,
              ),
            ),
          ],
          if (index < numberOfWaypoints - 1) ...[
            PathPoint(
              point: waypoint.outControlPoint,
              onDrag: (final DragUpdateDetails details) {
                if (shiftPressed) {
                  _bloc.add(ControlPointTangentialDrag(
                      waypointIndex: index,
                      pointType: ControlPointType.Out,
                      mouseDelta: details.delta));
                } else {
                  _bloc.add(ControlPointDrag(
                    waypointIndex: index,
                    pointType: ControlPointType.Out,
                    mouseDelta: details.delta,
                  ));
                }
              },
              onDragEnd: (_) => _bloc.add(PointDragEnd()),
              controlPoint: true,
              onTap: () {},
            ),
            CustomPaint(
              painter: DashedLinePainter(
                start: waypoint.position,
                end: waypoint.outControlPoint,
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

        if (ctrlPressed) {
          if (pressedKeys.contains(LogicalKeyboardKey.keyZ))
            _bloc.add(Undo());
          else if (pressedKeys.contains(LogicalKeyboardKey.keyY))
            _bloc.add(Redo());

          if (pressedKeys.contains(LogicalKeyboardKey.backspace)) {
            _bloc.add(ClearAllPoints());
            selectedPointIndex = null;
          }
        }
      },
      child: BlocBuilder(
        bloc: _bloc,
        builder:
            (final BuildContext buildContext, final PathEditorState state) =>
                Center(
          child: Stack(
            children: [
              GestureDetector(
                child: const Image(
                  image: const AssetImage('assets/images/frc_2020_field.png'),
                ),
                onTapDown: (final TapDownDetails detailes) {
                  final Offset tapPos = detailes.localPosition;

                  _bloc.add(AddPointEvent(tapPos));
                },
                onPanStart: (_) {},
              ),
              if (state is OnePointDefined)
                PathPoint(
                  point: state.point,
                  onDrag: (final DragUpdateDetails details) {
                    _bloc.add(
                        WaypointDrag(pointIndex: 0, mouseDelta: details.delta));
                  },
                  onDragEnd: (_) => _bloc.add(PointDragEnd()),
                  controlPoint: false,
                  onTap: () {},
                ),
              if (state is PathDefined) ...[
                for (int i = 0; i < state.waypoints.length; i++)
                  ...points(
                    waypoint: state.waypoints[i],
                    index: i,
                    numberOfWaypoints: state.waypoints.length,
                  ),
                for (final cubicBezier in state.bezierSections)
                  CustomPaint(
                    painter: CubicBezierPainter(cubicBezier: cubicBezier),
                  ),
                for (final waypoint in state.waypoints)
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
      ),
    );
  }
}
