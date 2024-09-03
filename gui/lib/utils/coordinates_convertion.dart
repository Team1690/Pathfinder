import "package:flutter/cupertino.dart";
import "package:pathfinder/store/app/app_state.dart";
import "package:pathfinder/store/tab/store.dart";
import "package:redux/redux.dart";

//TODO: i don't like the fact that these functions have the store as a parameter it is better i think if maybe they just accept an offset
Offset uiToMetersCoord(final Store<AppState> store, final Offset val) {
  final TabState tabState = store.state.tabState[store.state.currentTabIndex];

  final double xScaler =
      tabState.field.size.dx / tabState.ui.fieldSizePixels.dx;
  final double yScaler =
      tabState.field.size.dy / tabState.ui.fieldSizePixels.dy;

  return val.scale(xScaler, yScaler);
}

Offset metersToUiCoord(final Store<AppState> store, final Offset val) {
  final TabState tabState = store.state.tabState[store.state.currentTabIndex];

  final double xScaler =
      tabState.ui.fieldSizePixels.dx / tabState.field.size.dx;
  final double yScaler =
      tabState.ui.fieldSizePixels.dy / tabState.field.size.dy;

  return val.scale(xScaler, yScaler);
}

Offset uiToFieldOrigin(final Store<AppState> store, final Offset val) => val;

Offset fieldToUiOrigin(final Store<AppState> store, final Offset val) => val;

Offset flipYAxisByField(Offset val, final Offset fieldSizePixels) {
  val = val.translate(0, -fieldSizePixels.dy);
  val = val.scale(1, -1);
  return val;
}

Offset flipYAxis(final Offset val) => val.scale(1, -1);
