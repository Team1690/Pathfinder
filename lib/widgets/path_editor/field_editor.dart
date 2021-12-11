import 'dart:async';
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pathfinder/models/point.dart';

enum PointType {
  path,
  control,
  heading
}

class PointSettings {
  final Color color;
  final double radius;

  PointSettings(
    this.color,
    this.radius
  );
}

Map<PointType, PointSettings> pointSettings = {
  PointType.path: PointSettings(Color(0xbbdddddd), 10),
  PointType.control: PointSettings(Color(0xff111111), 7),
  PointType.heading: PointSettings(Color(0xffc80000), 7)
};

class FieldPainter extends CustomPainter {
  ui.Image image;
  List<Point> points;

  FieldPainter(
    this.image,
    this.points,
  );

  void drawPointBackground(Canvas canvas, Offset position) {
    final PointSettings currentPointSettings = pointSettings[PointType.path]!;
    final Paint paint = Paint()
      ..color = currentPointSettings.color;
    canvas.drawCircle(position, currentPointSettings.radius, paint);
  }

  void drawControlPoint(Canvas canvas, Offset position, Offset control, bool enableEdit) {
    final Color color = Color(0xff111111);

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

      canvas.drawCircle(edge, 5, dotPaint);
    }
  }

  void drawHeadingLine(Canvas canvas, Offset position, double heading, enableEdit) {
    final Color color = Color(0xffc80000);
    final double headingLength = 20;
    final Offset edge = position + Offset.fromDirection(heading, headingLength);

    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..color = color
      ..strokeWidth = 5;
    final double circleRadius =
      1 / (paint.strokeWidth * paint.strokeWidth);

    canvas.drawLine(position, edge, paint);
    canvas.drawCircle(position, circleRadius, paint);
    canvas.drawCircle(edge, circleRadius, paint);

    if (enableEdit) {
      final dotPaint = Paint()
        ..color = color;

      canvas.drawCircle(edge, 5, dotPaint);
    }
  }

  void drawPathPoint(Canvas canvas, Offset position, double heading, Offset inControl, Offset OutControl) {
    drawPointBackground(canvas, position);
    drawHeadingLine(canvas, position, heading, true);
    drawControlPoint(canvas, position, inControl, true);
    drawControlPoint(canvas, position, OutControl, true);

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
      drawPathPoint(canvas, point.position, point.heading, point.inControlPoint, point.outControlPoint);
    }
    // canvas.drawCircle(Offset(600, 0), 10, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    // TODO: implement shouldRepaint
    return true;
  }
}

class FieldLoader extends StatefulWidget {
  List<Point> points;

  FieldLoader(this.points);

  @override
  _FieldLoaderState createState() => _FieldLoaderState();
}

class _FieldLoaderState extends State<FieldLoader> {
  late ui.Image image;
  bool isImageloaded = false;
  void initState() {
    super.initState();
    init();
  }

  Future <Null> init() async {
    final ByteData data = await rootBundle.load('assets/images/frc_2020_field.png');
    image = await loadImage(Uint8List.view(data.buffer));
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
      return Container(
        child: CustomPaint(
          painter: FieldPainter(image, widget.points),
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