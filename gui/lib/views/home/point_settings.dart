import "dart:math";

import "package:flutter/material.dart";
import "package:flutter_redux/flutter_redux.dart";
import "package:orbit_card_settings/card_settings.dart";
import "package:redux/redux.dart";
import "package:pathfinder/constants.dart";
import "package:pathfinder/models/path_point.dart";
import "package:pathfinder/store/app/app_state.dart";
import "package:pathfinder/store/tab/store.dart";
import "package:pathfinder/utils/math.dart";
import "package:pathfinder/views/home/settings_details.dart";

//TODO: maybe place this in constants
const Offset _blueSpeakerPos = const Offset(0.24, 5.549);

class PointSettings extends StatefulWidget {
  const PointSettings({
    super.key,
    required this.pointData,
    required this.isFirstOrLast,
    required this.index,
    required this.onPointEdit,
  });

  final PathPoint pointData;
  final bool isFirstOrLast;
  final int index;
  final void Function(int, PathPoint) onPointEdit;

  @override
  State<PointSettings> createState() => _PointSettingsState();
}

class _PointSettingsState extends State<PointSettings> {
  final TextEditingController inAngleController = TextEditingController();
  final TextEditingController outAngleController = TextEditingController();
  final TextEditingController inMagController = TextEditingController();
  final TextEditingController outMagController = TextEditingController();
  final TextEditingController positionXController = TextEditingController();
  final TextEditingController positionYController = TextEditingController();
  final TextEditingController headingController = TextEditingController();
  final TextEditingController actionTimeController = TextEditingController();

  @override
  Widget build(final BuildContext context) =>
      StoreConnector<AppState, TabState>(
        converter: (final Store<AppState> store) => store.state.currentTabState,
        builder: (final BuildContext context, final TabState tabState) =>
            CardSettings.sectioned(
          contentAlign: TextAlign.right,
          labelAlign: TextAlign.left,
          shrinkWrap: true,
          children: <CardSettingsSection>[
            CardSettingsSection(
              children: <CardSettingsWidget>[
                cardSettingsDouble(
                  controller: positionXController,
                  label: "Position X",
                  initialValue: widget.pointData.position.dx,
                  onChanged: (final double value) {
                    widget.onPointEdit(
                      widget.index,
                      widget.pointData.copyWith(
                        position: Offset(value, widget.pointData.position.dy),
                      ),
                    );
                  },
                ),
                cardSettingsDouble(
                  controller: positionYController,
                  label: "Position Y",
                  initialValue: widget.pointData.position.dy,
                  onChanged: (final double value) {
                    widget.onPointEdit(
                      widget.index,
                      widget.pointData.copyWith(
                        position: Offset(widget.pointData.position.dx, value),
                      ),
                    );
                  },
                ),
                cardSettingsDouble(
                  controller: inMagController,
                  label: "In Mag",
                  initialValue: widget.pointData.inControlPoint.distance,
                  allowZero: false,
                  allowNegative: false,
                  onChanged: (final double value) {
                    widget.onPointEdit(
                      widget.index,
                      widget.pointData.copyWith(
                        inControlPoint: Offset.fromDirection(
                          widget.pointData.inControlPoint.direction,
                          value,
                        ),
                      ),
                    );
                  },
                ),
                cardSettingsDouble(
                  controller: inAngleController,
                  label: "In Angle",
                  initialValue:
                      radToDeg(widget.pointData.inControlPoint.direction),
                  unitLabel: "°",
                  fractionDigits: 1,
                  onChanged: (final double value) {
                    final double opposite = degToRad(value + 180);
                    widget.onPointEdit(
                      widget.index,
                      widget.pointData.copyWith(
                        inControlPoint: Offset.fromDirection(
                          degToRad(value),
                          widget.pointData.inControlPoint.distance,
                        ),
                        outControlPoint: widget.pointData.isStop
                            ? widget.pointData.outControlPoint
                            : Offset.fromDirection(
                                opposite,
                                widget.pointData.outControlPoint.distance,
                              ),
                      ),
                    );
                    outAngleController.text = opposite.toString();
                  },
                ),
                cardSettingsDouble(
                  controller: outMagController,
                  label: "Out Mag",
                  allowNegative: false,
                  allowZero: false,
                  initialValue: widget.pointData.outControlPoint.distance,
                  onChanged: (final double value) {
                    widget.onPointEdit(
                      widget.index,
                      widget.pointData.copyWith(
                        outControlPoint: Offset.fromDirection(
                          widget.pointData.outControlPoint.direction,
                          value,
                        ),
                      ),
                    );
                  },
                ),
                cardSettingsDouble(
                  controller: outAngleController,
                  label: "Out Angle",
                  initialValue:
                      radToDeg(widget.pointData.outControlPoint.direction),
                  fractionDigits: 1,
                  unitLabel: "°",
                  onChanged: (final double value) {
                    final double opposite = degToRad(value + 180);

                    widget.onPointEdit(
                      widget.index,
                      widget.pointData.copyWith(
                        outControlPoint: Offset.fromDirection(
                          degToRad(value),
                          widget.pointData.outControlPoint.distance,
                        ),
                        inControlPoint: widget.pointData.isStop
                            ? widget.pointData.inControlPoint
                            : Offset.fromDirection(
                                opposite,
                                widget.pointData.inControlPoint.distance,
                              ),
                      ),
                    );
                    inAngleController.text = opposite.toString();
                  },
                ),
                CardSettingsSwitch(
                  key: Key("Use Heading ${widget.pointData.useHeading}"),
                  enabled: widget.index != 0,
                  initialValue: widget.pointData.useHeading,
                  label: "Use Heading",
                  onChanged: (final bool value) {
                    widget.onPointEdit(
                      widget.index,
                      widget.pointData.copyWith(useHeading: value),
                    );
                  },
                ),
                if (widget.pointData.useHeading)
                  cardSettingsDouble(
                    controller: headingController,
                    label: "Heading",
                    initialValue: radToDeg(widget.pointData.heading),
                    fractionDigits: 1,
                    unitLabel: "°",
                    onChanged: (final double value) {
                      widget.onPointEdit(
                        widget.index,
                        widget.pointData.copyWith(heading: degToRad(value)),
                      );
                    },
                  ),
                CardSettingsButton(
                  onPressed: () {
                    final Offset diff =
                        _blueSpeakerPos - widget.pointData.position;
                    widget.onPointEdit(
                      widget.index,
                      widget.pointData.copyWith(
                        useHeading: true,
                        heading: atan2(diff.dy, diff.dx) + pi,
                      ),
                    );
                  },
                  label: "Shooting point heading",
                ),
                CardSettingsButton(
                  onPressed: () {
                    if (widget.index < tabState.path.points.length - 1) {
                      final Offset diff =
                          tabState.path.points[widget.index + 1].position -
                              widget.pointData.position;

                      final double angle = atan2(diff.dy, diff.dx);
                      widget.onPointEdit(
                        widget.index,
                        widget.pointData.copyWith(
                          useHeading: true,
                          heading: angle,
                          inControlPoint: widget.pointData.isStop
                              ? widget.pointData.inControlPoint
                              : Offset.fromDirection(
                                  angle + pi,
                                  widget.pointData.inControlPoint.distance,
                                ),
                          outControlPoint: Offset.fromDirection(
                            angle,
                            widget.pointData.outControlPoint.distance,
                          ),
                        ),
                      );
                    }
                  },
                  label: "Aim to next",
                ),
                CardSettingsButton(
                  onPressed: () {
                    if (widget.index > 0) {
                      final Offset diff =
                          tabState.path.points[widget.index - 1].position -
                              widget.pointData.position;

                      final double angle = atan2(diff.dy, diff.dx);
                      widget.onPointEdit(
                        widget.index,
                        widget.pointData.copyWith(
                          inControlPoint: Offset.fromDirection(
                            angle,
                            widget.pointData.inControlPoint.distance,
                          ),
                          outControlPoint: widget.pointData.isStop
                              ? widget.pointData.outControlPoint
                              : Offset.fromDirection(
                                  angle + pi,
                                  widget.pointData.outControlPoint.distance,
                                ),
                        ),
                      );
                    }
                  },
                  label: "Aim to prev",
                ),
              ],
            ),
            CardSettingsSection(
              children: [
                if (!widget.isFirstOrLast)
                  CardSettingsSwitch(
                    key: Key("Cut Segments ${widget.pointData.cutSegment}"),
                    enabled: !widget.pointData.isStop,
                    initialValue: widget.pointData.cutSegment,
                    label: "Cut Segments",
                    onChanged: (final bool value) {
                      widget.onPointEdit(
                        widget.index,
                        widget.pointData.copyWith(cutSegment: value),
                      );
                    },
                  ),
                if (!widget.isFirstOrLast)
                  CardSettingsSwitch(
                    key: Key("Stop Point ${widget.pointData.isStop}"),
                    initialValue: widget.pointData.isStop,
                    label: "Stop Point",
                    onChanged: (final bool value) {
                      widget.onPointEdit(
                        widget.index,
                        widget.pointData.copyWith(isStop: value),
                      );
                    },
                  ),
              ],
            ),
            CardSettingsSection(
              children: <CardSettingsWidget>[
                CardSettingsListPicker<String>(
                  key: Key("Action ${widget.pointData.action}"),
                  label: "Action",
                  initialItem: widget.pointData.action == ""
                      ? "None"
                      : widget.pointData.action,
                  items: const <String>[
                    "None",
                    ...autoActions,
                  ],
                  onChanged: (String? value) {
                    if (value == "None") value = "";
                    widget.onPointEdit(
                      widget.index,
                      widget.pointData.copyWith(action: value),
                    );
                  },
                ),
                if (widget.pointData.action != "")
                  cardSettingsDouble(
                    controller: actionTimeController,
                    label: "Action Time",
                    initialValue: widget.pointData.actionTime,
                    unitLabel: "s",
                    onChanged: (final double value) {
                      widget.onPointEdit(
                        widget.index,
                        widget.pointData.copyWith(actionTime: value),
                      );
                    },
                  ),
              ],
            ),
          ],
        ),
      );
}
