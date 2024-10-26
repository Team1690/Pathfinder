import "package:flutter/material.dart";
import "package:pathfinder_gui/views/editor/point_type.dart";

//TODO: see if you can merge this with other const
const double _timelinePointDiameter = 20;
const double _selectedPointHighlightRadius = 5;

class TimelinePoint extends StatelessWidget {
  TimelinePoint({
    required this.onTap,
    required this.isSelected,
    required this.pointType,
  });
  final void Function() onTap;
  final bool isSelected;
  final PointType pointType;

  @override
  Widget build(final BuildContext context) => GestureDetector(
        onTap: onTap,
        child: Container(
          width: _timelinePointDiameter,
          height: _timelinePointDiameter,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: pointType.getPointColor(isSelected),
            boxShadow: !isSelected
                ? <BoxShadow>[]
                : <BoxShadow>[
                    BoxShadow(
                      blurRadius: _selectedPointHighlightRadius,
                      color: pointType.color,
                    ),
                  ],
          ),
        ),
      );
}
