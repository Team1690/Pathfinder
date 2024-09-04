import "package:flutter/cupertino.dart";
import "package:pathfinder/field_constants.dart";
import "package:pathfinder/store/app/app_state.dart";
import "package:pathfinder/store/tab/store.dart";
import "package:redux/redux.dart";

//TODO: i don't like the fact that these functions have the store as a parameter it is better i think if maybe they just accept an offset
Offset pixToMeters(final Store<AppState> store, final Offset val) {
  final TabState tabState = store.state.tabState[store.state.currentTabIndex];

  final double xScaler = officialFieldWidth / tabState.ui.fieldSizePixels.dx;
  final double yScaler = officialFieldHeight / tabState.ui.fieldSizePixels.dy;

  return val.scale(xScaler, yScaler);
}

Offset metersToPix(final Store<AppState> store, final Offset val) {
  final TabState tabState = store.state.tabState[store.state.currentTabIndex];

  final double xScaler = tabState.ui.fieldSizePixels.dx / officialFieldWidth;
  final double yScaler = tabState.ui.fieldSizePixels.dy / officialFieldHeight;

  return val.scale(xScaler, yScaler);
}

Offset flipYAxisByField(Offset val, final Offset fieldSizePixels) {
  val = val.translate(0, -fieldSizePixels.dy);
  val = val.scale(1, -1);
  return val;
}

Offset flipYAxis(final Offset val) => val.scale(1, -1);
