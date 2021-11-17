import 'package:flutter/material.dart';

class HeadingLinePainter extends CustomPainter {
  final Offset position;
  final double heading;

  HeadingLinePainter({
    required final this.position,
    required final this.heading,
  }) : lineEnd = position + Offset.fromDirection(heading, magnitude);

  static const double magnitude = 25;

  final Offset lineEnd;

  static final paintColor = Paint()
    ..style = PaintingStyle.stroke
    ..color = const Color(0xffc80000)
    ..strokeWidth = 5;

  static final double circleRadius =
      1 / (paintColor.strokeWidth * paintColor.strokeWidth);

  @override
  void paint(final Canvas canvas, final Size size) {
    canvas.drawLine(position, lineEnd, paintColor);

    canvas.drawCircle(position, circleRadius, paintColor);
    canvas.drawCircle(lineEnd, circleRadius, paintColor);
  }

  @override
  bool shouldRepaint(final HeadingLinePainter old) => true;
}
