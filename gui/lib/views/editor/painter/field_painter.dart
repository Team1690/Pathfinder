import "dart:math";
import "dart:ui" as ui;

import "package:collection/collection.dart";
import "package:flutter/material.dart";
import "package:orbit_standard_library/orbit_standard_library.dart";
import "package:pathfinder/constants.dart";
import "package:pathfinder/models/field.dart";
import "package:pathfinder/models/point.dart";
import "package:pathfinder/models/robot.dart";
import "package:pathfinder/models/robot_on_field.dart";
import "package:pathfinder/models/segment.dart";
import "package:pathfinder/models/spline_point.dart" as modelspath;
import "package:pathfinder/views/editor/point_type.dart";
import "package:pathfinder/views/editor/painter/field_loader.dart";
import "package:pathfinder/views/editor/dragging_point.dart";

const Color _selectedPointHightlightColor = Color(0xffeeeeee);

//TODO: shorten this code, there is a lot of duplicate code
class FieldPainter extends CustomPainter {
  FieldPainter(
    this.robotImage,
    this.fieldImage,
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
    this.robotOnField,
  );
  ui.Image robotImage;
  ui.Image fieldImage;
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
  Optional<RobotOnField> robotOnField;

  @override
  void paint(final Canvas canvas, final Size size) {
    canvas.scale(1, -1);
    canvas.translate(0, -size.height);

    canvas.translate(imageOffset.dx, imageOffset.dy);

    canvas.scale(imageZoom);

    paintImage(
      canvas: canvas,
      fit: BoxFit.fill,
      rect: Rect.fromPoints(Offset.zero, size.bottomRight(Offset.zero)),
      colorFilter:
          ColorFilter.mode(Colors.black.withOpacity(0.5), BlendMode.darken),
      image: fieldImage,
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
      if (segments.length - 1 <
              e.key /* <- Happens when cut segment changes but before new spline is calculated */ ||
          segments[e.key].isHidden) return;

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
        enableHeadingEditing && selectedPoint == null,
        enableControlEditing && selectedPoint == null,
        point.useHeading,
        //TODO: get rid of this lambda function
        () {
          if (point.isStop) return PointType.stop;
          if (index == 0) return PointType.first;
          if (index == points.length - 1) return PointType.last;
          return PointType.regular;
        }(),
      );
    });

    for (final MapEntry<int, FullDraggingPoint> entery
        in dragPoints.asMap().entries) {
      final FullDraggingPoint draggingPoint = entery.value;

      if (!((draggingPoint.index == 0 &&
              draggingPoint.type == PointType.controlIn) ||
          (draggingPoint.index == points.length - 1 &&
              draggingPoint.type == PointType.controlOut))) {
        drawDragPoint(
          canvas,
          points[draggingPoint.index],
          draggingPoint,
        );
      }
    }
    switch (robotOnField) {
      case Some<RobotOnField>(some: final RobotOnField robot):
        drawRobot(canvas, size, robot);
      default:
    }
  }

  void drawPointBackground(
    final Canvas canvas,
    final Offset position,
    final bool isSelected,
    final PointType pointType,
  ) {
    final ui.Color color = pointType.color;

    final Paint paint = Paint()..color = color;
    final ui.Paint highlightPaint = Paint()
      ..color = _selectedPointHightlightColor
      ..maskFilter =
          MaskFilter.blur(BlurStyle.normal, Shadow.convertRadiusToSigma(5));

    // Highlight selected point
    if (isSelected) {
      canvas.drawCircle(
        position,
        pointType.radius,
        highlightPaint,
      );
    }

    canvas.drawCircle(position, pointType.radius, paint);
  }

  void drawDragPoint(
    final Canvas canvas,
    final Point selectedPoint,
    final DraggingPoint dragPoint,
  ) {
    final PointType pointType = dragPoint.type;
    final Paint paint = Paint()..color = pointType.color;

    switch (dragPoint.type) {
      case PointType.first:
      case PointType.stop:
      case PointType.last:
      case PointType.regular:
        canvas.drawCircle(
          dragPoint.position,
          pointType.radius,
          paint,
        );
        break;
      case PointType.controlIn:
      case PointType.controlOut:
        final Offset dragPosition = selectedPoint.position + dragPoint.position;
        canvas.drawCircle(dragPosition, pointType.radius, paint);
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
            pointType);

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
          pointType,
        );
        break;
      default:
    }
  }

  void drawControlPoint(
    final Canvas canvas,
    final PointType pointType,
    final Offset position,
    final Offset control,
    final bool enableEdit,
    final bool isSelected,
  ) {
    final Color color = pointType.color;

    final ui.Paint linePaint = Paint()
      ..style = PaintingStyle.stroke
      ..color = color
      ..strokeWidth = 1;

    final Offset edge =
        Offset(position.dx + control.dx, position.dy + control.dy);
    canvas.drawLine(position, edge, linePaint);

    if (enableEdit) {
      final ui.Paint dotPaint = Paint()..color = color;
      canvas.drawCircle(edge, pointType.radius, dotPaint);
    }
  }

  void drawHeadingLine(
    final Canvas canvas,
    final Offset position,
    final double heading,
    final bool enableEdit,
  ) {
    const PointType pointType = PointType.heading;
    final Offset edge = position + Offset.fromDirection(heading, headingLength);

    final ui.Paint paint = Paint()
      ..style = PaintingStyle.stroke
      ..color = pointType.color
      ..strokeWidth = 3;
    final double circleRadius = 1 / (paint.strokeWidth * paint.strokeWidth);

    canvas.drawLine(position, edge, paint);
    canvas.drawCircle(position, circleRadius, paint);
    canvas.drawCircle(edge, circleRadius, paint);

    if (enableEdit) {
      final ui.Paint dotPaint = Paint()..color = pointType.color;

      canvas.drawCircle(edge, pointType.radius, dotPaint);
    }
  }

  void drawPathPoint(
    final Canvas canvas,
    final Offset position,
    final double heading,
    final Offset inControl,
    final Offset outControl,
    final bool isSelected,
    final bool enableHeadingEditing,
    final bool enableControlEditing,
    final bool useHeading,
    final PointType pointType,
  ) {
    drawPointBackground(
      canvas,
      position,
      isSelected,
      pointType,
    );
    if (useHeading) {
      drawHeadingLine(
        canvas,
        position,
        heading,
        enableHeadingEditing || isSelected,
      );
    }
    if (pointType != PointType.first) {
      drawControlPoint(
        canvas,
        PointType.controlIn,
        position,
        inControl,
        enableControlEditing || isSelected,
        false,
      );
    }
    if (pointType != PointType.last) {
      drawControlPoint(
        canvas,
        PointType.controlOut,
        position,
        outControl,
        enableControlEditing || isSelected,
        false,
      );
    }
  }

  void drawRobot(
    final Canvas canvas,
    final Size size,
    final RobotOnField robot,
  ) {
    final ui.Paint paint = Paint()..isAntiAlias = true;
    const double robotWidth = 0.8;
    const double robotHeight = 0.8;

    final Offset actualPos = robot.pos.scale(
      size.width / officialFieldWidth,
      size.height / officialFieldHeight,
    );

    canvas.translate(actualPos.dx, actualPos.dy);
    final double scaleX =
        (1 / robotImage.width) * (robotWidth / officialFieldWidth) * size.width;

    final double scaleY = (1 / robotImage.height) *
        (robotHeight / officialFieldHeight) *
        size.height;

    final TextPainter textPainter = TextPainter(
      text: TextSpan(
        text: robot.action,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 600,
        ),
      ),
      textDirection: TextDirection.ltr,
    );

    canvas.scale(scaleX, scaleY);

    textPainter.layout();
    canvas.scale(1, -1);
    textPainter.paint(canvas, Offset(0, -robotImage.height.toDouble()));
    canvas.scale(1, -1);

    canvas.rotate(robot.heading);

    canvas.drawImage(
      robotImage,
      Offset(-robotImage.width / 2, -robotImage.height / 2),
      paint,
    );
    canvas.rotate(-robot.heading);
    canvas.scale(1 / scaleX, 1 / scaleY);
    canvas.translate(-robot.pos.dx, -robot.pos.dy);
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
