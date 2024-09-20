import "package:flutter/cupertino.dart";
import "package:pathfinder/constants.dart";

//TODO: move to constants
const String defaultTrajectoryFileName = "output";

class TabUI {
  const TabUI({
    required this.selectedIndex,
    required this.selectedType,
    required this.isSidebarOpen,
    required this.fieldSizePixels,
    required this.zoomLevel,
    required this.pan,
    required this.headingToggle,
    required this.controlToggle,
    required this.trajectoryFileName,
  });

  factory TabUI.initial() => const TabUI(
        selectedIndex: -1,
        selectedType: Null,
        isSidebarOpen: false,
        fieldSizePixels: Offset(800, 400),
        zoomLevel: 1,
        pan: Offset.zero,
        headingToggle: false,
        controlToggle: false,
        trajectoryFileName: defaultTrajectoryFileName,
      );

  TabUI.fromJson(final dynamic json)
      : selectedIndex = -1,
        selectedType = Null,
        isSidebarOpen = false,
        fieldSizePixels = const Offset(800, 400),
        zoomLevel = 1,
        pan = Offset.zero,
        headingToggle = false,
        controlToggle = false,
        trajectoryFileName = json["trajectoryFileName"] as String;

  final int selectedIndex;
  final Type selectedType;
  final bool isSidebarOpen;
  final Offset fieldSizePixels;
  final double zoomLevel;
  final Offset pan;
  final bool headingToggle;
  final bool controlToggle;
  final String trajectoryFileName;

  TabUI copyWith({
    final int? selectedIndex,
    final Type? selectedType,
    final bool? isSidebarOpen,
    final Offset? fieldSizePixels,
    final double? zoomLevel,
    final Offset? pan,
    final bool? headingToggle,
    final bool? controlToggle,
    final String? trajectoryFileName,
  }) =>
      TabUI(
        selectedIndex: selectedIndex ?? this.selectedIndex,
        selectedType: selectedType ?? this.selectedType,
        isSidebarOpen: isSidebarOpen ?? this.isSidebarOpen,
        fieldSizePixels: fieldSizePixels ?? this.fieldSizePixels,
        zoomLevel: zoomLevel ?? this.zoomLevel,
        pan: pan ?? this.pan,
        headingToggle: headingToggle ?? this.headingToggle,
        controlToggle: controlToggle ?? this.controlToggle,
        trajectoryFileName: trajectoryFileName ?? this.trajectoryFileName,
      );

  dynamic toJson() => <String, dynamic>{
        "trajectoryFileName": trajectoryFileName,
      };
//TODO: these two functions can be even nicer and shorter
//
//TODO: think of a way to do this conversion without using the store
  Offset pixToMeters(final Offset val) {
    final double xScaler = officialFieldWidth / fieldSizePixels.dx;
    final double yScaler = officialFieldHeight / fieldSizePixels.dy;

    return val.scale(xScaler, yScaler);
  }

  Offset metersToPix(final Offset val) {
    final double xScaler = fieldSizePixels.dx / officialFieldWidth;
    final double yScaler = fieldSizePixels.dy / officialFieldHeight;

    return val.scale(xScaler, yScaler);
  }
}
