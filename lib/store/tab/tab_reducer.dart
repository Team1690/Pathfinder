import 'dart:math';
import 'dart:ui';

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
  TypedReducer<TabState, ToggleHeading>(_toggleHeading),
  TypedReducer<TabState, ToggleControl>(_toggleControl),
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

  Point newPoint = Point.initial(action.position);
  if (tabState.path.points.length > 0) {
    Offset inControlOffset = Offset.fromDirection((tabState.path.points[tabState.path.points.length - 1].position - newPoint.position).direction, defaultControlLength);
    Offset outControlOFfset = Offset.fromDirection(inControlOffset.direction + pi, inControlOffset.distance);
    newPoint =  newPoint.copyWith(
      inControlPoint: inControlOffset,
      outControlPoint: outControlOFfset
    );
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
          useHeading: action.useHeading ?? e.value.useHeading,
          actions: action.actions ?? e.value.actions,
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
  if (tabState.ui.selectedType == Point &&
      tabState.ui.selectedIndex == action.index) {
    List<Point> newPoints = [...tabState.path.points];

    var newState = tabState.copyWith();

    // Handle the case when the deleted point is also cutting a segment
    if (newPoints[action.index].cutSegment) {
      var newSegments = [...newState.path.segments];

      final removedSegmentIndex = tabState.path.segments
          .indexWhere((s) => s.pointIndexes.contains(action.index));

      // Put the points that where removed from the segment and add them to the previous
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

    return newState.copyWith(
      ui: newState.ui.copyWith(
        selectedIndex: -1,
        selectedType: Null,
        isSidebarOpen: false,
      ),
      path: newState.path.copyWith(
        points: newPoints,
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

  return tabState;
}

TabState _setFieldSizePixels(TabState tabState, SetFieldSizePixels action) {
  return tabState.copyWith(
      ui: tabState.ui.copyWith(fieldSizePixels: action.size));
}

TabState _toggleHeading(TabState tabState, ToggleHeading action) {
  return tabState.copyWith(
    ui: tabState.ui.copyWith(headingToggle: !tabState.ui.headingToggle)
  );
}

TabState _toggleControl(TabState tabState, ToggleControl action) {
  return tabState.copyWith(
    ui: tabState.ui.copyWith(controlToggle: !tabState.ui.controlToggle)
  );
}
