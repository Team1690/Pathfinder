import 'package:flutter/material.dart';

class PathPainter extends CustomPainter {
  final List<Offset> points;
  const PathPainter({required this.points});

  @override
  void paint(final Canvas canvas, final Size size) {
    final paintPath = Path();
    final paintColor = Paint()
      ..style = PaintingStyle.stroke
      ..color = Color(0xff333333)
      ..strokeWidth = 10;

    paintPath.moveTo(this.points.first.dx, this.points.first.dy);

    final double circleRadius = 1 / paintColor.strokeWidth;

    canvas.drawCircle(points.first, circleRadius, paintColor);
    canvas.drawCircle(points.last, circleRadius, paintColor);

    paintPath.cubicTo(
      this.points[1].dx,
      this.points[1].dy,
      this.points[2].dx,
      this.points[2].dy,
      this.points[3].dx,
      this.points[3].dy,
    );

    canvas.drawPath(paintPath, paintColor);
  }

  @override
  bool shouldRepaint(CustomPainter old) => true;
}
