import "package:flutter/material.dart";
import "package:pathfinder/constants.dart";

class TimelinePoint extends StatelessWidget {
  TimelinePoint({
    required this.onTap,
    required this.color,
    required this.isSelected,
    required this.isStop,
    required this.isFirstPoint,
    required this.isLastPoint,
  });
  final void Function() onTap;
  final Color color;
  static double pointRadius = 10;
  final bool isSelected;
  final bool isStop;
  final bool isFirstPoint;
  final bool isLastPoint;

  @override
  Widget build(final BuildContext context) {
    final Color _color =
        getPointColor(color, isStop, isFirstPoint, isLastPoint, isSelected);

    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 2 * pointRadius,
        height: 2 * pointRadius,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: _color,
          boxShadow: !isSelected
              ? <BoxShadow>[]
              : <BoxShadow>[
                  BoxShadow(
                    blurRadius: selectedPointHighlightRadius,
                    color: color,
                  ),
                ],
        ),
      ),
    );
  }
}
