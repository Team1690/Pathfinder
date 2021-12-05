// import 'dart:ffi';

import 'package:flutter/cupertino.dart';

@immutable
class TabUI {
  final int selectedIndex;
  final Type selectedType;
  final bool isSidebarOpen;
  final bool isGraphPageOpen;
  final double zoomLevel;
  final Offset pan;
  final String? serverError;

  const TabUI({
    required this.selectedIndex,
    required this.selectedType,
    required this.isSidebarOpen,
    required this.isGraphPageOpen,
    required this.zoomLevel,
    required this.pan,
    this.serverError,
  });

  factory TabUI.initial() {
    return TabUI(
      selectedIndex: -1,
      selectedType: Null,
      isSidebarOpen: false,
      isGraphPageOpen: false,
      zoomLevel: 1,
      pan: Offset(0, 0),
    );
  }

  TabUI copyWith({
    int? selectedIndex,
    Type? selectedType,
    bool? isSidebarOpen,
    bool? isGraphPageOpen,
    double? zoomLevel,
    Offset? pan,
    String? serverError,
  }) {
    return TabUI(
      selectedIndex: selectedIndex ?? this.selectedIndex,
      selectedType: selectedType ?? this.selectedType,
      isSidebarOpen: isSidebarOpen ?? this.isSidebarOpen,
      isGraphPageOpen: isGraphPageOpen ?? this.isGraphPageOpen,
      zoomLevel: zoomLevel ?? this.zoomLevel,
      pan: pan ?? this.pan,
      serverError: serverError ?? this.serverError,
    );
  }
}
