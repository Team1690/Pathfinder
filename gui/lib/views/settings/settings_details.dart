import "package:flutter/material.dart";
import "package:orbit_card_settings/card_settings.dart";
import "package:pathfinder/shortcuts/help.dart";
import "package:pathfinder/models/history.dart";
import "package:pathfinder/models/path_point.dart";
import "package:pathfinder/models/robot.dart";
import "package:pathfinder/store/tab/store.dart";
import "package:pathfinder/views/settings/help_settings.dart";
import "package:pathfinder/views/settings/history_settings.dart";
import "package:pathfinder/views/settings/point_settings.dart";
import "package:pathfinder/views/settings/robot_settings.dart";

//TODO: concise + add TODOS
class SettingsDetails extends StatelessWidget {
  SettingsDetails({
    required this.tabState,
    required this.onPointEdit,
    required this.onRobotEdit,
  });
  //TODO: store connector
  final TabState tabState;
  final Function(int index, PathPoint point) onPointEdit;
  final Function(Robot robot) onRobotEdit;

  @override
  Widget build(final BuildContext context) =>
      switch (tabState.ui.selectedType) {
        PathPoint => PointSettings(onPointEdit: onPointEdit),
        Robot => RobotSettings(onRobotEdit: onRobotEdit),
        History => const HistorySettings(),
        Help => const HelpSettings(),
        _ => const SizedBox.shrink(),
      };
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
