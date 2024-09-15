import "dart:math";

import "package:flutter/material.dart";
import "package:flutter_redux/flutter_redux.dart";
import "package:orbit_card_settings/card_settings.dart";
import "package:pathfinder/views/settings/point_settings_model.dart";
import "package:pathfinder/constants.dart";
import "package:pathfinder/models/path_point.dart";
import "package:pathfinder/store/app/app_state.dart";
import "package:pathfinder/utils/math.dart";
import "package:pathfinder/views/settings/settings_details.dart";

//TODO: maybe place this in constants
const Offset _blueSpeakerPos = const Offset(0.24, 5.549);

class PointSettings extends StatefulWidget {
  const PointSettings({
    super.key,
    required this.onPointEdit,
  });

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
      StoreConnector<AppState, PointSettingsModel>(
        converter: PointSettingsModel.fromStore,
        builder: (
          final BuildContext context,
          final PointSettingsModel model,
        ) =>
            model.points.isEmpty
                ? const SizedBox.shrink()
                : CardSettings.sectioned(
                    contentAlign: TextAlign.right,
                    labelAlign: TextAlign.left,
                    shrinkWrap: true,
                    children: <CardSettingsSection>[
                      CardSettingsSection(
                        children: <CardSettingsWidget>[
                          cardSettingsDouble(
                            controller: positionXController,
                            label: "Position X",
                            initialValue: model.pointData.position.dx,
                            onChanged: (final double value) {
                              widget.onPointEdit(
                                model.index,
                                model.pointData.copyWith(
                                  position: Offset(
                                    value,
                                    model.pointData.position.dy,
                                  ),
                                ),
                              );
                            },
                          ),
                          cardSettingsDouble(
                            controller: positionYController,
                            label: "Position Y",
                            initialValue: model.pointData.position.dy,
                            onChanged: (final double value) {
                              widget.onPointEdit(
                                model.index,
                                model.pointData.copyWith(
                                  position: Offset(
                                    model.pointData.position.dx,
                                    value,
                                  ),
                                ),
                              );
                            },
                          ),
                          cardSettingsDouble(
                            controller: inMagController,
                            label: "In Mag",
                            initialValue:
                                model.pointData.inControlPoint.distance,
                            allowZero: false,
                            allowNegative: false,
                            onChanged: (final double value) {
                              widget.onPointEdit(
                                model.index,
                                model.pointData.copyWith(
                                  inControlPoint: Offset.fromDirection(
                                    model.pointData.inControlPoint.direction,
                                    value,
                                  ),
                                ),
                              );
                            },
                          ),
                          cardSettingsDouble(
                            controller: inAngleController,
                            label: "In Angle",
                            initialValue: radToDeg(
                              model.pointData.inControlPoint.direction,
                            ),
                            unitLabel: "°",
                            fractionDigits: 1,
                            onChanged: (final double value) {
                              final double opposite = degToRad(value + 180);
                              widget.onPointEdit(
                                model.index,
                                model.pointData.copyWith(
                                  inControlPoint: Offset.fromDirection(
                                    degToRad(value),
                                    model.pointData.inControlPoint.distance,
                                  ),
                                  outControlPoint: model.pointData.isStop
                                      ? model.pointData.outControlPoint
                                      : Offset.fromDirection(
                                          opposite,
                                          model.pointData.outControlPoint
                                              .distance,
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
                            initialValue:
                                model.pointData.outControlPoint.distance,
                            onChanged: (final double value) {
                              widget.onPointEdit(
                                model.index,
                                model.pointData.copyWith(
                                  outControlPoint: Offset.fromDirection(
                                    model.pointData.outControlPoint.direction,
                                    value,
                                  ),
                                ),
                              );
                            },
                          ),
                          cardSettingsDouble(
                            controller: outAngleController,
                            label: "Out Angle",
                            initialValue: radToDeg(
                              model.pointData.outControlPoint.direction,
                            ),
                            fractionDigits: 1,
                            unitLabel: "°",
                            onChanged: (final double value) {
                              final double opposite = degToRad(value + 180);

                              widget.onPointEdit(
                                model.index,
                                model.pointData.copyWith(
                                  outControlPoint: Offset.fromDirection(
                                    degToRad(value),
                                    model.pointData.outControlPoint.distance,
                                  ),
                                  inControlPoint: model.pointData.isStop
                                      ? model.pointData.inControlPoint
                                      : Offset.fromDirection(
                                          opposite,
                                          model.pointData.inControlPoint
                                              .distance,
                                        ),
                                ),
                              );
                              inAngleController.text = opposite.toString();
                            },
                          ),
                          CardSettingsSwitch(
                            key: Key(
                              "Use Heading ${model.pointData.useHeading}",
                            ),
                            enabled: model.index != 0,
                            initialValue: model.pointData.useHeading,
                            label: "Use Heading",
                            onChanged: (final bool value) {
                              widget.onPointEdit(
                                model.index,
                                model.pointData.copyWith(useHeading: value),
                              );
                            },
                          ),
                          if (model.pointData.useHeading)
                            cardSettingsDouble(
                              controller: headingController,
                              label: "Heading",
                              initialValue: radToDeg(model.pointData.heading),
                              fractionDigits: 1,
                              unitLabel: "°",
                              onChanged: (final double value) {
                                widget.onPointEdit(
                                  model.index,
                                  model.pointData
                                      .copyWith(heading: degToRad(value)),
                                );
                              },
                            ),
                          CardSettingsButton(
                            onPressed: () {
                              final Offset diff =
                                  _blueSpeakerPos - model.pointData.position;
                              widget.onPointEdit(
                                model.index,
                                model.pointData.copyWith(
                                  useHeading: true,
                                  heading: atan2(diff.dy, diff.dx) + pi,
                                ),
                              );
                            },
                            label: "Shooting point heading",
                          ),
                          CardSettingsButton(
                            onPressed: () {
                              if (model.index < model.points.length - 1) {
                                final Offset diff =
                                    model.points[model.index + 1].position -
                                        model.pointData.position;

                                final double angle = atan2(diff.dy, diff.dx);
                                widget.onPointEdit(
                                  model.index,
                                  model.pointData.copyWith(
                                    useHeading: true,
                                    heading: angle,
                                    inControlPoint: model.pointData.isStop
                                        ? model.pointData.inControlPoint
                                        : Offset.fromDirection(
                                            angle + pi,
                                            model.pointData.inControlPoint
                                                .distance,
                                          ),
                                    outControlPoint: Offset.fromDirection(
                                      angle,
                                      model.pointData.outControlPoint.distance,
                                    ),
                                  ),
                                );
                              }
                            },
                            label: "Aim to next",
                          ),
                          CardSettingsButton(
                            onPressed: () {
                              if (model.index > 0) {
                                final Offset diff =
                                    model.points[model.index - 1].position -
                                        model.pointData.position;

                                final double angle = atan2(diff.dy, diff.dx);
                                widget.onPointEdit(
                                  model.index,
                                  model.pointData.copyWith(
                                    inControlPoint: Offset.fromDirection(
                                      angle,
                                      model.pointData.inControlPoint.distance,
                                    ),
                                    outControlPoint: model.pointData.isStop
                                        ? model.pointData.outControlPoint
                                        : Offset.fromDirection(
                                            angle + pi,
                                            model.pointData.outControlPoint
                                                .distance,
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
                        children: <CardSettingsWidget>[
                          if (!model.isFirstOrLast)
                            CardSettingsSwitch(
                              key: Key(
                                "Cut Segments ${model.pointData.cutSegment}",
                              ),
                              enabled: !model.pointData.isStop,
                              initialValue: model.pointData.cutSegment,
                              label: "Cut Segments",
                              onChanged: (final bool value) {
                                widget.onPointEdit(
                                  model.index,
                                  model.pointData.copyWith(cutSegment: value),
                                );
                              },
                            ),
                          if (!model.isFirstOrLast)
                            CardSettingsSwitch(
                              key: Key("Stop Point ${model.pointData.isStop}"),
                              initialValue: model.pointData.isStop,
                              label: "Stop Point",
                              onChanged: (final bool value) {
                                widget.onPointEdit(
                                  model.index,
                                  model.pointData.copyWith(isStop: value),
                                );
                              },
                            ),
                        ],
                      ),
                      CardSettingsSection(
                        children: <CardSettingsWidget>[
                          CardSettingsListPicker<String>(
                            key: Key("Action ${model.pointData.action}"),
                            label: "Action",
                            initialItem: model.pointData.action == ""
                                ? "None"
                                : model.pointData.action,
                            items: const <String>[
                              "None",
                              ...autoActions,
                            ],
                            onChanged: (String? value) {
                              if (value == "None") value = "";
                              widget.onPointEdit(
                                model.index,
                                model.pointData.copyWith(action: value),
                              );
                            },
                          ),
                          if (model.pointData.action != "")
                            cardSettingsDouble(
                              controller: actionTimeController,
                              label: "Action Time",
                              initialValue: model.pointData.actionTime,
                              unitLabel: "s",
                              onChanged: (final double value) {
                                widget.onPointEdit(
                                  model.index,
                                  model.pointData.copyWith(actionTime: value),
                                );
                              },
                            ),
                        ],
                      ),
                    ],
                  ),
      );
}
