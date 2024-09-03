import "package:flutter/material.dart";
import "package:flutter/src/gestures/events.dart";

//TODO: concise this(easy) + docs
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
