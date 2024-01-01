import "dart:math";
import "dart:ui" as ui;
import "package:collection/collection.dart";
import "package:flutter/material.dart";
import "package:pathfinder/constants.dart";
import "package:pathfinder/models/point.dart";
import "package:pathfinder/models/robot.dart";
import "package:pathfinder/models/segment.dart";
import "package:pathfinder/models/spline_point.dart" as modelspath;
import "package:pathfinder/widgets/editor/field_editor/field_loader.dart";
import "package:pathfinder/widgets/editor/field_editor/point_settings.dart";
import "package:pathfinder/widgets/editor/field_editor/point_type.dart";

import "package:pathfinder/widgets/editor/path_editor/dragging_point.dart";
import "package:pathfinder/widgets/editor/path_editor/full_dragging_point.dart";

Offset getZoomOffset(final Size size, final double zoom) =>
    Offset(size.width * (1 - zoom) / 2, size.height * (1 - zoom) / 2);

class FieldPainter extends CustomPainter {
  FieldPainter(
    this.image,
    this.points,
    this.segments,
    this.selectedPoint,
    this.dragPoints,
    this.enableHeadingEditing,
    this.enableControlEditing,
    this.evaluetedPoints,
    this.robot,
    this.imageZoom,
    this.imageOffset,
  );
  ui.Image image;
  List<Point> points;
  List<Segment> segments;
  int? selectedPoint;
  List<FullDraggingPoint> dragPoints;
  bool enableHeadingEditing;
  bool enableControlEditing;
  List<modelspath.SplinePoint> evaluetedPoints;
  Robot robot;
  double imageZoom;
  Offset imageOffset;

  @override
  void paint(final Canvas canvas, final Size size) {
    canvas.scale(1, -1);
    canvas.translate(0, -size.height);

    canvas.translate(imageOffset.dx, imageOffset.dy);
    final Offset zoomOffset = getZoomOffset(size, imageZoom);
    canvas.translate(zoomOffset.dx, zoomOffset.dy);
    canvas.scale(imageZoom);

    paintImage(
      canvas: canvas,
      fit: BoxFit.fill,
      rect: Rect.fromPoints(Offset.zero, size.bottomRight(Offset.zero)),
      colorFilter:
          ColorFilter.mode(Colors.black.withOpacity(0.5), BlendMode.darken),
      image: image,
    );

    // Group spline points by segment index
    final Map<int, List<modelspath.SplinePoint>> segmentIndexToSplinePoints =
        groupBy(
      evaluetedPoints,
      (final modelspath.SplinePoint p) => p.segmentIndex,
    );

    // Draw the path each segment at a time
    segmentIndexToSplinePoints.entries
        .forEach((final MapEntry<int, List<modelspath.SplinePoint>> e) {
      // Skip and don't draw hidden segments
      if (segments[e.key].isHidden) return;

      final ui.Color segmentColor = getSegmentColor(e.key);
      drawPathShadow(canvas, e.value);
      drawPath(canvas, e.value, segmentColor);
      // drawWheelsPath(canvas, evaluetedPoints!);
    });

    // Get the 'isHidden' value for each point (large points with controls) according
    // to the segment data, keep all the points in the list to keep the point indexes
    final List<List<Object>> segmentPointsWithIsHidden =
        points.asMap().entries.map((final MapEntry<int, Point> e) {
      final Iterable<Segment> pointSegments = segments.whereIndexed(
        (final int index, final Segment segment) =>
            segment.pointIndexes.contains(e.key) ||
            segment.pointIndexes.last + 1 == e.key,
      );
      return <Object>[
        e.value,
        pointSegments.every((final Segment s) => s.isHidden),
      ];
    }).toList();

    // Draw the path points (large points with controls)
    segmentPointsWithIsHidden
        .asMap()
        .entries
        .forEach((final MapEntry<int, List<Object>> e) {
      final int index = e.key;
      final Point point = e.value[0] as Point;
      final bool isHidden = e.value[1] as bool;

      if (isHidden) return;

      drawPathPoint(
        canvas,
        point.position,
        point.heading,
        point.inControlPoint,
        point.outControlPoint,
        index == selectedPoint,
        point.isStop,
        enableHeadingEditing && selectedPoint == null,
        enableControlEditing && selectedPoint == null,
        point.useHeading,
        index == 0,
        index == points.length - 1,
      );
    });

    for (final MapEntry<int, FullDraggingPoint> entery
        in dragPoints.asMap().entries) {
      final FullDraggingPoint draggingPoint = entery.value;

      if (!((draggingPoint.index == 0 &&
              draggingPoint.draggingPoint.type == PointType.inControl) ||
          (draggingPoint.index == points.length - 1 &&
              draggingPoint.draggingPoint.type == PointType.outControl))) {
        drawDragPoint(
          canvas,
          points[draggingPoint.index],
          draggingPoint.draggingPoint,
        );
      }
    }
  }

  void drawPointBackground(
    final Canvas canvas,
    final Offset position,
    final bool isSelected,
    final bool isStopPoint,
    final bool isFirstPoint,
    final bool isLastPoint,
  ) {
    final PointSettings currentPointSettings = pointSettings[PointType.path]!;

    final ui.Color color = getPointColor(
      currentPointSettings.color,
      isStopPoint,
      isFirstPoint,
      isLastPoint,
      isSelected,
    );

    final Paint paint = Paint()..color = color;
    final ui.Paint highlightPaint = Paint()
      ..color = selectedPointHightlightColor
      ..maskFilter = MaskFilter.blur(BlurStyle.normal, convertRadiusToSigma(5));

    // Highlight selected point
    if (isSelected) {
      canvas.drawCircle(
        position,
        currentPointSettings.radius,
        highlightPaint,
      );
    }

    canvas.drawCircle(position, currentPointSettings.radius, paint);
  }

  void drawDragPoint(
    final Canvas canvas,
    final Point selectedPoint,
    final DraggingPoint dragPoint,
  ) {
    final PointSettings currentPointSettings = pointSettings[dragPoint.type]!;
    final Paint paint = Paint()..color = currentPointSettings.color;

    switch (dragPoint.type) {
      case PointType.path:
        canvas.drawCircle(
          dragPoint.position,
          currentPointSettings.radius,
          paint,
        );
        break;
      case PointType.inControl:
        continue control;
      control:
      case PointType.outControl:
        final Offset dragPosition = selectedPoint.position + dragPoint.position;
        canvas.drawCircle(dragPosition, currentPointSettings.radius, paint);
        drawControlPoint(
          canvas,
          dragPoint.type,
          selectedPoint.position,
          dragPoint.position,
          false,
          true,
        );
        drawPointBackground(
          canvas,
          Offset(
            selectedPoint.position.dx + dragPoint.position.dx,
            selectedPoint.position.dy + dragPoint.position.dy,
          ),
          true,
          false,
          false,
          false,
        );

        break;
      case PointType.heading:
        final Offset dragPosition = dragPoint.position;
        final double dragHeading = dragPosition.direction;
        drawHeadingLine(canvas, selectedPoint.position, dragHeading, false);
        drawPointBackground(
          canvas,
          selectedPoint.position +
              Offset.fromDirection(dragHeading, headingLength),
          true,
          false,
          false,
          false,
        );
        break;
      default:
    }
    if (dragPoint.type == PointType.path) {
    } else {}
  }

  void drawControlPoint(
    final Canvas canvas,
    final PointType pointType,
    final Offset position,
    final Offset control,
    final bool enableEdit,
    final bool isSelected,
  ) {
    final PointSettings settings = pointSettings[pointType]!;
    final Color color = settings.color;

    final ui.Paint linePaint = Paint()
      ..style = PaintingStyle.stroke
      ..color = color
      ..strokeWidth = 1;

    final Offset edge =
        Offset(position.dx + control.dx, position.dy + control.dy);
    canvas.drawLine(position, edge, linePaint);

    if (enableEdit) {
      final ui.Paint dotPaint = Paint()..color = color;
      canvas.drawCircle(edge, settings.radius, dotPaint);
    }
  }

  void drawHeadingLine(
    final Canvas canvas,
    final Offset position,
    final double heading,
    final bool enableEdit,
  ) {
    final PointSettings pointSetting = pointSettings[PointType.heading]!;
    final Offset edge = position + Offset.fromDirection(heading, headingLength);

    final ui.Paint paint = Paint()
      ..style = PaintingStyle.stroke
      ..color = pointSetting.color
      ..strokeWidth = 3;
    final double circleRadius = 1 / (paint.strokeWidth * paint.strokeWidth);

    canvas.drawLine(position, edge, paint);
    canvas.drawCircle(position, circleRadius, paint);
    canvas.drawCircle(edge, circleRadius, paint);

    if (enableEdit) {
      final ui.Paint dotPaint = Paint()..color = pointSetting.color;

      canvas.drawCircle(edge, pointSetting.radius, dotPaint);
    }
  }

  void drawPathPoint(
    final Canvas canvas,
    final Offset position,
    final double heading,
    final Offset inControl,
    final Offset outControl,
    final bool isSelected,
    final bool isStopPoint,
    final bool enableHeadingEditing,
    final bool enableControlEditing,
    final bool useHeading,
    final bool isFirstPoint,
    final bool isLastPoint,
  ) {
    drawPointBackground(
      canvas,
      position,
      isSelected,
      isStopPoint,
      isFirstPoint,
      isLastPoint,
    );
    if (useHeading) {
      drawHeadingLine(
        canvas,
        position,
        heading,
        enableHeadingEditing || isSelected,
      );
    }
    if (!isFirstPoint) {
      drawControlPoint(
        canvas,
        PointType.inControl,
        position,
        inControl,
        enableControlEditing || isSelected,
        false,
      );
    }
    if (!isLastPoint) {
      drawControlPoint(
        canvas,
        PointType.outControl,
        position,
        outControl,
        enableControlEditing || isSelected,
        false,
      );
    }
  }

  void drawPath(
    final Canvas canvas,
    final List<modelspath.SplinePoint> evaluetedPoints,
    final Color color,
  ) {
    final Paint paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;

    final Path path = Path();
    final List<ui.Offset> pathPoints = evaluetedPoints
        .map((final modelspath.SplinePoint p) => p.position)
        .toList();

    path.addPolygon(pathPoints, false);
    canvas.drawPath(path, paint);
  }

  void drawPathShadow(
    final Canvas canvas,
    final List<modelspath.SplinePoint> evaluetedPoints,
  ) {
    final Paint paint = Paint()
      ..color = Colors.black
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 4);

    final List<ui.Offset> pathPoints = evaluetedPoints
        .map((final modelspath.SplinePoint p) => p.position)
        .toList();

    final Path path = Path();
    path.addPolygon(pathPoints, false);
    canvas.drawPath(path, paint);
  }

  void drawWheelsPath(
    final Canvas canvas,
    final List<modelspath.SplinePoint> evaluetedPoints,
  ) {
    final double robotWidth = robot.width;

    final Paint paint = Paint()
      ..color = white.withOpacity(0.5)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;

    if (evaluetedPoints.isNotEmpty) {
      final List<Offset> leftPoints = evaluetedPoints
          .sublist(1)
          .asMap()
          .entries
          .map((final MapEntry<int, modelspath.SplinePoint> e) {
        final Offset dist = evaluetedPoints[e.key + 1].position -
            evaluetedPoints[e.key].position;
        return Offset.fromDirection(dist.direction - 0.5 * pi, robotWidth / 2)
            .translate(
          evaluetedPoints[e.key + 1].position.dx,
          evaluetedPoints[e.key + 1].position.dy,
        );
      }).toList();
      final List<Offset> rightPoints = evaluetedPoints
          .sublist(1)
          .asMap()
          .entries
          .map((final MapEntry<int, modelspath.SplinePoint> e) {
        final Offset dist = evaluetedPoints[e.key + 1].position -
            evaluetedPoints[e.key].position;
        return Offset.fromDirection(dist.direction + 0.5 * pi, robotWidth / 2)
            .translate(
          evaluetedPoints[e.key + 1].position.dx,
          evaluetedPoints[e.key + 1].position.dy,
        );
      }).toList();

      // inspect(pathPoints);
      final Path leftPath = Path();
      final Path rightPath = Path();

      leftPath.addPolygon(leftPoints, false);
      canvas.drawPath(leftPath, paint);

      rightPath.addPolygon(rightPoints, false);
      canvas.drawPath(rightPath, paint);
    }
  }

  @override
  // TODO: implement shouldRepaint
  bool shouldRepaint(final CustomPainter oldDelegate) => true;
}
