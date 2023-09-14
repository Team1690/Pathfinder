import "package:flutter/material.dart";
import "package:flutter/src/gestures/events.dart";
import "package:pathfinder/constants.dart";

class PathTimeline extends StatelessWidget {
  const PathTimeline({
    final Key? key,
    required this.segments,
    required this.insertPoint,
    required this.points,
  }) : super(key: key);
  final List<TimeLineSegment> segments;
  final List<TimelinePoint> points;
  final void Function(int, int) insertPoint;

  int findSegment(int pointIndex, final List<TimeLineSegment> segments) {
    final List<int> segmentsLength =
        segments.map((final TimeLineSegment e) => e.pointAmount).toList();

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
  Widget build(final BuildContext context) => segments.isNotEmpty
      ? Stack(
          alignment: Alignment.centerLeft,
          children: <Widget>[
            //segments
            Row(
              children: segments
                  .asMap()
                  .entries
                  .map(
                    ((final MapEntry<int, TimeLineSegment> e) => Expanded(
                          flex: segments.length - 1 == e.key
                              ? e.value.pointAmount - 1
                              : e.value.pointAmount,
                          child: e.value,
                        )),
                  )
                  .toList(),
            ),
            //points
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                const SizedBox(height: 40),
                const SizedBox(height: 5),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: points,
                ),
              ],
            ),
            //hover points
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                const SizedBox(height: 40),
                const SizedBox(height: 5),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: points
                      .asMap()
                      .entries
                      .map(
                        (final MapEntry<int, TimelinePoint> e) =>
                            AddPointInsideTimeline(
                          onClick: () => insertPoint(
                            findSegment(e.key, segments),
                            e.key + 1,
                          ),
                        ),
                      )
                      .toList()
                    ..removeLast(),
                ),
              ],
            ),
          ],
        )
      : Container();
}

class AddPointInsideTimeline extends StatefulWidget {
  const AddPointInsideTimeline({
    final Key? key,
    required this.onClick,
  }) : super(key: key);

  final void Function() onClick;

  @override
  _AddPointInsideTimelineState createState() => _AddPointInsideTimelineState();
}

class _AddPointInsideTimelineState extends State<AddPointInsideTimeline> {
  bool visibility = false;

  @override
  Widget build(final BuildContext context) => MouseRegion(
        onHover: (final PointerHoverEvent event) =>
            setState(() => visibility = true),
        onExit: (final PointerExitEvent event) =>
            setState(() => visibility = false),
        child: Visibility(
          maintainSize: true,
          maintainAnimation: true,
          maintainState: true,
          visible: visibility,
          child: IconButton(
            onPressed: () {
              widget.onClick();
            },
            icon: const Icon(Icons.circle),
          ),
        ),
      );
}

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

class TimeLineSegment extends StatefulWidget {
  TimeLineSegment({
    final Key? key,
    required this.pointAmount,
    required this.isHidden,
    required this.onHidePressed,
    required this.color,
    required this.velocity,
    required this.onChange,
  }) : super(key: key);
  final int pointAmount;
  final bool isHidden;
  final Function() onHidePressed;
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
      TextEditingController(text: "");

  @override
  void initState() {
    super.initState();
    _velocityFieldController.text = widget.velocity.toString();
  }

  @override
  Widget build(final BuildContext context) {
    final ThemeData theme = Theme.of(context);

    _velocityFieldController.selection = TextSelection.fromPosition(
      TextPosition(offset: _velocityFieldController.text.length),
    );

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            ConstrainedBox(
              constraints: const BoxConstraints.tightFor(width: 40, height: 40),
              child: TextField(
                controller: _velocityFieldController,
                keyboardType: TextInputType.text,
                decoration: InputDecoration(
                  hintText: "m/s",
                  errorText:
                      double.tryParse(_velocityFieldController.text) == null
                          ? "Error"
                          : null,
                ),
                onChanged: (final String value) {
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
              icon: Icon(
                widget.isHidden
                    ? Icons.remove_red_eye_outlined
                    : Icons.remove_red_eye,
              ),
            ),
          ],
        ),
        const SizedBox(height: 5),
        Stack(
          alignment: Alignment.center,
          children: <Widget>[
            Container(
              height: TimeLineSegment.segmentHeight,
              decoration: BoxDecoration(
                color: gray,
                border: Border.all(color: primary, width: 4),
                borderRadius:
                    const BorderRadius.all(Radius.circular(defaultRadius)),
              ),
            ),
            Container(
              height: 2,
              color: widget.color,
            ),
          ],
        ),
      ],
    );
  }
}
