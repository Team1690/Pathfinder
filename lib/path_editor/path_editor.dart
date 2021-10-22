import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pathfinder/path_editor/dashed_line_painter.dart';
import 'package:pathfinder/path_editor/cubic_bezier_painter.dart';
import 'package:pathfinder/path_editor/path_point.dart';
import 'package:pathfinder/path_editor/cubic_bezier.dart';
import 'package:pathfinder/path_editor_bloc/path_editor_bloc.dart';
import 'package:pathfinder/path_editor_bloc/path_editor_event.dart';
import 'package:pathfinder/path_editor_bloc/path_editor_state.dart';

class PathEditor extends StatefulWidget {
  PathEditor({Key? key}) : super(key: key);

  @override
  _PathEditorState createState() => _PathEditorState();
}

class _PathEditorState extends State<PathEditor> {
  Offset mousePosition = Offset.zero;

  PathEditorBloc _bloc = PathEditorBloc();

  @override
  Widget build(final BuildContext context) {
    return BlocBuilder(
      bloc: _bloc,
      builder: (final BuildContext buildContext, final PathEditorState state) =>
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
                  width: 1100,
                  height: 1100 / 15.98 * 8.21,
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

                      _bloc.add(PointDrag(
                        pointIndex: state.points.indexOf(point),
                        newPosition: mousePosition,
                      ));
                    },
                  ),
              if (state is PathDefined)
                for (final cubicBezier in state.bezierSections)
                  CustomPaint(
                    painter: CubicBezierPainter(cubicBezier: cubicBezier),
                  ),
              Row(
                children: [
                  FloatingActionButton(
                    onPressed: () => _bloc.add(Undo()),
                    child: Text("Undo"),
                  ),
                  FloatingActionButton(
                    onPressed: () => _bloc.add(Redo()),
                    child: Text("Redo"),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
