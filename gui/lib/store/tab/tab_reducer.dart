import "dart:math";
import "package:collection/collection.dart";
import "package:flutter/material.dart";
import "package:orbit_standard_library/orbit_standard_library.dart";
import "package:pathfinder/models/history.dart";
import "package:pathfinder/models/path_point.dart";
import "package:pathfinder/models/robot_on_field.dart";
import "package:pathfinder/models/segment.dart";
import "package:pathfinder/rpc/protos/pathfinder_service.pb.dart" as rpc;
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
  TypedReducer<TabState, SetRobotOnFieldRaw>(_setRobotOnFieldRaw),
  TypedReducer<TabState, CopyPoint>(_copyPoint),
]);

List<Type> historyAffectingActions = <Type>[
  AddPointToPath,
  DeletePointFromPath,
  EditPoint,
  EditSegment,
  EditRobot,
];

List<Type> unsavedChangesActions = <Type>[
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
//TODO: server errors aren't currently handled
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
  double autoDuration = 0.0;
  double firstPointTime = action.points.first.time;

  action.points
      .mapIndexed((final int index, final rpc.SwervePoints_SwervePoint p) {
    if (index == action.points.length - 1) {
      autoDuration += firstPointTime;
      return;
    }

    // Use '>' to avoid floating point errors in equality check
    if (!(p.time > 0)) {
      autoDuration += firstPointTime;
      firstPointTime = action.points[index + 1].time;
    }
  });

  return tabState.copyWith(
    ui: tabState.ui.copyWith(serverError: null),
    path: tabState.path.copyWith(
      autoDuration: autoDuration,
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
        (final rpc.SplinePoint p) => SplinePoint(
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
    final List<PathPoint> points = tabState.path.points;
    position = (points[insertIndex - 1].position + points[insertIndex].position)
        .scale(0.5, 0.5);
  }

  PathPoint newPoint =
      action.point == null ? PathPoint.initial(position) : action.point!;

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

  final List<PathPoint> newPoints = tabState.path.points;
  List<Segment> segments = tabState.path.segments;
  if (segments.isEmpty) {
    segments = <Segment>[Segment.initial()];
  }

  newPoints.insert(insertIndex, newPoint);

  final TabState newState = tabState.copyWith(
    path: tabState.path.copyWith(
      points: newPoints,
      segments: segments.mapIndexed((final int index, final Segment segment) {
        final List<int> pointIndexes = segment.pointIndexes;

        // Assuming the point indexes are sorted inside the segments we can
        // add another index to the list and increment all the following indexes
        if (index == segmentIndex) {
          final List<int> newPointIndexes = pointIndexes
            ..add(pointIndexes.isEmpty ? 0 : pointIndexes.last + 1);
          return segment.copyWith(pointIndexes: newPointIndexes);
        }

        // Increment all following indexes
        if (index > segmentIndex) {
          return segment.copyWith(
            pointIndexes: pointIndexes.map((final int val) => val + 1).toList(),
          );
        }

        return segment;
      }).toList(),
    ),
  );

  return newState;
}

//TODO: don't use this function in home
TabState editPoint(final TabState tabState, final EditPoint action) {
  bool addSegment = false;
  bool removeSegment = false;

  final TabState newState = tabState.copyWith(
    path: tabState.path.copyWith(
      points: tabState.path.points
          .mapIndexed((final int index, final PathPoint pathPoint) {
        if (index != action.pointIndex) {
          return pathPoint;
        }

        // Dont allow to cut segments in the end or start of points list
        final bool cutSegmentAllowed = action.pointIndex != 0 &&
            action.pointIndex != tabState.path.points.length - 1;

        // Always set use heading true for the first point
        final bool useHeading =
            action.useHeading ?? pathPoint.useHeading || action.pointIndex == 0;

        // Get and validate cut & stop values
        bool cutSegment =
            (action.cutSegment ?? pathPoint.cutSegment) && cutSegmentAllowed;
        bool isStop = (action.isStop ?? pathPoint.isStop) && cutSegmentAllowed;

        // Cut or uncut the segment if stop or cut changes
        if (isStop && !pathPoint.isStop) cutSegment = true;
        if (!isStop && pathPoint.isStop) cutSegment = false;

        addSegment = (cutSegment) && !pathPoint.cutSegment;
        removeSegment = !(cutSegment) && pathPoint.cutSegment;

        if (pathPoint.isStop && removeSegment) isStop = false;

        return pathPoint.copyWith(
          position: action.position ?? pathPoint.position,
          inControlPoint: action.inControlPoint ?? pathPoint.inControlPoint,
          outControlPoint: action.outControlPoint != pathPoint.outControlPoint
              ? action.outControlPoint
              : (action.isStop != null && !action.isStop!)
                  ? Offset.fromDirection(
                      pathPoint.inControlPoint.direction + pi,
                      pathPoint.outControlPoint.distance,
                    )
                  : pathPoint.outControlPoint,
          heading: action.heading ?? pathPoint.heading,
          useHeading: useHeading,
          action: action.action ?? pathPoint.action,
          actionTime: action.actionTime ?? pathPoint.actionTime,
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

    final List<Segment> newSegments = tabState.path.segments;
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
            newSegments.mapIndexed((final int index, final Segment segment) {
          if (index != currentSegmentIndex) return segment;
          return segment.copyWith(
            pointIndexes: segment.pointIndexes
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

    final List<Segment> newSegments = tabState.path.segments;
    final List<int> removedPointIndxes =
        newSegments.removeAt(removedSegmentIndex).pointIndexes;

    return newState.copyWith(
      path: newState.path.copyWith(
        segments:
            newSegments.mapIndexed((final int index, final Segment segment) {
          if (index != removedSegmentIndex - 1) return segment;
          return segment.copyWith(
            pointIndexes: segment.pointIndexes + removedPointIndxes,
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

  if (tabState.ui.selectedType != PathPoint ||
      tabState.ui.selectedIndex != action.index) return tabState;

  TabState newState = tabState;
  final List<PathPoint> newPoints = tabState.path.points;

  // Clear the segment of the point if it its cutting a segment, add all the points to
  // the previous segment (including the removed one, it will be handled later)

  if (newPoints[action.index].cutSegment) {
    final List<Segment> newSegments = newState.path.segments;

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
    final List<Segment> newSegments = newState.path.segments;

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
  newState =
      _objectSelected(newState, ObjectSelected(action.index - 1, PathPoint));

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
            .mapIndexed((final int index, final Segment segment) {
          if (action.index != index) return segment;
          return segment.copyWith(
            isHidden: action.isHidden,
            maxVelocity: action.velocity,
          );
        }).toList(),
      ),
    );
//TODO: make private
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
    path: tabState.history.pathHistory[newStateIndex].path,
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
    path: tabState.history.pathHistory[newStateIndex].path,
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

TabState _setRobotOnFieldRaw(
  final TabState tabState,
  final SetRobotOnFieldRaw action,
) =>
    tabState.copyWith(
      path: tabState.path.copyWith(
        robotOnField: Some<RobotOnField>(
          RobotOnField(action.position, action.heading, action.action),
        ),
      ),
    );

TabState _setRobotOnField(
  final TabState tabState,
  final SetRobotOnField action,
) {
  if (tabState.path.trajectoryPoints.isEmpty) {
    return tabState;
  }
  final Offset actualClickPos = tabState.ui.pixToMeters(action.clickPos);

  final (rpc.SwervePoints_SwervePoint, double) closestPoint =
      findClosestPoint(actualClickPos, tabState.path.trajectoryPoints);
  return tabState.copyWith(
    path: tabState.path.copyWith(
      robotOnField: closestPoint.$2 < 0.3
          ? Some<RobotOnField>(
              RobotOnField(
                fromRpcVector(closestPoint.$1.position),
                closestPoint.$1.heading,
                "",
              ),
            )
          : None<RobotOnField>(),
    ),
  );
}

(rpc.SwervePoints_SwervePoint, double) findClosestPoint(
  final Offset target,
  final List<rpc.SwervePoints_SwervePoint> points,
) {
  double distFromTarget(final rpc.SwervePoints_SwervePoint point) =>
      (target - fromRpcVector(point.position)).distanceSquared;

  return points.fold(
    (points.first, distFromTarget(points.first)),
    (
      final (rpc.SwervePoints_SwervePoint, double) closest,
      final rpc.SwervePoints_SwervePoint point,
    ) {
      final double pointDist = distFromTarget(point);
      return pointDist < closest.$2 ? (point, pointDist) : closest;
    },
  );
}

TabState _copyPoint(final TabState tabState, final CopyPoint action) =>
    tabState.copyWith(
      path: tabState.path.copyWith(
        copiedPoint: Some<PathPoint>(tabState.path.points[action.index]),
      ),
    );
