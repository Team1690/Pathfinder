import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pathfinder/path_editor/dashed_line_painter.dart';
import 'package:pathfinder/path_editor/path_point.dart';
import 'package:pathfinder/path_editor/waypoint.dart';
import 'package:pathfinder/path_editor_bloc/path_editor_bloc.dart';
import 'package:pathfinder/path_editor_bloc/path_editor_event.dart';
import 'package:pathfinder/path_editor_bloc/path_editor_state.dart';

import 'package:pathfinder/cubic_bezier/cubic_bezier.dart';
import 'package:pathfinder/cubic_bezier/cubic_bezier_painter.dart';

class PathEditor extends StatefulWidget {
  PathEditor({Key? key}) : super(key: key);

  @override
  _PathEditorState createState() => _PathEditorState();
}

class _PathEditorState extends State<PathEditor> {
  Offset mousePosition = Offset.zero;
  Set<LogicalKeyboardKey> pressedKeys = {};

  final PathEditorBloc _bloc = PathEditorBloc();

  // renders waypoint and its corresponding control points
  List<Widget> points({
    required final Waypoint waypoint,
    required final int index,
    required final int numberOfWaypoints,
    required final bool isShiftPressed,
  }) =>
      [
        PathPoint(
          point: waypoint.position,
          onDrag: (final DragUpdateDetails details) {
            setState(() {
              mousePosition += details.delta;
            });

            _bloc.add(
                WaypointDrag(pointIndex: index, mouseDelta: details.delta));
          },
          onDragEnd: (_) => _bloc.add(PointDragEnd()),
          controlPoint: false,
        ),
        if (index > 0)
          PathPoint(
            point: waypoint.inControlPoint,
            onDrag: (final DragUpdateDetails details) {
              setState(() {
                mousePosition += details.delta;
              });

              if (isShiftPressed) {
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
          ),
        if (index < numberOfWaypoints - 1)
          PathPoint(
            point: waypoint.outControlPoint,
            onDrag: (final DragUpdateDetails details) {
              setState(() {
                mousePosition += details.delta;
              });
              if (isShiftPressed) {
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
          ),
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
        });

        if (pressedKeys.contains(LogicalKeyboardKey.metaLeft) ||
            pressedKeys.contains(LogicalKeyboardKey.controlLeft)) {
          if (pressedKeys.contains(LogicalKeyboardKey.keyZ))
            _bloc.add(Undo());
          else if (pressedKeys.contains(LogicalKeyboardKey.keyY))
            _bloc.add(Redo());

          if (pressedKeys.contains(LogicalKeyboardKey.backspace)) {
            _bloc.add(ClearAllPoints());
          }
        }
      },
      child: BlocBuilder(
        bloc: _bloc,
        builder:
            (final BuildContext buildContext, final PathEditorState state) =>
                Center(
          child: MouseRegion(
            onHover: (event) {
              setState(() => mousePosition = event.localPosition);
            },
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
                  onPanUpdate: (final DragUpdateDetails details) =>
                      setState(() => mousePosition = details.localPosition),
                ),
                if (state is PathDefined)
                  for (final CubicBezier bezierSection
                      in state.bezierSections) ...[
                    CustomPaint(
                      painter: DashedLinePainter(
                          start: bezierSection.start,
                          end: bezierSection.startControl),
                    ),
                    CustomPaint(
                      painter: DashedLinePainter(
                        start: bezierSection.endControl,
                        end: bezierSection.end,
                      ),
                    )
                  ],
                if (state is OnePointDefined)
                  PathPoint(
                    point: state.point,
                    onDrag: (final DragUpdateDetails details) {
                      setState(() {
                        mousePosition += details.delta;
                      });

                      _bloc.add(WaypointDrag(
                          pointIndex: 0, mouseDelta: details.delta));
                    },
                    onDragEnd: (_) => _bloc.add(PointDragEnd()),
                    controlPoint: false,
                  ),
                if (state is PathDefined)
                  for (int i = 0; i < state.waypoints.length; i++)
                    ...points(
                      waypoint: state.waypoints[i],
                      index: i,
                      numberOfWaypoints: state.waypoints.length,
                      isShiftPressed:
                          pressedKeys.contains(LogicalKeyboardKey.shiftLeft),
                    ),
                if (state is PathDefined)
                  for (final cubicBezier in state.bezierSections)
                    CustomPaint(
                      painter: CubicBezierPainter(cubicBezier: cubicBezier),
                    ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
