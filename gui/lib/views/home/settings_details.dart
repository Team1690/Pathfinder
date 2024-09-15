import "package:flutter/material.dart";
import "package:orbit_card_settings/card_settings.dart";
import "package:pathfinder/shortcuts/help.dart";
import "package:pathfinder/models/history.dart";
import "package:pathfinder/models/path_point.dart";
import "package:pathfinder/models/robot.dart";
import "package:pathfinder/store/tab/store.dart";
import "package:pathfinder/views/home/help_settings.dart";
import "package:pathfinder/views/home/history_settings.dart";
import "package:pathfinder/views/home/point_settings.dart";
import "package:pathfinder/views/home/robot_settings.dart";

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

    // On init the selected index may be negative
    if (index < 0) return const SizedBox.shrink();

    if (tabState.ui.selectedType == Robot) {
      return RobotSettings(robot: robot, onRobotEdit: onRobotEdit);
    }

    if (tabState.ui.selectedType == History) {
      return const HistorySettings();
    }

    if (tabState.ui.selectedType == Help) {
      return const HelpSettings();
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
