import "dart:math";
import "package:flutter/material.dart";
import "package:orbit_standard_library/orbit_standard_library.dart";
import "package:pathfinder/models/field.dart";
import "package:pathfinder/models/history.dart";
import "package:pathfinder/models/point.dart";
import "package:pathfinder/models/robot_on_field.dart";
import "package:pathfinder/models/segment.dart";
import "package:pathfinder/rpc/protos/PathFinder.pb.dart" hide Point, Segment;
import "package:pathfinder/services/pathfinder.dart";
import "package:pathfinder/store/app/app_actions.dart";
import "package:pathfinder/store/tab/store.dart";
import "package:redux/redux.dart";
import "package:pathfinder/models/spline_point.dart";

Reducer<TabState> applyReducers =
    combineReducers<TabState>(<TabState Function(TabState, dynamic)>[
  TypedReducer<TabState, SetSideBarVisibility>(_setSidebarVisibility),
  TypedReducer<TabState, ObjectSelected>(_objectSelected),
  TypedReducer<TabState, ObjectUnselected>(_objectUnselected),
  TypedReducer<TabState, AddPointToPath>(_addPointToPath),
  TypedReducer<TabState, DeletePointFromPath>(_deletePointFromPath),
  TypedReducer<TabState, SplineCalculated>(_splineCalculated),
  TypedReducer<TabState, ServerError>(_setServerError),
  TypedReducer<TabState, EditPoint>(editPoint),
  TypedReducer<TabState, SetFieldSizePixels>(_setFieldSizePixels),
  TypedReducer<TabState, EditSegment>(_editSegment),
  TypedReducer<TabState, EditRobot>(editRobot),
  TypedReducer<TabState, ToggleHeading>(_toggleHeading),
  TypedReducer<TabState, ToggleControl>(_toggleControl),
  TypedReducer<TabState, TrajectoryCalculated>(_trajectoryCalculated),
  TypedReducer<TabState, TrajectoryInProgress>(_trajectoryInProgress),
  TypedReducer<TabState, TrajectoryFileNameChanged>(_trajectoryFileNameChanged),
  TypedReducer<TabState, PathUndo>(_pathUndo),
  TypedReducer<TabState, PathRedo>(_pathRedo),
  TypedReducer<TabState, SetZoomLevel>(_setZoomLevel),
  TypedReducer<TabState, SetPan>(_setPan),
  TypedReducer<TabState, SetRobotOnField>(_setRobotOnField),
]);

List<Type> historyAffectingActions = <Type>[
  AddPointToPath,
  DeletePointFromPath,
  EditPoint,
  EditSegment,
  EditRobot,
];

List<Type> unsavedChanegsActions = <Type>[
  ...historyAffectingActions,
  PathUndo,
  PathRedo,
  AddTab,
  RemoveTab,
];

Map<String, IconData> actionToIcon = <String, IconData>{
  "$AddPointToPath": Icons.add,
  "$DeletePointFromPath": Icons.remove,
  "$EditPoint": Icons.edit_location_outlined,
  "$EditSegment": Icons.edit_road,
  "$initialActionName": Icons.start,
};

TabState tabStateReducer(final TabState tabState, final dynamic action) {
  final TabState newTabState = applyReducers(tabState, action);

  // Add path to history only after the relevant actions
  if (historyAffectingActions.contains(action.runtimeType)) {
    final List<HistoryStamp> newPathHistory = <HistoryStamp>[
      ...newTabState.history.pathHistory
          .sublist(0, newTabState.history.currentStateIndex + 1),
      HistoryStamp.fromReducer(
        action as TabAction,
        newTabState.path.copyWith(
          // Remove the evaluated points from the saved path, it is calculated async
          // and isn't correct here (will be calculated anyway in the redo/undo thunk)
          evaluatedPoints: <SplinePoint>[],
        ),
      ),
    ];
    int newCurrentIndex = newTabState.history.currentStateIndex + 1;

    if (newPathHistory.length > maxSavedHistory) {
      newPathHistory.removeAt(0);
      newCurrentIndex--;
    }

    return newTabState.copyWith(
      history: newTabState.history.copyWith(
        pathHistory: newPathHistory,
        currentStateIndex: newCurrentIndex,
      ),
    );
  }

  return newTabState;
}

TabState _setSidebarVisibility(
  final TabState tabstate,
  final SetSideBarVisibility action,
) =>
    tabstate.copyWith(
      ui: tabstate.ui.copyWith(isSidebarOpen: action.visibility),
    );

TabState _objectSelected(
  final TabState tabState,
  final ObjectSelected action,
) =>
    tabState.copyWith(
      ui: tabState.ui.copyWith(
        isSidebarOpen: true,
        selectedIndex: action.index,
        selectedType: action.type,
      ),
    );

TabState _objectUnselected(
  final TabState tabState,
  final ObjectUnselected action,
) =>
    tabState.copyWith(
      ui: tabState.ui.copyWith(
        isSidebarOpen: false,
        selectedIndex: -1,
        selectedType: Null,
      ),
    );

TabState _setServerError(final TabState tabState, final ServerError action) =>
    tabState.copyWith(ui: tabState.ui.copyWith(serverError: action.error));

TabState _trajectoryInProgress(
  final TabState tabState,
  final TrajectoryInProgress action,
) =>
    tabState.copyWith(
      path: tabState.path.copyWith(
        autoDuration: -1,
      ),
    );

TabState _trajectoryCalculated(
  final TabState tabState,
  final TrajectoryCalculated action,
) {
  double autoDuartion = 0.0;
  double firstPointTime = action.points.first.time;

  action.points
      .asMap()
      .forEach((final int index, final TrajectoryResponse_SwervePoint p) {
    if (index == action.points.length - 1) {
      autoDuartion += firstPointTime;
      return;
    }

    // Use '>' to avoid floating point errors in equality check
    if (!(p.time > 0)) {
      autoDuartion += firstPointTime;
      firstPointTime = action.points[index + 1].time;
    }
  });

  return tabState.copyWith(
    ui: tabState.ui.copyWith(serverError: null),
    path: tabState.path.copyWith(
      autoDuration: autoDuartion,
      trajectoryPoints: action.points,
    ),
  );
}

TabState _splineCalculated(
  final TabState tabState,
  final SplineCalculated action,
) {
  final List<SplinePoint> evaluatedPoints = action.points
      .map(
        (final SplineResponse_Point p) => SplinePoint(
          position: fromRpcVector(p.point),
          segmentIndex: p.segmentIndex,
        ),
      )
      .toList();

  return tabState.copyWith(
    ui: tabState.ui.copyWith(serverError: null),
    path: tabState.path.copyWith(
      evaluatedPoints: evaluatedPoints,
      robotOnField: None<RobotOnField>(),
    ),
  );
}

TabState _addPointToPath(final TabState tabState, final AddPointToPath action) {
  // If the segment to add is -1, treat it as if the addition is to the end
  // of the point list and to the last segment
  final int insertIndex = action.insertIndex >= 0
      ? action.insertIndex
      : max(tabState.path.points.length, 0);
  final int segmentIndex = action.segmentIndex >= 0
      ? action.segmentIndex
      : max(tabState.path.segments.length - 1, 0);

  Offset? position = action.position;

  if (position == null) {
    // If position is null, calculate it by the previues position and current position
    final List<Point> points = tabState.path.points;
    position = (points[insertIndex - 1].position + points[insertIndex].position)
        .scale(0.5, 0.5);
  }

  Point newPoint = Point.initial(position);

  if (tabState.path.points.isNotEmpty) {
    final double direction = action.insertIndex == -1
        ? (tabState.path.points[tabState.path.points.length - 1].position -
                newPoint.position)
            .direction
        : (tabState.path.points[insertIndex - 1].position -
                tabState.path.points[insertIndex].position)
            .direction;
    final Offset inControlOffset =
        Offset.fromDirection(direction, defaultControlLength);
    final Offset outControlOFfset = Offset.fromDirection(
      inControlOffset.direction + pi,
      inControlOffset.distance,
    );

    newPoint = newPoint.copyWith(
      inControlPoint: inControlOffset,
      outControlPoint: outControlOFfset,
    );
  }

  final List<Point> newPoints = <Point>[...tabState.path.points];
  List<Segment> segments = tabState.path.segments;
  if (segments.isEmpty) {
    segments = <Segment>[...segments, Segment.initial()];
  }

  newPoints.insert(insertIndex, newPoint);

  final TabState newState = tabState.copyWith(
    path: tabState.path.copyWith(
      points: newPoints,
      segments: segments.asMap().entries.map((final MapEntry<int, Segment> e) {
        final List<int> pointIndexes = <int>[...e.value.pointIndexes];

        // Assuming the point indexes are sorted inside the segments we can
        // add another index to the list and increment all the following indexes
        if (e.key == segmentIndex) {
          final List<int> newPointIndexes = pointIndexes
            ..add(pointIndexes.isEmpty ? 0 : pointIndexes.last + 1);
          return e.value.copyWith(pointIndexes: newPointIndexes);
        }

        // Increment all following indexes
        if (e.key > segmentIndex) {
          return e.value.copyWith(
            pointIndexes: pointIndexes.map((final int val) => val + 1).toList(),
          );
        }

        return e.value;
      }).toList(),
    ),
  );

  return newState;
}

TabState editPoint(final TabState tabState, final EditPoint action) {
  bool addSegment = false;
  bool removeSegment = false;

  final TabState newState = tabState.copyWith(
    path: tabState.path.copyWith(
      points: tabState.path.points
          .asMap()
          .entries
          .map((final MapEntry<int, Point> e) {
        if (e.key != action.pointIndex) {
          return e.value;
        }

        // Dont allow to cut segments in the end or start of points list
        final bool cutSegmentAllowed = action.pointIndex != 0 &&
            action.pointIndex != tabState.path.points.length - 1;

        // Always set use heading true for the first point
        final bool useHeading =
            action.useHeading ?? e.value.useHeading || action.pointIndex == 0;

        // Get and validate cut & stop values
        bool cutSegment =
            (action.cutSegment ?? e.value.cutSegment) && cutSegmentAllowed;
        bool isStop = (action.isStop ?? e.value.isStop) && cutSegmentAllowed;

        // Cut or uncut the segment if stop or cut changes
        if (isStop && !e.value.isStop) cutSegment = true;
        if (!isStop && e.value.isStop) cutSegment = false;

        addSegment = (cutSegment) && !e.value.cutSegment;
        removeSegment = !(cutSegment) && e.value.cutSegment;

        if (e.value.isStop && removeSegment) isStop = false;

        return e.value.copyWith(
          position: action.position ?? e.value.position,
          inControlPoint: action.inControlPoint ?? e.value.inControlPoint,
          //outControlPoint: action.outControlPoint ?? e.value.outControlPoint,
          outControlPoint: action.outControlPoint != e.value.outControlPoint
              ? action.outControlPoint
              : (action.isStop != null && !action.isStop!)
                  ? Offset.fromDirection(
                      e.value.inControlPoint.direction + pi,
                      e.value.outControlPoint.distance,
                    )
                  : e.value.outControlPoint,
          heading: action.heading ?? e.value.heading,
          useHeading: useHeading,
          action: action.action ?? e.value.action,
          actionTime: action.actionTime ?? e.value.actionTime,
          cutSegment: cutSegment,
          isStop: isStop,
        );
      }).toList(),
    ),
  );

  if (addSegment) {
    final int currentSegmentIndex = tabState.path.segments.indexWhere(
      (final Segment s) => s.pointIndexes.contains(action.pointIndex),
    );

    final List<Segment> newSegments = <Segment>[...tabState.path.segments];
    newSegments.insert(
      currentSegmentIndex + 1,
      Segment.initial(
        pointIndexes: newSegments[currentSegmentIndex]
            .pointIndexes
            .where((final int index) => index >= action.pointIndex)
            .toList(),
      ),
    );

    return newState.copyWith(
      path: newState.path.copyWith(
        segments:
            newSegments.asMap().entries.map((final MapEntry<int, Segment> e) {
          if (e.key != currentSegmentIndex) return e.value;
          return e.value.copyWith(
            pointIndexes: e.value.pointIndexes
                .where((final int index) => index < action.pointIndex)
                .toList(),
          );
        }).toList(),
      ),
    );
  }

  if (removeSegment) {
    final int removedSegmentIndex = tabState.path.segments.indexWhere(
      (final Segment s) => s.pointIndexes.contains(action.pointIndex),
    );

    final List<Segment> newSegments = <Segment>[...tabState.path.segments];
    final List<int> removedPointIndxes =
        newSegments.removeAt(removedSegmentIndex).pointIndexes;

    return newState.copyWith(
      path: newState.path.copyWith(
        segments:
            newSegments.asMap().entries.map((final MapEntry<int, Segment> e) {
          if (e.key != removedSegmentIndex - 1) return e.value;
          return e.value.copyWith(
            pointIndexes: e.value.pointIndexes + removedPointIndxes,
          );
        }).toList(),
      ),
    );
  }

  return newState;
}

TabState _deletePointFromPath(
  final TabState tabState,
  final DeletePointFromPath action,
) {
  if (action.index == -1) return tabState;

  if (tabState.ui.selectedType != Point ||
      tabState.ui.selectedIndex != action.index) return tabState;

  TabState newState = tabState.copyWith();
  final List<Point> newPoints = <Point>[...tabState.path.points];

  // Clear the segment of the point if it its cutting a segment, add all the points to
  // the previous segment (including the removed one, it will be handled later)

  if (newPoints[action.index].cutSegment) {
    final List<Segment> newSegments = <Segment>[...newState.path.segments];

    final int removedSegmentIndex = tabState.path.segments
        .indexWhere((final Segment s) => s.pointIndexes.contains(action.index));

    // Get the points that where removed from the segment and add them to the previous
    // segment, the first point never starts a segment so there always should be at least one segment
    // in case of deleting a 'cutting segment' point like here
    final Segment removedSegment = newSegments[removedSegmentIndex];
    final Segment previousSegment = newSegments[removedSegmentIndex - 1];

    newSegments[removedSegmentIndex - 1] = previousSegment.copyWith(
      pointIndexes: previousSegment.pointIndexes + removedSegment.pointIndexes,
    );
    newSegments[removedSegmentIndex] =
        removedSegment.copyWith(pointIndexes: <int>[]);

    newState = newState.copyWith(
      path: newState.path.copyWith(
        segments: newSegments,
      ),
    );
  }

  if (action.index == newPoints.length - 1 &&
      newPoints[action.index - 1].cutSegment) {
    final List<Segment> newSegments = <Segment>[...newState.path.segments];

    final int invalidSegmentIndex = tabState.path.segments.indexWhere(
      (final Segment s) => s.pointIndexes.contains(action.index - 1),
    );

    newSegments[invalidSegmentIndex] =
        newSegments[invalidSegmentIndex].copyWith(pointIndexes: <int>[]);

    final Segment newLastSegment = newSegments[invalidSegmentIndex - 1];

    newSegments[invalidSegmentIndex - 1] = newLastSegment.copyWith(
      pointIndexes: <int>[...newLastSegment.pointIndexes, (action.index - 1)],
    );
    newPoints[action.index - 1] =
        newPoints[action.index - 1].copyWith(cutSegment: false, isStop: false);

    newState = newState.copyWith(
      path: newState.path.copyWith(
        segments: newSegments,
      ),
    );
  }

  newPoints.removeAt(action.index);

  // If the first point is deleted make sure that the new first point has correct
  // parameters for a first point ('useHeading' should be true)
  if (newPoints.isNotEmpty && action.index == 0) {
    newPoints[0] = newPoints[0].copyWith(useHeading: true);
  }

  // Select the previous point
  newState = _objectSelected(newState, ObjectSelected(action.index - 1, Point));

  return newState.copyWith(
    path: newState.path.copyWith(
      points: newPoints,
      // Show no spline if only one/zero points are left
      evaluatedPoints: newPoints.length < 2 ? <SplinePoint>[] : null,
      segments: newState.path.segments
          .map(
            (final Segment segment) => segment.copyWith(
              pointIndexes: segment.pointIndexes
                  .where((final int pointIndex) => pointIndex != action.index)
                  .map(
                    (final int pointIndex) =>
                        pointIndex > action.index ? pointIndex - 1 : pointIndex,
                  )
                  .toList(),
            ),
          )
          // Make sure no empty sgements are left
          .where((final Segment segment) => segment.pointIndexes.isNotEmpty)
          .toList(),
    ),
  );
}

TabState _setFieldSizePixels(
  final TabState tabState,
  final SetFieldSizePixels action,
) =>
    tabState.copyWith(
      ui: tabState.ui.copyWith(fieldSizePixels: action.size),
    );

TabState _editSegment(final TabState tabState, final EditSegment action) =>
    tabState.copyWith(
      path: tabState.path.copyWith(
        segments: tabState.path.segments
            .asMap()
            .entries
            .map((final MapEntry<int, Segment> e) {
          if (action.index != e.key) return e.value;
          return e.value.copyWith(
            isHidden: action.isHidden,
            maxVelocity: action.velocity,
          );
        }).toList(),
      ),
    );

TabState editRobot(final TabState tabState, final EditRobot action) =>
    tabState.copyWith(
      robot: tabState.robot.copyWith(
        width: action.robot.width,
        height: action.robot.height,
        maxAcceleration: action.robot.maxAcceleration,
        skidAcceleration: action.robot.skidAcceleration,
        maxJerk: action.robot.maxJerk,
        maxVelocity: action.robot.maxVelocity,
        cycleTime: action.robot.cycleTime,
        angularAccelerationPercentage:
            action.robot.angularAccelerationPercentage,
      ),
    );

TabState _toggleHeading(final TabState tabState, final ToggleHeading action) =>
    tabState.copyWith(
      ui: tabState.ui.copyWith(headingToggle: !tabState.ui.headingToggle),
    );

TabState _toggleControl(final TabState tabState, final ToggleControl action) =>
    tabState.copyWith(
      ui: tabState.ui.copyWith(controlToggle: !tabState.ui.controlToggle),
    );

TabState _trajectoryFileNameChanged(
  final TabState tabState,
  final TrajectoryFileNameChanged action,
) =>
    tabState.copyWith(
      ui: tabState.ui.copyWith(
        trajectoryFileName: action.fileName,
      ),
    );

TabState _pathUndo(final TabState tabState, final PathUndo action) {
  final int newStateIndex = max(tabState.history.currentStateIndex - 1, 0);

  return tabState.copyWith(
    ui: tabState.ui.copyWith(
      selectedIndex: 0,
      selectedType: History,
      isSidebarOpen: true,
    ),
    path: tabState.history.pathHistory[newStateIndex].path.copyWith(),
    history: tabState.history.copyWith(
      currentStateIndex: newStateIndex,
    ),
  );
}

TabState _pathRedo(final TabState tabState, final PathRedo action) {
  final int newStateIndex = min(
    tabState.history.currentStateIndex + 1,
    tabState.history.pathHistory.length - 1,
  );

  return tabState.copyWith(
    ui: tabState.ui.copyWith(
      selectedIndex: 0,
      selectedType: History,
      isSidebarOpen: true,
    ),
    path: tabState.history.pathHistory[newStateIndex].path.copyWith(),
    history: tabState.history.copyWith(
      currentStateIndex: newStateIndex,
    ),
  );
}

TabState _setZoomLevel(final TabState tabState, final SetZoomLevel action) =>
    tabState.copyWith(
      ui: tabState.ui.copyWith(
        zoomLevel: action.zoomLevel,
        pan: action.pan,
      ),
    );

TabState _setPan(final TabState tabState, final SetPan action) =>
    tabState.copyWith(
      ui: tabState.ui.copyWith(
        pan: action.pan,
      ),
    );

TabState _setRobotOnField(
  final TabState tabState,
  final SetRobotOnField action,
) {
  if (tabState.path.trajectoryPoints.isEmpty) {
    return tabState;
  }
  final Offset actualClickPos = action.clickPos.scale(
    officialFieldWidth / tabState.ui.fieldSizePixels.dx,
    officialFieldHeight / tabState.ui.fieldSizePixels.dy,
  );
  final (TrajectoryResponse_SwervePoint, double) closestPoint =
      findClosestPoint(actualClickPos, tabState.path.trajectoryPoints);
  return tabState.copyWith(
    path: tabState.path.copyWith(
      robotOnField: closestPoint.$2 < 0.3
          ? Some<RobotOnField>(
              RobotOnField(
                fromRpcVector(closestPoint.$1.position),
                closestPoint.$1.heading,
              ),
            )
          : None<RobotOnField>(),
    ),
  );
}

(TrajectoryResponse_SwervePoint, double) findClosestPoint(
  final Offset target,
  final List<TrajectoryResponse_SwervePoint> points,
) {
  double distFromTarget(final TrajectoryResponse_SwervePoint point) =>
      (target - fromRpcVector(point.position)).distanceSquared;

  return points.fold(
    (points.first, distFromTarget(points.first)),
    (
      final (TrajectoryResponse_SwervePoint, double) closest,
      final TrajectoryResponse_SwervePoint point,
    ) {
      final double pointDist = distFromTarget(point);
      return pointDist < closest.$2 ? (point, pointDist) : closest;
    },
  );
}
