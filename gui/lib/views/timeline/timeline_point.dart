import "package:flutter/material.dart";
import "package:pathfinder/point_type.dart";

//TODO: i don't like consts for single files see if you can merge this with other const
const double _timelinePointRadius = 10;
const double _selectedPointHighlightRadius = 5;

//TODO: concise
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
          width: 2 * _timelinePointRadius,
          height: 2 * _timelinePointRadius,
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
