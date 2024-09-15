import "package:flutter/material.dart";
import "package:orbit_card_settings/card_settings.dart";
import "package:pathfinder/models/robot.dart";
import "package:pathfinder/views/home/settings_details.dart";

class RobotSettings extends StatelessWidget {
  const RobotSettings({
    super.key,
    required this.robot,
    required this.onRobotEdit,
  });

  final Robot robot;
  final void Function(Robot) onRobotEdit;

  @override
  Widget build(final BuildContext context) => CardSettings(
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
