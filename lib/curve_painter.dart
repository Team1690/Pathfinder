import 'package:flutter/material.dart';

class CurvePainter extends CustomPainter {
  final List<Offset> points;
  const CurvePainter({required this.points}) : super();

  @override
  void paint(Canvas canvas, Size size) {
    var paintPath = Path();
    var paintColor = Paint()
      ..style = PaintingStyle.stroke
      ..color = Color(0xff0000c8)
      ..strokeWidth = 10;

    paintPath.moveTo(this.points[0].dx, this.points[0].dy);

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
