import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:pathfinder/models/field.dart';
import 'package:pathfinder/models/history.dart';
import 'package:pathfinder/models/path.dart';
import 'package:pathfinder/models/point.dart';
import 'package:pathfinder/models/segment.dart';
import 'package:pathfinder/services/pathfinder.dart';
import 'package:pathfinder/store/tab/tab_ui/tab_ui.dart';
import 'package:redux/redux.dart';

import 'tab_actions.dart';
import 'tab_state.dart';

Reducer<TabState> applyReducers = combineReducers<TabState>([
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
  TypedReducer<TabState, OpenFile>(_openFile),
  TypedReducer<TabState, SaveFile>(_saveFile),
  TypedReducer<TabState, PathUndo>(_pathUndo),
  TypedReducer<TabState, PathRedo>(_pathRedo),
  TypedReducer<TabState, SetZoomLevel>(_setZoomLevel),
  TypedReducer<TabState, SetPan>(_setPan),
  TypedReducer<TabState, NewAuto>(_newAuto),
]);

List<Type> historyAffectingActions = [
  AddPointToPath,
  DeletePointFromPath,
  EditPoint,
  EditSegment,
];

Map<String, IconData> actionToIcon = {
  '$AddPointToPath': Icons.add,
  '$DeletePointFromPath': Icons.remove,
  '$EditPoint': Icons.edit_location_outlined,
  '$EditSegment': Icons.edit_road,
  '$initialActionName': Icons.start,
};

TabState tabStateReducer(TabState tabState, dynamic action) {
  final newTabState = applyReducers(tabState, action);

  // Add path to history only after the relevant actions
  if (historyAffectingActions.contains(action.runtimeType)) {
    final newPathHistory = [
      ...newTabState.history.pathHistory
          .sublist(0, newTabState.history.currentStateIndex + 1),
      HistoryStamp.fromReducer(
        action,
        newTabState.path.copyWith(
          // Remove the evaluated points from the saved path, it is calculated async
          // and isn't correct here (will be calculated anyway in the redo/undo thunk)
          evaluatedPoints: [],
        ),
      )
    ];
    var newCurrentIndex = newTabState.history.currentStateIndex + 1;

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

TabState _setSidebarVisibility(TabState tabstate, SetSideBarVisibility action) {
  return tabstate.copyWith(
      ui: tabstate.ui.copyWith(isSidebarOpen: action.visibility));
}

TabState _objectSelected(TabState tabState, ObjectSelected action) {
  return tabState.copyWith(
    ui: tabState.ui.copyWith(
      isSidebarOpen: true,
      selectedIndex: action.index,
      selectedType: action.type,
    ),
  );
}

TabState _objectUnselected(TabState tabState, ObjectUnselected action) {
  return tabState.copyWith(
    ui: tabState.ui.copyWith(
      isSidebarOpen: false,
      selectedIndex: -1,
      selectedType: Null,
    ),
  );
}

TabState _setServerError(TabState tabState, ServerError action) {
  return tabState.copyWith(ui: tabState.ui.copyWith(serverError: action.error));
}

TabState _trajectoryInProgress(TabState tabState, TrajectoryInProgress action) {
  return tabState.copyWith(
      path: tabState.path.copyWith(
    autoDuration: -1,
  ));
}

TabState _trajectoryCalculated(TabState tabState, TrajectoryCalculated action) {
  var autoDuartion = 0.0;
  var firstPointTime = action.points.first.time;

  action.points.asMap().forEach((index, p) {
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
      path: tabState.path.copyWith(autoDuration: autoDuartion));
}

TabState _splineCalculated(TabState tabState, SplineCalculated action) {
  final evaluatedPoints = action.points
      .map((p) => SplinePoint(
            position: fromRpcVector(p.point),
            segmentIndex: p.segmentIndex,
          ))
      .toList();

  return tabState.copyWith(
      ui: tabState.ui.copyWith(serverError: null),
      path: tabState.path.copyWith(evaluatedPoints: evaluatedPoints));
}

TabState _addPointToPath(TabState tabState, AddPointToPath action) {
  // If the segment to add is -1, treat it as if the addition is to the end
  // of the point list and to the last segment
  var insertIndex = action.insertIndex >= 0
      ? action.insertIndex
      : max(tabState.path.points.length, 0);
  var segmentIndex = action.segmentIndex >= 0
      ? action.segmentIndex
      : max(tabState.path.segments.length - 1, 0);

  var position = action.position;

  if (position == null) {
    // If position is null, calculate it by the previues position and current position
    final points = tabState.path.points;
    position = (points[insertIndex - 1].position + points[insertIndex].position)
        .scale(0.5, 0.5);
  }

  var newPoint = Point.initial(position);

  if (tabState.path.points.length > 0) {
    Offset inControlOffset = Offset.fromDirection(
        (tabState.path.points[tabState.path.points.length - 1].position -
                newPoint.position)
            .direction,
        defaultControlLength);
    Offset outControlOFfset = Offset.fromDirection(
        inControlOffset.direction + pi, inControlOffset.distance);
    newPoint = newPoint.copyWith(
        inControlPoint: inControlOffset, outControlPoint: outControlOFfset);
  }

  var newPoints = [...tabState.path.points];

  if (tabState.path.segments.length == 0) {
    tabState.path.segments.add(Segment.initial());
  }

  newPoints.insert(insertIndex, newPoint);

  final newState = tabState.copyWith(
    path: tabState.path.copyWith(
      points: newPoints,
      segments: tabState.path.segments.asMap().entries.map((e) {
        final pointIndexes = [...e.value.pointIndexes];

        // Assuming the point indexes are sorted inside the segments we can
        // add another index to the list and increment all the following indexes
        if (e.key == segmentIndex) {
          final newPointIndexes = pointIndexes
            ..add(pointIndexes.isEmpty ? 0 : pointIndexes.last + 1);
          return e.value.copyWith(pointIndexes: newPointIndexes);
        }

        // Increment all following indexes
        if (e.key > segmentIndex) {
          return e.value.copyWith(
            pointIndexes: pointIndexes.map((val) => val + 1).toList(),
          );
        }

        return e.value;
      }).toList(),
    ),
  );

  return newState;
}

TabState editPoint(TabState tabState, EditPoint action) {
  bool addSegment = false;
  bool removeSegment = false;

  final newState = tabState.copyWith(
    path: tabState.path.copyWith(
      points: tabState.path.points.asMap().entries.map((e) {
        if (e.key != action.pointIndex) {
          return e.value;
        }

        // Dont allow to cut segments in the end or start of points list
        final cutSegmentAllowed = action.pointIndex != 0 &&
            action.pointIndex != tabState.path.points.length - 1;

        // Always set use heading true for the first point
        var useHeading =
            action.useHeading ?? e.value.useHeading || action.pointIndex == 0;

        // Get and validate cut & stop values
        var cutSegment =
            (action.cutSegment ?? e.value.cutSegment) && cutSegmentAllowed;
        var isStop = (action.isStop ?? e.value.isStop) && cutSegmentAllowed;

        // Cut or uncut the segment if stop or cut changes
        if (isStop && !e.value.isStop) cutSegment = true;
        if (!isStop && e.value.isStop) cutSegment = false;

        addSegment = (cutSegment) && !e.value.cutSegment;
        removeSegment = !(cutSegment) && e.value.cutSegment;

        if (e.value.isStop && removeSegment) isStop = false;

        return e.value.copyWith(
          position: action.position ?? e.value.position,
          inControlPoint: action.inControlPoint ?? e.value.inControlPoint,
          outControlPoint: action.outControlPoint ?? e.value.outControlPoint,
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
    final currentSegmentIndex = tabState.path.segments
        .indexWhere((s) => s.pointIndexes.contains(action.pointIndex));

    final newSegments = [...tabState.path.segments];
    newSegments.insert(
        currentSegmentIndex + 1,
        Segment.initial(
          pointIndexes: newSegments[currentSegmentIndex]
              .pointIndexes
              .where((index) => index >= action.pointIndex)
              .toList(),
        ));

    return newState.copyWith(
      path: newState.path.copyWith(
        segments: newSegments.asMap().entries.map((e) {
          if (e.key != currentSegmentIndex) return e.value;
          return e.value.copyWith(
            pointIndexes: e.value.pointIndexes
                .where((index) => index < action.pointIndex)
                .toList(),
          );
        }).toList(),
      ),
    );
  }

  if (removeSegment) {
    final removedSegmentIndex = tabState.path.segments
        .indexWhere((s) => s.pointIndexes.contains(action.pointIndex));

    final newSegments = [...tabState.path.segments];
    final removedPointIndxes =
        newSegments.removeAt(removedSegmentIndex).pointIndexes;

    return newState.copyWith(
      path: newState.path.copyWith(
        segments: newSegments.asMap().entries.map((e) {
          if (e.key != removedSegmentIndex - 1) return e.value;
          return e.value.copyWith(
              pointIndexes: e.value.pointIndexes + removedPointIndxes);
        }).toList(),
      ),
    );
  }

  return newState;
}

TabState _deletePointFromPath(TabState tabState, DeletePointFromPath action) {
  if (action.index == -1) return tabState;

  if (tabState.ui.selectedType != Point ||
      tabState.ui.selectedIndex != action.index) return tabState;

  var newState = tabState.copyWith();
  var newPoints = [...tabState.path.points];

  // Clear the segment of the point if it its cutting a segment, add all the points to
  // the previous segment (including the removed one, it will be handled later)
  if (newPoints[action.index].cutSegment) {
    var newSegments = [...newState.path.segments];

    final removedSegmentIndex = tabState.path.segments
        .indexWhere((s) => s.pointIndexes.contains(action.index));

    // Get the points that where removed from the segment and add them to the previous
    // segment, the first point never starts a segement so there always should be at least one segment
    // in case of deleting a 'cutting segment' point like here
    final removedSegment = newSegments[removedSegmentIndex];
    final previousSegment = newSegments[removedSegmentIndex - 1];

    newSegments[removedSegmentIndex - 1] = previousSegment.copyWith(
        pointIndexes:
            previousSegment.pointIndexes + removedSegment.pointIndexes);
    newSegments[removedSegmentIndex] =
        removedSegment.copyWith(pointIndexes: []);

    newState = newState.copyWith(
      path: newState.path.copyWith(
        segments: newSegments,
      ),
    );
  }

  newPoints.removeAt(action.index);

  // If the first point is deleted make sure that the new first point has correct
  // parameters for a first point ('useHeading' should be true)
  if (action.index == 0) {
    newPoints[0] = newPoints[0].copyWith(useHeading: true);
  }

  // Select the previous point
  newState = _objectSelected(newState, ObjectSelected(action.index - 1, Point));

  return newState.copyWith(
    path: newState.path.copyWith(
      points: newPoints,
      // Show no spline if only one/zero points are left
      evaluatedPoints: newPoints.length < 2 ? [] : null,
      segments: newState.path.segments
          .map(
            (segment) => segment.copyWith(
              pointIndexes: segment.pointIndexes
                  .where((pointIndex) => pointIndex != action.index)
                  .map((pointIndex) =>
                      pointIndex > action.index ? pointIndex - 1 : pointIndex)
                  .toList(),
            ),
          )
          // Make sure no empty sgements are left
          .where((segment) => segment.pointIndexes.isNotEmpty)
          .toList(),
    ),
  );
}

TabState _setFieldSizePixels(TabState tabState, SetFieldSizePixels action) {
  return tabState.copyWith(
      ui: tabState.ui.copyWith(fieldSizePixels: action.size));
}

TabState _editSegment(TabState tabState, EditSegment action) {
  return tabState.copyWith(
    path: tabState.path.copyWith(
      segments: tabState.path.segments.asMap().entries.map((e) {
        if (action.index != e.key) return e.value;
        return e.value.copyWith(
          isHidden: action.isHidden,
          maxVelocity: action.velocity,
        );
      }).toList(),
    ),
  );
}

TabState editRobot(TabState tabState, EditRobot action) {
  return tabState.copyWith(
    robot: tabState.robot.copyWith(
      width: action.robot.width,
      height: action.robot.height,
      maxAcceleration: action.robot.maxAcceleration,
      maxAngularAcceleration: action.robot.maxAngularAcceleration,
      maxAngularVelocity: action.robot.maxAngularVelocity,
      skidAcceleration: action.robot.skidAcceleration,
      maxJerk: action.robot.maxJerk,
      maxVelocity: action.robot.maxVelocity,
      cycleTime: action.robot.cycleTime,
      angularAccelerationPercentage: action.robot.angularAccelerationPercentage,
    ),
  );
}

TabState _toggleHeading(TabState tabState, ToggleHeading action) {
  return tabState.copyWith(
      ui: tabState.ui.copyWith(headingToggle: !tabState.ui.headingToggle));
}

TabState _toggleControl(TabState tabState, ToggleControl action) {
  return tabState.copyWith(
      ui: tabState.ui.copyWith(controlToggle: !tabState.ui.controlToggle));
}

TabState _trajectoryFileNameChanged(
    TabState tabState, TrajectoryFileNameChanged action) {
  return tabState.copyWith(
    ui: tabState.ui.copyWith(
      trajectoryFileName: action.fileName,
    ),
  );
}

TabState _openFile(TabState tabState, OpenFile action) {
  // Json decode may fail so wrap with try/catch
  try {
    final decodedState = jsonDecode(action.fileContent)['tabState'];
    final fileState = TabState.fromJson(decodedState);

    return fileState.copyWith(
      ui: fileState.ui.copyWith(
        autoFileName: action.fileName,
        changesSaved: true,
      ),
    );
  } catch (e) {}

  return tabState;
}

TabState _saveFile(TabState tabState, SaveFile action) {
  return tabState.copyWith(
    ui: tabState.ui.copyWith(
      autoFileName: action.fileName,
      changesSaved: true,
    ),
  );
}

TabState _pathUndo(TabState tabState, PathUndo action) {
  final newStateIndex = max(tabState.history.currentStateIndex - 1, 0);

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

TabState _pathRedo(TabState tabState, PathRedo action) {
  final newStateIndex = min(tabState.history.currentStateIndex + 1,
      tabState.history.pathHistory.length - 1);

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

TabState _setZoomLevel(TabState tabState, SetZoomLevel action) {
  return tabState.copyWith(
    ui: tabState.ui.copyWith(
      zoomLevel: action.zoomLevel,
      pan: action.pan,
    ),
  );
}

TabState _setPan(TabState tabState, SetPan action) {
  return tabState.copyWith(
    ui: tabState.ui.copyWith(
      pan: action.pan,
    ),
  );
}

TabState _newAuto(TabState tabState, NewAuto action) {
  return tabState.copyWith(
    path: Path.initial(),
    history: History.initial(),
    ui: TabUI.initial(),
  );
}
