import 'dart:async';
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pathfinder/models/point.dart';
import 'package:pathfinder/rpc/protos/PathFinder.pb.dart' as pro;
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

  PointSettings(
    this.color,
    this.radius
  );
}

const double headingLength = 30;

Map<PointType, PointSettings> pointSettings = {
  PointType.path: PointSettings(Color(0xbbdddddd), 10),
  PointType.inControl: PointSettings(Color(0xff111111), 7),
  PointType.outControl: PointSettings(Color(0xff111111), 7),
  PointType.heading: PointSettings(Color(0xffc80000), 7)
};

class FieldPainter extends CustomPainter {
  ui.Image image;
  List<Point> points;
  int? selectedPoint;
  DraggingPoint? dragPoint;
  bool enableHeadingEditing;
  bool enableControlEditing;
  List<pro.SplineResponse_Point>? evaluetedPoints;

  FieldPainter(
    this.image,
    this.points,
    this.selectedPoint,
    this.dragPoint,
    this.enableHeadingEditing,
    this.enableControlEditing,
    this.evaluetedPoints,
  );

  void drawPointBackground(Canvas canvas, Offset position, bool isSelected) {
    final PointSettings currentPointSettings = pointSettings[PointType.path]!;
    Color selectedColor = Color(0xffeeeeee);
    final Paint paint = Paint()
      ..color = isSelected ? selectedColor : currentPointSettings.color;
    canvas.drawCircle(position, currentPointSettings.radius, paint);
  }

  void drawDragPoint(Canvas canvas, Point selectedPoint, DraggingPoint dragPoint) {
    final PointSettings currentPointSettings = pointSettings[dragPoint.type]!;
    final Paint paint = Paint()
      ..color = currentPointSettings.color;

    switch (dragPoint.type) {
      case PointType.path:
        canvas.drawCircle(dragPoint.position, currentPointSettings.radius, paint);
        break;
      case PointType.inControl:
        continue control;
      control:
      case PointType.outControl:
        Offset dragPosition = selectedPoint.position + dragPoint.position;
        canvas.drawCircle(dragPosition, currentPointSettings.radius, paint);
        drawControlPoint(canvas, selectedPoint.position, dragPoint.position, false);
        break;
      case PointType.heading:
        Offset dragPosition = dragPoint.position;
        double dragHeading = dragPosition.direction;
        drawHeadingLine(canvas, selectedPoint.position, dragHeading, false);
        break;
      default:
    }
    if (dragPoint.type == PointType.path) {
    } else {
    }
  }

  void drawControlPoint(Canvas canvas, Offset position, Offset control, bool enableEdit) {
    final PointSettings settings = pointSettings[PointType.inControl]!;
    final Color color = settings.color;

    final linePaint = Paint()
      ..style = PaintingStyle.stroke
      ..color = color
      ..strokeWidth = 2;

    final Offset edge = Offset(position.dx + control.dx, position.dy + control.dy);
    canvas.drawLine(
      position,
      edge,
      linePaint
    );

    if (enableEdit) {
      final dotPaint = Paint()
        ..color = color;

      canvas.drawCircle(edge, settings.radius, dotPaint);
    }
  }

  void drawHeadingLine(Canvas canvas, Offset position, double heading, enableEdit) {
    final PointSettings pointSetting = pointSettings[PointType.heading]!;
    final Offset edge = position + Offset.fromDirection(heading, headingLength);

    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..color = pointSetting.color
      ..strokeWidth = 5;
    final double circleRadius =
      1 / (paint.strokeWidth * paint.strokeWidth);

    canvas.drawLine(position, edge, paint);
    canvas.drawCircle(position, circleRadius, paint);
    canvas.drawCircle(edge, circleRadius, paint);

    if (enableEdit) {
      final dotPaint = Paint()
        ..color = pointSetting.color;

      canvas.drawCircle(edge, pointSetting.radius, dotPaint);
    }
  }

  void drawPathPoint(Canvas canvas, Offset position, double heading, Offset inControl, Offset OutControl, bool isSelected, bool enableHeadingEditing, enableControlEditing) {
    drawPointBackground(canvas, position, isSelected);
    drawHeadingLine(canvas, position, heading, enableHeadingEditing && isSelected);
    if (isSelected) {
      drawControlPoint(canvas, position, inControl, enableControlEditing);
      drawControlPoint(canvas, position, OutControl, enableControlEditing);
    }
  }

  void drawPath(Canvas canvas, List<pro.SplineResponse_Point> evaluetedPoints) {
    Paint paint = Paint()
      ..color = Color(0xff00ddee)
      ..strokeWidth = 5;

    List<Offset> pathPoints = [];
    for (pro.SplineResponse_Point splinePoint in evaluetedPoints) {
      pathPoints.add(Offset(splinePoint.point.x, splinePoint.point.y));
    }
    Path path = Path();
    path.addPolygon([], false);
    print("Drawing path ${path}");
    canvas.drawPath(path, paint);
  }

  @override
  void paint(Canvas canvas, Size size) {
    paintImage(
      canvas: canvas, 
      rect: Rect.fromPoints(Offset.zero, size.bottomRight(Offset.zero)),
      fit: BoxFit.fill,
      image: image
    );

    for (final entery in points.asMap().entries) {
      int index = entery.key;
      Point point = entery.value;
      drawPathPoint(canvas, point.position, point.heading, point.inControlPoint, point.outControlPoint, index == selectedPoint, enableHeadingEditing, enableControlEditing);
    }

    if (dragPoint != null && selectedPoint != null) {
      drawDragPoint(canvas, points[selectedPoint!], dragPoint!);
    }

    if (evaluetedPoints != null) {
      drawPath(canvas, evaluetedPoints!);
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
  DraggingPoint? dragPoint;
  bool enableHeadingEditing;
  bool enableControlEditing;
  List<pro.SplineResponse_Point>? evaluatedPoints;

  FieldLoader(
    this.points,
    this.selectedPoint,
    this.dragPoint,
    this.enableHeadingEditing,
    this.enableControlEditing,
    this.evaluatedPoints,
  );

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

  Future <Null> init() async {
    final ByteData data = await rootBundle.load('assets/images/frc_2020_field.png');
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
    double width = 0.8 * MediaQuery.of(context).size.width;
    double height = 0.6 * MediaQuery.of(context).size.height;

    if (this.isImageloaded) {
    // if (false) {
      return Container(
        child: CustomPaint(
          painter: FieldPainter(
            globalImage!,
            widget.points,
            widget.selectedPoint,
            widget.dragPoint,
            widget.enableHeadingEditing,
            widget.enableControlEditing,
            widget.evaluatedPoints,
          ),
          size: Size(width, height)
        )
      );
    } else {
      return Center(child: Text('loading'));
    }
  }
  @override
  Widget build(BuildContext context) {
    return _buildImage();
  }
}
