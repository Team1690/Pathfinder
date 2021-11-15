import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pathfinder/cubic_bezier/cubic_bezier.dart';
import 'package:pathfinder/path_editor/waypoint.dart';
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
    on<WaypointDrag>(_onWaypointDrag);
    on<ControlPointDrag>(_onControlPointDrag);
    on<ControlPointTangentialDrag>(_onControlPointTangentialDrag);
    on<LineSectionEvent>(_onLineSection);
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
        !(transition.event is WaypointDrag ||
            transition.event is ControlPointDrag) &&
        transition.event is! ControlPointTangentialDrag)
      stateStack.push(transition.nextState);

    if (transition.event is! Undo && transition.event is! Redo)
      revertedStatesStack = new stack.Stack<PathEditorState>();
  }

  void _onWaypointDrag(
    final WaypointDrag event,
    final Emitter<PathEditorState> emit,
  ) {
    final currentState = state;

    if (event.pointIndex < 0 || currentState is InitialState)
      return; // error safety

    if (currentState is OnePointDefined) {
      emit(OnePointDefined(currentState.point + event.mouseDelta));
    } else if (currentState is PathDefined) {
      final List<Waypoint> newWaypoints = [...currentState.waypoints];
      newWaypoints[event.pointIndex] = Waypoint(
        position: newWaypoints[event.pointIndex].position + event.mouseDelta,
        magIn: newWaypoints[event.pointIndex].magIn,
        magOut: newWaypoints[event.pointIndex].magOut,
        dirIn: newWaypoints[event.pointIndex].dirIn,
        dirOut: newWaypoints[event.pointIndex].dirOut,
        heading: newWaypoints[event.pointIndex].heading,
      );
      emit(PathDefined(newWaypoints));
    }
  }

  void _onControlPointDrag(
    final ControlPointDrag event,
    final Emitter<PathEditorState> emit,
  ) {
    final currentState = state;

    if (event.waypointIndex < 0 ||
        currentState is InitialState ||
        currentState is OnePointDefined) return; // error safety

    if (currentState is PathDefined) {
      final newWaypoints = [...currentState.waypoints];
      var modifiedWaypoint = newWaypoints[event.waypointIndex];

      switch (event.pointType) {
        case ControlPointType.In:
          modifiedWaypoint = Waypoint.fromControlPoints(
            position: modifiedWaypoint.position,
            inControlPoint: modifiedWaypoint.inControlPoint + event.mouseDelta,
            outControlPoint: modifiedWaypoint.outControlPoint,
            heading: modifiedWaypoint.heading,
          );
          break;
        case ControlPointType.Out:
          modifiedWaypoint = Waypoint.fromControlPoints(
            position: modifiedWaypoint.position,
            inControlPoint: modifiedWaypoint.inControlPoint,
            outControlPoint:
                modifiedWaypoint.outControlPoint + event.mouseDelta,
            heading: modifiedWaypoint.heading,
          );
          break;
      }

      newWaypoints[event.waypointIndex] = modifiedWaypoint;

      emit(PathDefined(newWaypoints));
    }
  }

  void _onLineSection(
    final LineSectionEvent event,
    final Emitter<PathEditorState> emit,
  ) {
    final currentState = state;

    if (currentState is! PathDefined) return;

    final selectedWaypoint = currentState.waypoints[event.waypointIndex];
    final previousWaypoint = currentState.waypoints[event.waypointIndex - 1];

    final newWaypoints = [...currentState.waypoints];

    final lineBezierSection = CubicBezier.line(
      start: previousWaypoint.position,
      end: selectedWaypoint.position,
    );

    newWaypoints[event.waypointIndex] = Waypoint.fromControlPoints(
      position: selectedWaypoint.position,
      inControlPoint: lineBezierSection.endControl,
      outControlPoint: selectedWaypoint.outControlPoint,
      heading: selectedWaypoint.heading,
    );

    newWaypoints[event.waypointIndex - 1] = Waypoint.fromControlPoints(
      position: previousWaypoint.position,
      inControlPoint: previousWaypoint.inControlPoint,
      outControlPoint: lineBezierSection.startControl,
      heading: previousWaypoint.heading,
    );

    emit(PathDefined(newWaypoints));
  }

  void _onControlPointTangentialDrag(
    final ControlPointTangentialDrag event,
    final Emitter<PathEditorState> emit,
  ) {
    final currentState = state;
    if (currentState is! PathDefined)
      return; // TODO check for removal when adding more states

    final newWaypoints = [...currentState.waypoints];
    var modifiedWaypoint = newWaypoints[event.waypointIndex];

    final draggedControlPoint = (event.pointType == ControlPointType.In
            ? modifiedWaypoint.inControlPoint
            : modifiedWaypoint.outControlPoint) +
        event.mouseDelta;

    final notDraggedControlPoint =
        (modifiedWaypoint.position * 2) - draggedControlPoint;

    modifiedWaypoint = Waypoint.fromControlPoints(
      position: modifiedWaypoint.position,
      inControlPoint: event.pointType == ControlPointType.In
          ? draggedControlPoint
          : notDraggedControlPoint,
      outControlPoint: event.pointType == ControlPointType.Out
          ? draggedControlPoint
          : notDraggedControlPoint,
      heading: modifiedWaypoint.heading,
    );

    newWaypoints[event.waypointIndex] = modifiedWaypoint;

    emit(PathDefined(newWaypoints));
  }

  void _onAddPoint(
    final AddPointEvent event,
    final Emitter<PathEditorState> emit,
  ) {
    final currentState = this.state;

    // TODO refactor code

    if (currentState is InitialState) {
      emit(OnePointDefined(event.newPoint));
    } else if (currentState is OnePointDefined) {
      final bezierSection =
          CubicBezier.line(start: currentState.point, end: event.newPoint);
      emit(PathDefined([
        Waypoint.fromControlPoints(
          position: bezierSection.start,
          inControlPoint: Offset.zero, // first point has no in control point
          outControlPoint: bezierSection.startControl,
          heading: 0,
        ),
        Waypoint.fromControlPoints(
          position: bezierSection.end,
          inControlPoint: bezierSection.endControl,
          outControlPoint: Offset.zero, // last point has no out control point
          heading: 0,
        ),
      ]));
    } else if (currentState is PathDefined) {
      final newBezierSection = CubicBezier.line(
          start: currentState.waypoints.last.position, end: event.newPoint);
      emit(
        PathDefined(
          [
            ...currentState.waypoints.take(currentState.waypoints.length - 1),
            Waypoint.fromControlPoints(
              position: currentState.waypoints.last.position,
              inControlPoint: currentState.waypoints.last.inControlPoint,
              outControlPoint: newBezierSection.startControl,
              heading: currentState.waypoints.last.heading,
            ),
            Waypoint.fromControlPoints(
              position: newBezierSection.end,
              inControlPoint: newBezierSection.endControl,
              outControlPoint:
                  Offset.zero, // last point has no out control point
              heading: 0,
            ),
          ],
        ),
      );
    }
  }
}
