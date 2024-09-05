import "package:flutter/cupertino.dart";
import "package:pathfinder/utils/offset_extensions.dart";

const String defaultTrajectoryFileName = "output";

@immutable
class TabUI {
  const TabUI({
    required this.selectedIndex,
    required this.selectedType,
    required this.isSidebarOpen,
    required this.fieldSizePixels,
    required this.isGraphPageOpen,
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
        isGraphPageOpen = json["isGraphPageOpen"] as bool,
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
        fieldSizePixels: Offset(800, 400),
        isGraphPageOpen: false,
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
  final bool isGraphPageOpen;
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
        isGraphPageOpen: isGraphPageOpen ?? this.isGraphPageOpen,
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
        "isGraphPageOpen": isGraphPageOpen,
        "zoomLevel": zoomLevel,
        "pan": pan.toJson(),
        "headingToggle": headingToggle,
        "controlToggle": controlToggle,
        "trajectoryFileName": trajectoryFileName,
      };
}
