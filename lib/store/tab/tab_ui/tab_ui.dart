import 'package:flutter/cupertino.dart';
import 'package:pathfinder/utils/json.dart';

const defaultTrajectoryFileName = "output";
const defaultAutoFileName = "new-auto";

@immutable
class TabUI {
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

  factory TabUI.initial() {
    return TabUI(
      selectedIndex: -1,
      selectedType: Null,
      isSidebarOpen: false,
      fieldSizePixels: Offset(800, 400),
      isGraphPageOpen: false,
      zoomLevel: 1,
      headingToggle: false,
      controlToggle: false,
      pan: Offset(0, 0),
      trajectoryFileName: defaultTrajectoryFileName,
      autoFileName: defaultAutoFileName,
      changesSaved: true,
    );
  }

  TabUI copyWith({
    int? selectedIndex,
    Type? selectedType,
    bool? isSidebarOpen,
    Offset? fieldSizePixels,
    bool? isGraphPageOpen,
    double? zoomLevel,
    Offset? pan,
    bool? headingToggle,
    bool? controlToggle,
    String? serverError,
    String? trajectoryFileName,
    String? autoFileName,
    bool? changesSaved,
  }) {
    return TabUI(
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
  }

  // Json
  TabUI.fromJson(Map<String, dynamic> json)
      : selectedIndex = -1,
        selectedType = Null,
        isSidebarOpen = json['isSidebarOpen'],
        fieldSizePixels = offsetFromJson(json['fieldSizePixels']),
        isGraphPageOpen = json['isGraphPageOpen'],
        zoomLevel = json['zoomLevel'],
        pan = offsetFromJson(json['pan']),
        headingToggle = json['headingToggle'],
        controlToggle = json['controlToggle'],
        serverError = null,
        trajectoryFileName =
            json['trajectoryFileName'] ?? defaultTrajectoryFileName,
        autoFileName = json['autoFileName'] ?? defaultAutoFileName,
        changesSaved = json['changesSaved'] ?? true;

  Map<String, dynamic> toJson() {
    return {
      // TODO: Serliaize these
      // 'selectedIndex': selectedIndex,
      // 'selectedType': selectedType,
      'isSidebarOpen': isSidebarOpen,
      'fieldSizePixels': offsetToJson(fieldSizePixels),
      'isGraphPageOpen': isGraphPageOpen,
      'zoomLevel': zoomLevel,
      'pan': offsetToJson(pan),
      'headingToggle': headingToggle,
      'controlToggle': controlToggle,
      'trajectoryFileName': trajectoryFileName,
      'autoFileName': autoFileName,
      'changesSaved': changesSaved,
    };
  }
}
