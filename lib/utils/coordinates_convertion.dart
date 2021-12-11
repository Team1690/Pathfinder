import 'package:flutter/cupertino.dart';
import 'package:pathfinder/store/tab/store.dart';
import 'package:redux/redux.dart';

Offset uiToMetersCoord(Store store, Offset val) {
  TabState tabState = store.state.tabState;

  final xScaler = tabState.field.size.dx / tabState.ui.fieldSizePixels.dx;
  final yScaler = tabState.field.size.dy / tabState.ui.fieldSizePixels.dy;

  return val.scale(xScaler, yScaler);
}

Offset metersToUiCoord(Store store, Offset val) {
  TabState tabState = store.state.tabState;

  final xScaler = tabState.ui.fieldSizePixels.dx / tabState.field.size.dx;
  final yScaler = tabState.ui.fieldSizePixels.dy / tabState.field.size.dy;

  return val.scale(xScaler, yScaler);
}
