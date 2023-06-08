import "package:flutter/material.dart";
import "package:pathfinder/utils/cubic_bezier/cubic_bezier.dart";

class CubicBezierPainter extends CustomPainter {
  CubicBezierPainter({required this.cubicBezier});
  final CubicBezier cubicBezier;

  static final Paint paintColor = Paint()
    ..style = PaintingStyle.stroke
    ..color = Colors.white
    ..strokeWidth = 10;

  static final double circleRadius =
      1 / (paintColor.strokeWidth * paintColor.strokeWidth);

  @override
  void paint(final Canvas canvas, final Size size) {
    final Path paintPath = Path();

    paintPath.moveTo(cubicBezier.start.dx, cubicBezier.start.dy);

    canvas.drawCircle(cubicBezier.start, circleRadius, paintColor);
    canvas.drawCircle(cubicBezier.end, circleRadius, paintColor);

    paintPath.cubicTo(
      cubicBezier.startControl.dx,
      cubicBezier.startControl.dy,
      cubicBezier.endControl.dx,
      cubicBezier.endControl.dy,
      cubicBezier.end.dx,
      cubicBezier.end.dy,
    );

    canvas.drawPath(paintPath, paintColor);
  }

  @override
  bool shouldRepaint(final CubicBezierPainter old) =>
      old.cubicBezier != cubicBezier;
}
