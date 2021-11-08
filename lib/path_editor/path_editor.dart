import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pathfinder/path_editor/dashed_line_painter.dart';
import 'package:pathfinder/path_editor/path_point.dart';
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
                if (state is PathDefined || state is OnePointDefined)
                  for (final Offset point in state.points)
                    PathPoint(
                      point: point,
                      controlPoint: state.points.indexOf(point) % 3 != 0,
                      onDragEnd: (_) => _bloc.add(PointDragEnd()),
                      onDrag: (final DragUpdateDetails details) {
                        setState(() {
                          mousePosition += details.delta;
                        });

                        final int pointIndex = state.points.indexOf(point);
                        final bool pointIsNotfirstOrLastControl =
                            pointIndex != 1 &&
                                pointIndex != state.points.length - 2;

                        if (pressedKeys
                                .contains(LogicalKeyboardKey.shiftLeft) &&
                            pointIndex % 3 != 0 &&
                            pointIsNotfirstOrLastControl)
                          _bloc.add(ControlPointTangentialDrag(
                            pointIndex: pointIndex,
                            mouseDelta: details.delta,
                          ));
                        else
                          _bloc.add(
                            PointDrag(
                              pointIndex: state.points.indexOf(point),
                              mouseDelta: details.delta,
                            ),
                          );
                      },
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
