import "package:flutter/cupertino.dart";
import "package:pathfinder/field_constants.dart";
import "package:pathfinder/utils/offset_extensions.dart";

//TODO: move to constants
const String defaultTrajectoryFileName = "output";

@immutable
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
  // Json
  TabUI.fromJson(final Map<String, dynamic> json)
      : selectedIndex = -1,
        selectedType = Null,
        isSidebarOpen = json["isSidebarOpen"] as bool,
        fieldSizePixels = OffsetJson.fromJson(
            json["fieldSizePixels"] as Map<String, dynamic>),
        zoomLevel = json["zoomLevel"] as double,
        pan = OffsetJson.fromJson(json["pan"] as Map<String, dynamic>),
        headingToggle = json["headingToggle"] as bool,
        controlToggle = json["controlToggle"] as bool,
        trajectoryFileName = (json["trajectoryFileName"] as String?) ??
            defaultTrajectoryFileName;
  factory TabUI.initial() => const TabUI(
        selectedIndex: -1,
        selectedType: Null,
        isSidebarOpen: false,
        //TODO: this should be relative to size of screen currently it doesn't seem like that
        fieldSizePixels: Offset(800, 400),
        zoomLevel: 1,
        headingToggle: false,
        controlToggle: false,
        pan: Offset.zero,
        trajectoryFileName: defaultTrajectoryFileName,
      );
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
    final bool? isGraphPageOpen,
    final double? zoomLevel,
    final Offset? pan,
    final bool? headingToggle,
    final bool? controlToggle,
    final String? serverError,
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

  Map<String, dynamic> toJson() => <String, dynamic>{
        // TODO: Serliaize these
        // 'selectedIndex': selectedIndex,
        // 'selectedType': selectedType,
        "isSidebarOpen": isSidebarOpen,
        "fieldSizePixels": fieldSizePixels.toJson(),
        "zoomLevel": zoomLevel,
        "pan": pan.toJson(),
        "headingToggle": headingToggle,
        "controlToggle": controlToggle,
        "trajectoryFileName": trajectoryFileName,
      };
//TODO: these two functions can be even nicer and shorter
//
//TODO: think of a way to do this conversion without using the store
//probably i think make a global function that has context param and use mediaquery
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
