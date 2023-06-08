import "package:flutter/cupertino.dart";
import "package:pathfinder/utils/json.dart";

const String autoFileExtension = "auto";
const String defaultTrajectoryFileName = "output";
const String defaultAutoFileName = "untitled.$autoFileExtension";

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
    required this.autoFileName,
    required this.changesSaved,
    this.serverError,
  });
  // Json
  TabUI.fromJson(final Map<String, dynamic> json)
      : selectedIndex = -1,
        selectedType = Null,
        isSidebarOpen = json["isSidebarOpen"] as bool,
        fieldSizePixels =
            offsetFromJson(json["fieldSizePixels"] as Map<String, dynamic>),
        isGraphPageOpen = json["isGraphPageOpen"] as bool,
        zoomLevel = json["zoomLevel"] as double,
        pan = offsetFromJson(json["pan"] as Map<String, dynamic>),
        headingToggle = json["headingToggle"] as bool,
        controlToggle = json["controlToggle"] as bool,
        serverError = null,
        trajectoryFileName = (json["trajectoryFileName"] as String?) ??
            defaultTrajectoryFileName,
        autoFileName = (json["autoFileName"] as String?) ?? defaultAutoFileName,
        changesSaved = (json["changesSaved"] as bool?) ?? true;
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
        autoFileName: defaultAutoFileName,
        changesSaved: true,
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
  final String? serverError;
  final String trajectoryFileName;
  final String autoFileName;
  final bool changesSaved;

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
    final String? autoFileName,
    final bool? changesSaved,
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
        serverError: serverError ?? this.serverError,
        trajectoryFileName: trajectoryFileName ?? this.trajectoryFileName,
        autoFileName: autoFileName ?? this.autoFileName,
        changesSaved: changesSaved ?? this.changesSaved,
      );

  Map<String, dynamic> toJson() => <String, dynamic>{
        // TODO: Serliaize these
        // 'selectedIndex': selectedIndex,
        // 'selectedType': selectedType,
        "isSidebarOpen": isSidebarOpen,
        "fieldSizePixels": offsetToJson(fieldSizePixels),
        "isGraphPageOpen": isGraphPageOpen,
        "zoomLevel": zoomLevel,
        "pan": offsetToJson(pan),
        "headingToggle": headingToggle,
        "controlToggle": controlToggle,
        "trajectoryFileName": trajectoryFileName,
        "autoFileName": autoFileName,
        "changesSaved": changesSaved,
      };
}
