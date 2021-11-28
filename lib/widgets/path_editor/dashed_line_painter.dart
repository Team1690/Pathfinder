import 'package:flutter/material.dart';

class DashedLinePainter extends CustomPainter {
  final Offset start, end;
  final double dashLength, spaceLength;
  final double direction;
  late final Offset dashRelativeOffset;
  late final Offset spaceRelativeOffset;

  DashedLinePainter({
    required this.start,
    required this.end,
    this.dashLength = 12,
    this.spaceLength = 6,
  }) : direction = (end - start).direction {
    this.dashRelativeOffset = Offset.fromDirection(direction, dashLength);
    this.spaceRelativeOffset = Offset.fromDirection(direction, spaceLength);
  }

  static final paintColor = Paint()
    ..style = PaintingStyle.stroke
    ..color = const Color(0xff111111)
    ..strokeWidth = 3;

  @override
  void paint(final Canvas canvas, final Size size) {
    final paintPath = Path();

    Offset dashStartPosition = start;

    while (true) {
      final Offset dashEndPosition = dashStartPosition + dashRelativeOffset;

      if ((end - dashEndPosition).direction.toStringAsFixed(5) !=
          this.direction.toStringAsFixed(5)) break;

      paintPath.moveTo(dashStartPosition.dx, dashStartPosition.dy);
      paintPath.lineTo(dashEndPosition.dx, dashEndPosition.dy);

      dashStartPosition = dashEndPosition + spaceRelativeOffset;
    }

    canvas.drawPath(paintPath, paintColor);
  }

  @override
  bool shouldRepaint(final DashedLinePainter old) =>
      old.start != this.start || old.end != this.end;
}
