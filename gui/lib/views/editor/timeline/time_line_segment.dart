import "package:flutter/material.dart";
import "package:pathfinder/constants.dart";

const double _segmentHeight = 50;

class TimeLineSegment extends StatefulWidget {
  const TimeLineSegment({
    super.key,
    required this.pointAmount,
    required this.isHidden,
    required this.onHidePressed,
    required this.color,
    required this.velocity,
    required this.onChange,
  });

  final int pointAmount;
  final bool isHidden;
  final Function() onHidePressed;
  final Color color;
  final double velocity;
  final Function(double) onChange;

  @override
  _TimeLineSegmentState createState() => _TimeLineSegmentState();
}

class _TimeLineSegmentState extends State<TimeLineSegment> {
  late final TextEditingController _velocityFieldController =
      TextEditingController(text: widget.velocity.toString());

  @override
  Widget build(final BuildContext context) => Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              ConstrainedBox(
                constraints:
                    const BoxConstraints.tightFor(width: 40, height: 40),
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
                  },
                  onTap: () {
                    _velocityFieldController.selection =
                        TextSelection.fromPosition(
                      TextPosition(
                        offset: _velocityFieldController.text.length,
                      ),
                    );
                  },
                  textAlign: TextAlign.center,
                ),
              ),
              IconButton(
                iconSize: 20,
                color: Theme.of(context).textTheme.displaySmall?.color,
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
                height: _segmentHeight,
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
