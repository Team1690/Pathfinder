import 'package:flutter/material.dart';
import 'package:pathfinder/constants.dart';

class PathTimeline extends StatelessWidget {
  final List<TimeLineSegment> segments;
  final List<TimelinePoint> points;
  final void Function(int, int) insertPoint;

  const PathTimeline({
    Key? key,
    required this.segments,
    required this.insertPoint,
    required this.points,
  }) : super(key: key);

  int findSegment(int pointIndex, List<TimeLineSegment> segments) {
    List<int> segmentsLength = segments.map((e) => e.pointAmount).toList();

    int segmentIndex = 0;
    for (int i = 0; i < segments.length; i++) {
      if (pointIndex + 1 > segmentsLength[i]) {
        pointIndex -= segmentsLength[i];
      } else {
        segmentIndex = i;
        break;
      }
    }
    return segmentIndex;
  }

  @override
  Widget build(BuildContext context) {
    return segments.length > 0
        ? Stack(
            alignment: Alignment.centerLeft,
            children: [
              //segments
              Row(
                children: segments
                    .asMap()
                    .entries
                    .map(((e) => Expanded(
                        flex: segments.length - 1 == e.key
                            ? e.value.pointAmount - 1
                            : e.value.pointAmount,
                        child: e.value)))
                    .toList(),
              ),
              //points
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(height: 40),
                  SizedBox(height: 5),
                  Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: points),
                ],
              ),
              //hover points
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(height: 40),
                  SizedBox(height: 5),
                  Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: points
                          .asMap()
                          .entries
                          .map((e) => AddPointInsideTimeline(
                                onClick: () => insertPoint(
                                    findSegment(e.key, segments), e.key + 1),
                              ))
                          .toList()
                        ..removeLast())
                ],
              ),
            ],
          )
        : Container();
  }
}

class AddPointInsideTimeline extends StatefulWidget {
  const AddPointInsideTimeline({
    Key? key,
    required this.onClick,
  }) : super(key: key);

  final void Function() onClick;

  @override
  _AddPointInsideTimelineState createState() => _AddPointInsideTimelineState();
}

class _AddPointInsideTimelineState extends State<AddPointInsideTimeline> {
  bool visibility = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onHover: (event) => setState(() => visibility = true),
      onExit: (event) => setState(() => visibility = false),
      child: Visibility(
        maintainSize: true,
        maintainAnimation: true,
        maintainState: true,
        visible: visibility,
        child: IconButton(
          onPressed: () {
            widget.onClick();
          },
          icon: Icon(Icons.circle),
        ),
      ),
    );
  }
}

class TimelinePoint extends StatelessWidget {
  final void Function() onTap;
  final Color color;
  static double pointRadius = 10;
  final bool isSelected;
  final bool isStop;
  final bool isFirstPoint;
  final bool isLastPoint;

  TimelinePoint({
    required this.onTap,
    required this.color,
    required this.isSelected,
    required this.isStop,
    required this.isFirstPoint,
    required this.isLastPoint,
  });

  @override
  Widget build(BuildContext context) {
    final _color =
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
              ? []
              : [
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

class TimeLineSegment extends StatefulWidget {
  final int pointAmount;
  final bool isHidden;
  final Function() onHidePressed;
  final Color color;
  final double velocity;
  final Function(double) onChange;
  static double segmentWidth = 300;
  static double segmentHeight = 50;

  TimeLineSegment({
    Key? key,
    required this.pointAmount,
    required this.isHidden,
    required this.onHidePressed,
    required this.color,
    required this.velocity,
    required this.onChange,
  }) : super(key: key);

  @override
  _TimeLineSegmentState createState() => _TimeLineSegmentState();
}

class _TimeLineSegmentState extends State<TimeLineSegment> {
  final TextEditingController _velocityFieldController =
      TextEditingController(text: '');

  @override
  void initState() {
    super.initState();
    _velocityFieldController.text = widget.velocity.toString();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    _velocityFieldController.selection = TextSelection.fromPosition(
        TextPosition(offset: _velocityFieldController.text.length));

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            ConstrainedBox(
              constraints: BoxConstraints.tightFor(width: 40, height: 40),
              child: TextField(
                controller: _velocityFieldController,
                keyboardType: TextInputType.text,
                decoration: InputDecoration(
                  hintText: 'm/s',
                  errorText:
                      double.tryParse(_velocityFieldController.text) == null
                          ? 'Error'
                          : null,
                ),
                onChanged: (value) {
                  widget.onChange(double.tryParse(value) ?? widget.velocity);
                  _velocityFieldController.text = value;
                },
                textAlign: TextAlign.center,
              ),
            ),
            IconButton(
              iconSize: 20,
              color: theme.textTheme.displaySmall?.color,
              onPressed: widget.onHidePressed,
              icon: Icon(widget.isHidden
                  ? Icons.remove_red_eye_outlined
                  : Icons.remove_red_eye),
            ),
          ],
        ),
        SizedBox(height: 5),
        Stack(alignment: Alignment.center, children: [
          Container(
              height: TimeLineSegment.segmentHeight,
              decoration: BoxDecoration(
                color: gray,
                border: Border.all(color: primary, width: 4),
                borderRadius: BorderRadius.all(Radius.circular(defaultRadius)),
              )),
          Container(
            height: 2,
            color: widget.color,
          ),
        ]),
      ],
    );
  }
}
