import 'package:flutter/material.dart';
import 'package:pathfinder/cubic_bezier/cubic_bezier.dart';

class CubicBezierPainter extends CustomPainter {
  final CubicBezier cubicBezier;
  CubicBezierPainter({required this.cubicBezier});

  static final paintColor = Paint()
    ..style = PaintingStyle.stroke
    ..color = Colors.white
    ..strokeWidth = 10;

  static final double circleRadius =
      1 / (paintColor.strokeWidth * paintColor.strokeWidth);

  @override
  void paint(final Canvas canvas, final Size size) {
    final paintPath = Path();

    paintPath.moveTo(this.cubicBezier.start.dx, this.cubicBezier.start.dy);

    canvas.drawCircle(cubicBezier.start, circleRadius, paintColor);
    canvas.drawCircle(cubicBezier.end, circleRadius, paintColor);

    paintPath.cubicTo(
      this.cubicBezier.startControl.dx,
      this.cubicBezier.startControl.dy,
      this.cubicBezier.endControl.dx,
      this.cubicBezier.endControl.dy,
      this.cubicBezier.end.dx,
      this.cubicBezier.end.dy,
    );

    canvas.drawPath(paintPath, paintColor);
  }

  @override
  bool shouldRepaint(final CubicBezierPainter old) =>
      old.cubicBezier != this.cubicBezier;
}
