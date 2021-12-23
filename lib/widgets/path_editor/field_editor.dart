import 'dart:async';
import 'dart:math';
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pathfinder/constants.dart';
import 'package:pathfinder/models/point.dart';
import 'package:pathfinder/models/robot.dart';
import 'package:pathfinder/widgets/path_editor/path_editor.dart';

enum PointType {
  path,
  inControl,
  outControl,
  heading,
}

class PointSettings {
  final Color color;
  final double radius;

  PointSettings(this.color, this.radius);
}

const double headingLength = 50;

Map<PointType, PointSettings> pointSettings = {
  PointType.path: PointSettings(Color(0xbbdddddd), 10),
  PointType.inControl: PointSettings(Colors.yellow, 7),
  PointType.outControl: PointSettings(Colors.yellow, 7),
  PointType.heading: PointSettings(Color(0xffc80000), 7)
};

class FieldPainter extends CustomPainter {
  ui.Image image;
  List<Point> points;
  int? selectedPoint;
  List<FullDraggingPoint> dragPoints;
  bool enableHeadingEditing;
  bool enableControlEditing;
  List<Offset>? evaluetedPoints;
  Robot robot;

  FieldPainter(
    this.image,
    this.points,
    this.selectedPoint,
    this.dragPoints,
    this.enableHeadingEditing,
    this.enableControlEditing,
    this.evaluetedPoints,
    this.robot,
  );

  void drawPointBackground(
    Canvas canvas,
    Offset position,
    bool isSelected,
    bool isStopPoint,
    bool isFirstPoint,
    bool isLastPoint,
  ) {
    final PointSettings currentPointSettings = pointSettings[PointType.path]!;

    var color = currentPointSettings.color;
    var selectedColor = selectedPointColor;

    if (isStopPoint) {
      selectedColor = selectedStopPointColor;
      color = stopPointColor;
    } else if (isFirstPoint) {
      selectedColor = Color(0xff34A853).withGreen(230);
      color = Color(0xff34A853);
    } else if (isLastPoint) {
      selectedColor = Color(0xffAE4335).withRed(230);
      color = Color(0xffAE4335);
    }

    final Paint paint = Paint()..color = isSelected ? selectedColor : color;
    final highlightPaint = Paint()
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
    Canvas canvas,
    Point selectedPoint,
    DraggingPoint dragPoint,
  ) {
    final PointSettings currentPointSettings = pointSettings[dragPoint.type]!;
    final Paint paint = Paint()..color = currentPointSettings.color;

    switch (dragPoint.type) {
      case PointType.path:
        canvas.drawCircle(
            dragPoint.position, currentPointSettings.radius, paint);
        break;
      case PointType.inControl:
        continue control;
      control:
      case PointType.outControl:
        Offset dragPosition = selectedPoint.position + dragPoint.position;
        canvas.drawCircle(dragPosition, currentPointSettings.radius, paint);
        drawControlPoint(
            canvas, selectedPoint.position, dragPoint.position, false, true);
        drawPointBackground(
            canvas,
            Offset(selectedPoint.position.dx + dragPoint.position.dx,
                selectedPoint.position.dy + dragPoint.position.dy),
            true,
            false,
            false,
            false);

        break;
      case PointType.heading:
        Offset dragPosition = dragPoint.position;
        double dragHeading = dragPosition.direction;
        drawHeadingLine(canvas, selectedPoint.position, dragHeading, false);
        drawPointBackground(
            canvas,
            selectedPoint.position +
                Offset.fromDirection(dragHeading, headingLength),
            true,
            false,
            false,
            false);
        break;
      default:
    }
    if (dragPoint.type == PointType.path) {
    } else {}
  }

  void drawControlPoint(
    Canvas canvas,
    Offset position,
    Offset control,
    bool enableEdit,
    bool isSelected,
  ) {
    final PointSettings settings = pointSettings[PointType.inControl]!;
    final Color color = settings.color;

    final linePaint = Paint()
      ..style = PaintingStyle.stroke
      ..color = color
      ..strokeWidth = 1;

    final Offset edge =
        Offset(position.dx + control.dx, position.dy + control.dy);
    canvas.drawLine(position, edge, linePaint);

    if (enableEdit) {
      final dotPaint = Paint()..color = color;
      canvas.drawCircle(edge, settings.radius, dotPaint);
    }
  }

  void drawHeadingLine(
      Canvas canvas, Offset position, double heading, enableEdit) {
    final PointSettings pointSetting = pointSettings[PointType.heading]!;
    final Offset edge = position + Offset.fromDirection(heading, headingLength);

    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..color = pointSetting.color
      ..strokeWidth = 3;
    final double circleRadius = 1 / (paint.strokeWidth * paint.strokeWidth);

    canvas.drawLine(position, edge, paint);
    canvas.drawCircle(position, circleRadius, paint);
    canvas.drawCircle(edge, circleRadius, paint);

    if (enableEdit) {
      final dotPaint = Paint()..color = pointSetting.color;

      canvas.drawCircle(edge, pointSetting.radius, dotPaint);
    }
  }

  void drawPathPoint(
    Canvas canvas,
    Offset position,
    double heading,
    Offset inControl,
    Offset outControl,
    bool isSelected,
    bool isStopPoint,
    bool enableHeadingEditing,
    bool enableControlEditing,
    bool isFirstPoint,
    bool isLastPoint,
  ) {
    drawPointBackground(
        canvas, position, isSelected, isStopPoint, isFirstPoint, isLastPoint);
    drawHeadingLine(canvas, position, heading, enableHeadingEditing);
    if (!isFirstPoint) {
      drawControlPoint(
          canvas, position, inControl, enableControlEditing, false);
    }
    if (!isLastPoint) {
      drawControlPoint(
          canvas, position, outControl, enableControlEditing, false);
    }
  }

  void drawPath(Canvas canvas, List<Offset> evaluetedPoints) {
    Paint paint = Paint()
      ..color = getSegmentColor(0)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;

    List<Offset> pathPoints = [];
    for (Offset splinePoint in evaluetedPoints) {
      pathPoints.add(splinePoint);
    }

    Path path = Path();
    path.addPolygon(pathPoints, false);
    canvas.drawPath(path, paint);
  }

  void drawPathShadow(Canvas canvas, List<Offset> evaluetedPoints) {
    Paint paint = Paint()
      ..color = Colors.black
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2
      ..maskFilter = MaskFilter.blur(BlurStyle.normal, 4);

    List<Offset> pathPoints = [];
    for (Offset splinePoint in evaluetedPoints) {
      pathPoints.add(splinePoint);
    }

    Path path = Path();
    path.addPolygon(pathPoints, false);
    canvas.drawPath(path, paint);
  }

  void drawWheelsPath(Canvas canvas, List<Offset> evaluetedPoints) {
    double robotWidth = robot.width;

    Paint paint = Paint()
      ..color = white.withOpacity(0.5)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;

    if (evaluetedPoints.length > 0) {
      List<Offset> leftPoints =
          evaluetedPoints.sublist(1).asMap().entries.map((e) {
        final Offset dist = evaluetedPoints[e.key + 1] - evaluetedPoints[e.key];
        return Offset.fromDirection(dist.direction - 0.5 * pi, robotWidth / 2)
            .translate(
                evaluetedPoints[e.key + 1].dx, evaluetedPoints[e.key + 1].dy);
      }).toList();
      List<Offset> rightPoints =
          evaluetedPoints.sublist(1).asMap().entries.map((e) {
        final Offset dist = evaluetedPoints[e.key + 1] - evaluetedPoints[e.key];
        return Offset.fromDirection(dist.direction + 0.5 * pi, robotWidth / 2)
            .translate(
                evaluetedPoints[e.key + 1].dx, evaluetedPoints[e.key + 1].dy);
      }).toList();

      // inspect(pathPoints);
      Path leftPath = Path();
      Path rightPath = Path();

      leftPath.addPolygon(leftPoints, false);
      canvas.drawPath(leftPath, paint);

      rightPath.addPolygon(rightPoints, false);
      canvas.drawPath(rightPath, paint);
    }
  }

  @override
  void paint(Canvas canvas, Size size) {
    paintImage(
        canvas: canvas,
        fit: BoxFit.fill,
        rect: Rect.fromPoints(Offset.zero, size.bottomRight(Offset.zero)),
        colorFilter:
            ColorFilter.mode(Colors.black.withOpacity(0.5), BlendMode.darken),
        image: image);

    if (evaluetedPoints != null) {
      drawPathShadow(canvas, evaluetedPoints!);
      drawPath(canvas, evaluetedPoints!);
      drawWheelsPath(canvas, evaluetedPoints!);
    }

    for (final entery in points.asMap().entries) {
      int index = entery.key;
      Point point = entery.value;
      drawPathPoint(
          canvas,
          point.position,
          point.heading,
          point.inControlPoint,
          point.outControlPoint,
          index == selectedPoint,
          point.isStop,
          enableHeadingEditing,
          enableControlEditing,
          index == 0,
          index == points.length - 1);
    }

    for (final entery in dragPoints.asMap().entries) {
      FullDraggingPoint draggingPoint = entery.value;
      int index = entery.key;

      if (!((draggingPoint.index == 0 &&
              draggingPoint.draggingPoint.type == PointType.inControl) ||
          (draggingPoint.index == points.length - 1 &&
              draggingPoint.draggingPoint.type == PointType.outControl))) {
        drawDragPoint(
            canvas, points[draggingPoint.index], draggingPoint.draggingPoint);
      }
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    // TODO: implement shouldRepaint
    return true;
  }
}

class FieldLoader extends StatefulWidget {
  List<Point> points;
  int? selectedPoint;
  List<FullDraggingPoint> dragPoints;
  bool enableHeadingEditing;
  bool enableControlEditing;
  List<Offset>? evaluatedPoints;
  Function(Offset) setFieldSizePixels;
  Robot robot;

  FieldLoader(
      this.points,
      this.selectedPoint,
      this.dragPoints,
      this.enableHeadingEditing,
      this.enableControlEditing,
      this.evaluatedPoints,
      this.setFieldSizePixels,
      this.robot);

  @override
  _FieldLoaderState createState() => _FieldLoaderState();
}

ui.Image? globalImage;

class _FieldLoaderState extends State<FieldLoader> {
  bool isImageloaded = globalImage != null;
  void initState() {
    super.initState();
    init();
  }

  Future<Null> init() async {
    if (globalImage != null) {
      return;
    }

    final ByteData data =
        await rootBundle.load('assets/images/frc_2020_field.png');
    globalImage = await loadImage(Uint8List.view(data.buffer));
  }

  Future<ui.Image> loadImage(Uint8List img) async {
    final Completer<ui.Image> completer = Completer();
    ui.decodeImageFromList(img, (ui.Image img) {
      setState(() {
        isImageloaded = true;
      });
      return completer.complete(img);
    });
    return completer.future;
  }

  Widget _buildImage() {
    double width = 0.7 * MediaQuery.of(context).size.width;
    double height = 0.6 * MediaQuery.of(context).size.height;
    widget.setFieldSizePixels(Offset(width, height));

    if (this.isImageloaded) {
      // if (false) {
      return Container(
          decoration: BoxDecoration(boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.5),
              spreadRadius: 2,
              blurRadius: 14,
              offset: Offset(0, 4), // changes position of shadow
            ),
          ]),
          child: CustomPaint(
              painter: FieldPainter(
                globalImage!,
                widget.points,
                widget.selectedPoint,
                widget.dragPoints,
                widget.enableHeadingEditing,
                widget.enableControlEditing,
                widget.evaluatedPoints,
                widget.robot,
              ),
              size: Size(width, height)));
    } else {
      return Center(child: Text('loading'));
    }
  }

  @override
  Widget build(BuildContext context) {
    return _buildImage();
  }
}
