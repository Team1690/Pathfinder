import "package:card_settings/card_settings.dart";
import "package:flutter/material.dart";
import "package:pathfinder/constants.dart";
import "package:pathfinder/models/help.dart";
import "package:pathfinder/models/history.dart";
import "package:pathfinder/models/point.dart";
import "package:pathfinder/models/robot.dart";
import "package:pathfinder/store/tab/store.dart";
import "package:pathfinder/utils/math.dart";
import "package:pathfinder/views/home/home.dart";

class SettingsDetails extends StatelessWidget {
  SettingsDetails({
    required this.tabState,
    required this.onPointEdit,
    required this.onRobotEdit,
  });
  final TabState tabState;
  final Function(int index, Point point) onPointEdit;
  final Function(Robot robot) onRobotEdit;
  final TextEditingController inAngleController = TextEditingController();
  final TextEditingController outAngleController = TextEditingController();

  CardSettingsText _cardSettingsDouble({
    required final String label,
    required final double initialValue,
    required final Function(double) onChanged,
    final bool allowNegative = true,
    final int fractionDigits = 3,
    final String unitLabel = "m",
    final TextEditingController? controller,
  }) {
    final String text =
        double.parse(initialValue.toStringAsFixed(fractionDigits)).toString();
    return CardSettingsText(
      controller: controller
        ?..text = text
        ..selection = TextSelection(
          baseOffset: text.length - 1,
          extentOffset: text.length - 1,
        ),
      label: label,
      // Remove trailing zeros and set to the wanted fraction digits
      initialValue:
          double.parse(initialValue.toStringAsFixed(fractionDigits)).toString(),
      hintText: label,
      unitLabel: unitLabel,
      validator: (final String? value) {
        if (value == null) return "$label is required.";
        if (double.tryParse(value) == null) return "Not a number";
        if (!allowNegative && double.parse(value) < 0) return "No negatives";
        return null;
      },
      onChanged: (final String val) =>
          onChanged(double.tryParse(val) ?? initialValue),
    );
  }

  @override
  Widget build(final BuildContext context) {
    final int index = tabState.ui.selectedIndex;
    final List<Point> points = tabState.path.points;
    final Robot robot = tabState.robot;

    // On init the selected index may be negative
    if (index < 0) return const SizedBox.shrink();

    if (tabState.ui.selectedType == Robot) {
      return Form(
        child: CardSettings(
          contentAlign: TextAlign.right,
          labelAlign: TextAlign.left,
          shrinkWrap: true,
          children: <CardSettingsSection>[
            CardSettingsSection(
              children: <CardSettingsWidget>[
                _cardSettingsDouble(
                  label: "Width",
                  unitLabel: "m",
                  allowNegative: false,
                  initialValue: robot.width,
                  onChanged: (final double value) {
                    onRobotEdit(
                      robot.copyWith(
                        width: value,
                      ),
                    );
                  },
                ),
                _cardSettingsDouble(
                  label: "Height",
                  unitLabel: "m",
                  allowNegative: false,
                  initialValue: robot.height,
                  onChanged: (final double value) {
                    onRobotEdit(
                      robot.copyWith(
                        height: value,
                      ),
                    );
                  },
                ),
                _cardSettingsDouble(
                  label: "Max Velocity",
                  unitLabel: "m/s",
                  allowNegative: false,
                  initialValue: robot.maxVelocity,
                  onChanged: (final double value) {
                    onRobotEdit(
                      robot.copyWith(
                        maxVelocity: value,
                      ),
                    );
                  },
                ),
                _cardSettingsDouble(
                  label: "Max Accel",
                  unitLabel: "m/s²",
                  allowNegative: false,
                  initialValue: robot.maxAcceleration,
                  onChanged: (final double value) {
                    onRobotEdit(
                      robot.copyWith(
                        maxAcceleration: value,
                      ),
                    );
                  },
                ),
                _cardSettingsDouble(
                  label: "Max Jerk",
                  unitLabel: "m/s³",
                  allowNegative: false,
                  initialValue: robot.maxJerk,
                  onChanged: (final double value) {
                    onRobotEdit(
                      robot.copyWith(
                        maxJerk: value,
                      ),
                    );
                  },
                ),
                _cardSettingsDouble(
                  label: "Skid Accel",
                  unitLabel: "m/s²",
                  initialValue: robot.skidAcceleration,
                  onChanged: (final double value) {
                    onRobotEdit(
                      robot.copyWith(
                        skidAcceleration: value,
                      ),
                    );
                  },
                ),
                _cardSettingsDouble(
                  label: "Cycle Time",
                  unitLabel: "s",
                  allowNegative: false,
                  initialValue: robot.cycleTime,
                  onChanged: (final double value) {
                    onRobotEdit(
                      robot.copyWith(
                        cycleTime: value,
                      ),
                    );
                  },
                ),
                _cardSettingsDouble(
                  label: "Angular Accel Perc",
                  unitLabel: "%",
                  allowNegative: false,
                  initialValue: 100 * robot.angularAccelerationPercentage,
                  onChanged: (final double value) {
                    onRobotEdit(
                      robot.copyWith(
                        angularAccelerationPercentage: value / 100,
                      ),
                    );
                  },
                ),
              ],
            ),
          ],
        ),
      );
    }

    if (tabState.ui.selectedType == History) {
      return Container(
        child: Card(
          margin: const EdgeInsets.all(8),
          child: Column(
            children: <Widget>[
              ListView(
                scrollDirection: Axis.vertical,
                shrinkWrap: true,
                children: tabState.history.pathHistory
                    .asMap()
                    .entries
                    .map(
                      (final MapEntry<int, HistoryStamp> e) => ListTile(
                        dense: true,
                        enabled: e.key <= tabState.history.currentStateIndex,
                        leading: Icon(
                          actionToIcon[e.value.action] ??
                              Icons.device_unknown_outlined,
                        ),

                        // Seperate the name by capital letter (EditPoint -> Edit Point)
                        title: Text(
                          (e.value.action
                              .split(RegExp(r"(?=[A-Z])"))
                              .join(" ")),
                        ),
                      ),
                    )
                    .toList()
                    .reversed
                    .toList(),
              ),
            ],
          ),
        ),
      );
    }

    if (tabState.ui.selectedType == Point) {
      if (points.isEmpty) return const SizedBox.shrink();

      final Point pointData = points[index];
      final bool isFirstOrLast = index == 0 || index == points.length - 1;

      return Form(
        child: CardSettings.sectioned(
          contentAlign: TextAlign.right,
          labelAlign: TextAlign.left,
          shrinkWrap: true,
          children: <CardSettingsSection>[
            CardSettingsSection(
              children: <CardSettingsWidget>[
                _cardSettingsDouble(
                  label: "Position X",
                  initialValue: pointData.position.dx,
                  onChanged: (final double value) {
                    onPointEdit(
                      index,
                      pointData.copyWith(
                        position: Offset(value, pointData.position.dy),
                      ),
                    );
                  },
                ),
                _cardSettingsDouble(
                  label: "Position Y",
                  initialValue: pointData.position.dy,
                  onChanged: (final double value) {
                    onPointEdit(
                      index,
                      pointData.copyWith(
                        position: Offset(pointData.position.dx, value),
                      ),
                    );
                  },
                ),
                _cardSettingsDouble(
                  label: "In Mag",
                  initialValue: pointData.inControlPoint.distance,
                  allowNegative: false,
                  onChanged: (final double value) {
                    onPointEdit(
                      index,
                      pointData.copyWith(
                        inControlPoint: Offset.fromDirection(
                          pointData.inControlPoint.direction,
                          value,
                        ),
                      ),
                    );
                  },
                ),
                _cardSettingsDouble(
                  controller: inAngleController,
                  label: "In Angle",
                  initialValue: degrees(pointData.inControlPoint.direction),
                  unitLabel: "°",
                  fractionDigits: 1,
                  onChanged: (final double value) {
                    final double opposite = radians(value + 180);
                    onPointEdit(
                      index,
                      pointData.copyWith(
                        inControlPoint: Offset.fromDirection(
                          radians(value),
                          pointData.inControlPoint.distance,
                        ),
                        outControlPoint: pointData.isStop
                            ? pointData.outControlPoint
                            : Offset.fromDirection(
                                opposite,
                                pointData.outControlPoint.distance,
                              ),
                      ),
                    );
                    outAngleController.text = opposite.toString();
                  },
                ),
                _cardSettingsDouble(
                  label: "Out Mag",
                  allowNegative: false,
                  initialValue: pointData.outControlPoint.distance,
                  onChanged: (final double value) {
                    onPointEdit(
                      index,
                      pointData.copyWith(
                        outControlPoint: Offset.fromDirection(
                          pointData.outControlPoint.direction,
                          value,
                        ),
                      ),
                    );
                  },
                ),
                _cardSettingsDouble(
                  controller: outAngleController,
                  label: "Out Angle",
                  initialValue: degrees(pointData.outControlPoint.direction),
                  fractionDigits: 1,
                  unitLabel: "°",
                  onChanged: (final double value) {
                    final double opposite = radians(value + 180);

                    onPointEdit(
                      index,
                      pointData.copyWith(
                        outControlPoint: Offset.fromDirection(
                          radians(value),
                          pointData.outControlPoint.distance,
                        ),
                        inControlPoint: pointData.isStop
                            ? pointData.inControlPoint
                            : Offset.fromDirection(
                                opposite,
                                pointData.inControlPoint.direction,
                              ),
                      ),
                    );
                    inAngleController.text = opposite.toString();
                  },
                ),
                CardSettingsSwitch(
                  enabled: index != 0,
                  initialValue: pointData.useHeading,
                  label: "Use Heading",
                  onChanged: (final bool value) {
                    onPointEdit(index, pointData.copyWith(useHeading: value));
                    triggerSidebarRender();
                  },
                ),
                if (pointData.useHeading)
                  _cardSettingsDouble(
                    label: "Heading",
                    initialValue: degrees(pointData.heading),
                    fractionDigits: 1,
                    unitLabel: "°",
                    onChanged: (final double value) {
                      onPointEdit(
                        index,
                        pointData.copyWith(heading: radians(value)),
                      );
                    },
                  ),
                if (!isFirstOrLast)
                  CardSettingsSwitch(
                    enabled: !pointData.isStop,
                    initialValue: pointData.cutSegment,
                    label: "Cut segments",
                    onChanged: (final bool value) {
                      onPointEdit(index, pointData.copyWith(cutSegment: value));
                      triggerSidebarRender();
                    },
                  ),
                if (!isFirstOrLast)
                  CardSettingsSwitch(
                    initialValue: pointData.isStop,
                    label: "Stop point",
                    onChanged: (final bool value) {
                      onPointEdit(index, pointData.copyWith(isStop: value));
                      triggerSidebarRender();
                    },
                  ),
              ],
            ),
            CardSettingsSection(
              children: <CardSettingsWidget>[
                CardSettingsListPicker<String>(
                  label: "Action",
                  initialItem:
                      pointData.action == "" ? "None" : pointData.action,
                  items: const <String>[
                    "None",
                    ...autoActions,
                  ],
                  onChanged: (String? value) {
                    if (value == "None") value = "";
                    onPointEdit(index, pointData.copyWith(action: value));
                  },
                ),
                if (pointData.action != "")
                  _cardSettingsDouble(
                    label: "Action Time",
                    initialValue: pointData.actionTime,
                    unitLabel: "s",
                    onChanged: (final double value) {
                      onPointEdit(index, pointData.copyWith(actionTime: value));
                    },
                  ),
              ],
            ),
          ],
          // );
          // },
        ),
      );
    }

    if (tabState.ui.selectedType == Help) {}
    return const SizedBox.shrink();
  }
}
