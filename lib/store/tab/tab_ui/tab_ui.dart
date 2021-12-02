// import 'dart:ffi';

import 'package:flutter/cupertino.dart';

@immutable
class TabUI {
  final int selectIndex;
  final Type selectedType;
  final bool isSidebarOpen;
  final bool isGraphPageOpen;
  final double zoomLevel;
  final Offset pan;

  const TabUI({
    required this.selectIndex,
    required this.selectedType,
    required this.isSidebarOpen,
    required this.isGraphPageOpen,
    required this.zoomLevel,
    required this.pan,
  });

  factory TabUI.initial() {
    return TabUI(
      selectIndex: -1,
      selectedType: Null,
      isSidebarOpen: false,
      isGraphPageOpen: false,
      zoomLevel: 1,
      pan: Offset(0, 0),
    );
  }

  TabUI copyWith({
    int? selectIndex,
    Type? selectedType,
    bool? isSidebarOpen,
    bool? isGraphPageOpen,
    double? zoomLevel,
    Offset? pan,
  }) {
    return TabUI(
      selectIndex: selectIndex ?? this.selectIndex,
      selectedType: selectedType ?? this.selectedType,
      isSidebarOpen: isSidebarOpen ?? this.isSidebarOpen,
      isGraphPageOpen: isGraphPageOpen ?? this.isGraphPageOpen,
      zoomLevel: zoomLevel ?? this.zoomLevel,
      pan: pan ?? this.pan,
    );
  }
}
