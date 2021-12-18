import 'dart:math';

import 'package:pathfinder/models/point.dart';
import 'package:pathfinder/models/segment.dart';
import 'package:redux/redux.dart';

import 'tab_actions.dart';
import 'tab_state.dart';

Reducer<TabState> tabStateReducer = combineReducers<TabState>([
  TypedReducer<TabState, SetSideBarVisibility>(_setSidebarVisibility),
  TypedReducer<TabState, ObjectSelected>(_objectSelected),
  TypedReducer<TabState, AddPointToPath>(_addPointToPath),
  TypedReducer<TabState, DeletePointFromPath>(_deletePointFromPath),
  TypedReducer<TabState, SplineCalculated>(_splineCalculated),
  TypedReducer<TabState, ServerError>(_setServerError),
  TypedReducer<TabState, EditPoint>(editPoint),
  TypedReducer<TabState, SetFieldSizePixels>(_setFieldSizePixels),
]);

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

TabState _setServerError(TabState tabState, ServerError action) {
  return tabState.copyWith(ui: tabState.ui.copyWith(serverError: action.error));
}

TabState _splineCalculated(TabState tabState, SplineCalculated action) {
  return tabState.copyWith(
      ui: tabState.ui.copyWith(serverError: null),
      path: tabState.path.copyWith(evaluatedPoints: action.points));
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

  final newPoint = Point.initial(action.position);
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
    ui: tabState.ui.copyWith(
      selectedIndex: action.pointIndex,
      selectedType: Point,
    ),
    path: tabState.path.copyWith(
      points: tabState.path.points.asMap().entries.map((e) {
        if (e.key != action.pointIndex) {
          return e.value;
        }

        // Dont allow to cut segments in the end or start of points list
        final cutSegmentAllowed = action.pointIndex != 0 &&
            action.pointIndex != tabState.path.points.length - 1;
        var cutSegment =
            (action.cutSegment ?? e.value.cutSegment) && cutSegmentAllowed;

        addSegment = (cutSegment) && !e.value.cutSegment;
        removeSegment = !(cutSegment) && e.value.cutSegment;

        return e.value.copyWith(
          position: action.position,
          inControlPoint: action.inControlPoint,
          outControlPoint: action.outControlPoint,
          heading: action.heading,
          useHeading: action.useHeading,
          actions: action.actions,
          cutSegment: cutSegment,
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
          // TODO: think if this is the right logic and will not cause faulties on edge cases
          if (e.key != removedSegmentIndex - 1) return e.value;
          return e.value.copyWith(
              pointIndexes: e.value.pointIndexes + removedPointIndxes);
        }).toList(),
      ),
    );
  }

  return newState;
}

// TODO: !!!!!!! Remove segment when removing cutting point!!!!!!!:
TabState _deletePointFromPath(TabState tabState, DeletePointFromPath action) {
  List<Point> newPoints = tabState.path.points;
  newPoints.removeAt(action.index);

  var newState = tabState.copyWith(
      path: tabState.path.copyWith(
    points: newPoints,
    evaluatedPoints: newPoints.length < 2 ? [] : null,
  ));

  if (tabState.ui.selectedType == Point &&
      tabState.ui.selectedIndex == action.index) {
    return newState.copyWith(
      ui: newState.ui.copyWith(
        selectedIndex: -1,
        selectedType: Null,
        isSidebarOpen: false,
      ),
      path: newState.path.copyWith(
          segments: newState.path.segments
              .map(
                (segment) => segment.copyWith(
                  pointIndexes: segment.pointIndexes
                      .where((pointIndex) => pointIndex != action.index)
                      .map((pointIndex) => pointIndex > action.index
                          ? pointIndex - 1
                          : pointIndex)
                      .toList(),
                ),
              )
              // Make sure no empty sgements are left
              .where((segment) => segment.pointIndexes.isNotEmpty)
              .toList()),
    );
  }
  return newState;
}

TabState _setFieldSizePixels(TabState tabState, SetFieldSizePixels action) {
  return tabState.copyWith(
      ui: tabState.ui.copyWith(fieldSizePixels: action.size));
}
