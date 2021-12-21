import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:pathfinder/constants.dart';
import 'package:pathfinder/models/point.dart';

class PathTimeline extends StatelessWidget {
  final List<TimeLineSegment> segments;
  final List<TimelinePoint> points;
  final void Function(int, int) insertPoint;

  const PathTimeline(
      {Key? key,
      required this.segments,
      required this.insertPoint,
      required this.points})
      : super(key: key);

  int findSegment(int pointIndex, List<TimeLineSegment> segments) {
    List<int> segmentsLength = segments.map((e) => e.points.length).toList();

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
                            ? e.value.points.length - 1
                            : e.value.points.length,
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
          icon: Icon(Icons.add_circle_outline_rounded),
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

  TimelinePoint({
    required this.onTap,
    required this.color,
    required this.isSelected,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 2 * pointRadius,
        height: 2 * pointRadius,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: isSelected ? selectedPointColor : color,
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
  TimeLineSegment({
    Key? key,
    required this.points,
    required this.color,
    required this.velocity,
    required this.onChange,
  }) : super(key: key);

  final List<TimelinePoint> points;
  final Color color;
  final double velocity;
  final Function(double) onChange;
  static double segmentWidth = 300;
  static double segmentHeight = 50;

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
    _velocityFieldController.selection = TextSelection.fromPosition(
        TextPosition(offset: _velocityFieldController.text.length));

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        ConstrainedBox(
          constraints: BoxConstraints.tightFor(width: 40, height: 40),
          child: TextField(
            controller: _velocityFieldController,
            keyboardType: TextInputType.text,
            onChanged: (value) {
              widget.onChange(double.tryParse(value) ?? widget.velocity);
              _velocityFieldController.text = value;
            },
            textAlign: TextAlign.center,
            decoration: InputDecoration(
              // border: OutlineInputBorder(),
              hintText: 'm/s',
            ),
          ),
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
