import "package:flutter/material.dart";
import "package:orbit_card_settings/card_settings.dart";
import "package:orbit_card_settings/helpers/platform_functions.dart";
import "package:pathfinder/shortcuts/help.dart";
import "package:pathfinder/models/history.dart";
import "package:pathfinder/models/path_point.dart";
import "package:pathfinder/models/robot.dart";
import "package:pathfinder/shortcuts/shortcut.dart";
import "package:pathfinder/shortcuts/shortcut_def.dart";
import "package:pathfinder/store/tab/store.dart";
import "package:pathfinder/views/home/point_settings.dart";

const Offset blueSpeakerPos = const Offset(0.24, 5.549);

//TODO: concise + add TODOS
class SettingsDetails extends StatelessWidget {
  SettingsDetails({
    required this.tabState,
    required this.onPointEdit,
    required this.onRobotEdit,
  });
  final TabState tabState;
  final Function(int index, PathPoint point) onPointEdit;
  final Function(Robot robot) onRobotEdit;

  @override
  Widget build(final BuildContext context) {
    final int index = tabState.ui.selectedIndex;
    final List<PathPoint> points = tabState.path.points;
    final Robot robot = tabState.robot;
    // return SettingsDouble(
    //     value: tabState.i,
    //     onChanged: (value) {
    //       StoreProvider.of<AppState>(context).dispatch(ChangeI(i: value));
    //     });
    // On init the selected index may be negative
    if (index < 0) return const SizedBox.shrink();

    if (tabState.ui.selectedType == Robot) {
      return CardSettings(
        scrollable: true,
        contentAlign: TextAlign.right,
        labelAlign: TextAlign.left,
        shrinkWrap: true,
        children: <CardSettingsSection>[
          CardSettingsSection(
            children: <CardSettingsWidget>[
              cardSettingsDouble(
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
              cardSettingsDouble(
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
              cardSettingsDouble(
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
              cardSettingsDouble(
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
              cardSettingsDouble(
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
              cardSettingsDouble(
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
              cardSettingsDouble(
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
              cardSettingsDouble(
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
                          style: labelStyle(context, true),
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

    if (tabState.ui.selectedType == Help) {
      return Container(
        child: Card(
          margin: const EdgeInsets.all(8),
          child: Column(
            children: <Widget>[
              ListView(
                controller: ScrollController(),
                scrollDirection: Axis.vertical,
                shrinkWrap: true,
                children: shortcuts
                    .map(
                      (final Shortcut e) => ListTile(
                        dense: true,

                        leading: e.icon ??
                            const Icon(
                              Icons.circle_rounded,
                              size: 10,
                            ),

                        // Seperate the name by capital letter (EditPoint -> Edit Point)
                        title: Text(
                          "${e.shortcut} : \n${e.description}",
                          style: labelStyle(context, true),
                        ),
                      ),
                    )
                    .expand(
                      (final ListTile element) =>
                          <Widget>[element, const Divider()],
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

    if (tabState.ui.selectedType == PathPoint) {
      if (points.isEmpty) return const SizedBox.shrink();

      final PathPoint pointData = points[index];
      final bool isFirstOrLast = index == 0 || index == points.length - 1;
      return PointSettings(
          pointData: pointData,
          isFirstOrLast: isFirstOrLast,
          index: index,
          onPointEdit: onPointEdit);
    }

    if (tabState.ui.selectedType == Help) {}
    return const SizedBox.shrink();
  }
}

CardSettingsText cardSettingsDouble({
  required final String label,
  required final double initialValue,
  required final Function(double) onChanged,
  final bool allowNegative = true,
  final int fractionDigits = 3,
  final String unitLabel = "m",
  final TextEditingController? controller,
  final bool allowZero = true,
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
      if (!allowZero && double.parse(value) == 0) return "No zero";
      return null;
    },
    onChanged: (final String val) {
      final double value = double.tryParse(val) ?? initialValue;
      onChanged(!allowZero && value == 0 ? initialValue : value);
    },
  );
}
