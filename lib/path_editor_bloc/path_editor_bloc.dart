import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pathfinder/cubic_bezier/cubic_bezier.dart';
import 'package:pathfinder/path_editor_bloc/path_editor_event.dart';
import 'package:pathfinder/path_editor_bloc/path_editor_state.dart';
import 'package:stack/stack.dart' as stack;

class PathEditorBloc extends Bloc<PathEditorEvent, PathEditorState> {
  static PathEditorState get initialState => InitialState();

  final stateStack = stack.Stack<PathEditorState>(); // states for undo
  var revertedStatesStack = stack.Stack<PathEditorState>(); // states for redo

  PathEditorBloc() : super(initialState) {
    on<AddPointEvent>(_onAddPoint);
    on<PointDragEnd>(_addStateToStack);
    on<PointDrag>(_onPointDrag);
    on<ControlPointTangentialDrag>(_onControlPointTangentialDrag);
    on<Undo>(_onUndo);
    on<Redo>(_onRedo);
    on<ClearAllPoints>(_onClearAllPoints);

    _addStateToStack();
  }

  // Arguments are for event, and emit
  void _addStateToStack([_, __]) => stateStack.push(this.state);

  void _onClearAllPoints(
      final ClearAllPoints event, final Emitter<PathEditorState> emit) {
    emit(InitialState());
  }

  void _onUndo(
    final Undo event,
    final Emitter<PathEditorState> emit,
  ) {
    if (this.stateStack.length > 1) {
      final poppedState = stateStack.pop();
      emit(stateStack.top());
      revertedStatesStack.push(poppedState);
    }
  }

  void _onRedo(
    final Redo event,
    final Emitter<PathEditorState> emit,
  ) {
    if (revertedStatesStack.isNotEmpty) emit(revertedStatesStack.pop());
  }

  @override
  void onTransition(
      final Transition<PathEditorEvent, PathEditorState> transition) {
    super.onTransition(transition);

    if (transition.event is! Undo &&
        transition.event is! PointDrag &&
        transition.event is! ControlPointTangentialDrag)
      stateStack.push(transition.nextState);

    if (transition.event is! Undo && transition.event is! Redo)
      revertedStatesStack = new stack.Stack<PathEditorState>();
  }

  void _onPointDrag(
    final PointDrag event,
    final Emitter<PathEditorState> emit,
  ) {
    if (event.pointIndex < 0) return; // error safety

    final currentState = this.state;

    if (currentState is InitialState) return;

    final Offset pointsPosition = currentState.points[event.pointIndex];

    if (currentState is OnePointDefined)
      emit(OnePointDefined(pointsPosition + event.mouseDelta));

    if (currentState is PathDefined) {
      final nextStatePoints = [...currentState.points];
      nextStatePoints[event.pointIndex] = pointsPosition + event.mouseDelta;

      final bool isPathPoint = event.pointIndex % 3 == 0;

      if (isPathPoint) {
        if (event.pointIndex != 0)
          nextStatePoints[event.pointIndex - 1] += event.mouseDelta;

        if (event.pointIndex != nextStatePoints.length - 1)
          nextStatePoints[event.pointIndex + 1] += event.mouseDelta;
      }

      emit(PathDefined(nextStatePoints));
    }
  }

  void _onControlPointTangentialDrag(final ControlPointTangentialDrag event,
      final Emitter<PathEditorState> emit) {
    final currentState = state;
    if (currentState is! PathDefined)
      return; // TODO check for removal when adding more states

    final bool controlPointIsAfterPathPoint = event.pointIndex % 3 == 1;

    final int indexOfPathPoint = controlPointIsAfterPathPoint
        ? event.pointIndex - 1
        : event.pointIndex + 1;

    final int indexOfOtherControlPoint = controlPointIsAfterPathPoint
        ? event.pointIndex - 2
        : event.pointIndex + 2;

    final nextStatePoints = [...currentState.points];
    nextStatePoints[event.pointIndex] += event.mouseDelta;
    final Offset pathPointToDraggedControlPoint =
        nextStatePoints[event.pointIndex] - nextStatePoints[indexOfPathPoint];
    nextStatePoints[indexOfOtherControlPoint] =
        nextStatePoints[indexOfPathPoint] - pathPointToDraggedControlPoint;

    emit(PathDefined(nextStatePoints));
  }

  void _onAddPoint(
    final AddPointEvent event,
    final Emitter<PathEditorState> emit,
  ) {
    final currentState = this.state;

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
