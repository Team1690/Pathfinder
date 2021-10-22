import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pathfinder/path_editor/cubic_bezier.dart';
import 'package:pathfinder/path_editor_bloc/path_editor_event.dart';
import 'package:pathfinder/path_editor_bloc/path_editor_state.dart';
import 'package:stack/stack.dart';

class PathEditorBloc extends Bloc<PathEditorEvent, PathEditorState> {
  static PathEditorState get initialState => InitialState();

  final stateStack = Stack<PathEditorState>();

  PathEditorBloc() : super(initialState) {
    on<AddPointEvent>(_onAddPoint);
    on<PointDragStart>(_onPointDragStart);
    on<PointDrag>(_onPointDrag);
  }

  void _onPointDragStart(
    final PointDragStart event,
    final Emitter<PathEditorState> emit,
  ) {
    final currentState = this.state;
    stateStack.push(currentState);
  }

  void _onPointDrag(
    final PointDrag event,
    final Emitter<PathEditorState> emit,
  ) {
    if (event.pointIndex < 0) return; // error safety

    final currentState = this.state;

    if (currentState is InitialState) return;

    if (currentState is OnePointDefined)
      emit(OnePointDefined(event.newPosition));

    if (currentState is PathDefined) {
      final nextStatePoints = [...currentState.points];
      nextStatePoints[event.pointIndex] = event.newPosition;

      emit(PathDefined(nextStatePoints));
    }
  }

  void _onAddPoint(
    final AddPointEvent event,
    final Emitter<PathEditorState> emit,
  ) {
    final currentState = this.state;

    stateStack.push(currentState);

    if (currentState is InitialState) {
      emit(OnePointDefined(event.newPoint));
    } else if (currentState is OnePointDefined || currentState is PathDefined) {
      emit(
        PathDefined(
          [
            ...currentState.points.take(currentState.points.length - 1),
            ...CubicBezier.line(
                    start: currentState.points.last, end: event.newPoint)
                .pointsList
          ],
        ),
      );
    }
  }
}
