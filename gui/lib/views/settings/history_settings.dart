import "package:collection/collection.dart";
import "package:flutter/material.dart";
import "package:flutter_redux/flutter_redux.dart";
import "package:orbit_card_settings/helpers/platform_functions.dart";
import "package:pathfinder/models/history.dart";
import "package:pathfinder/store/app/app_state.dart";
import "package:pathfinder/store/tab/store.dart";
import "package:redux/redux.dart";

class HistorySettings extends StatelessWidget {
  const HistorySettings({super.key});

  @override
  Widget build(final BuildContext context) =>
      StoreConnector<AppState, TabState>(
        converter: (final Store<AppState> store) => store.state.currentTabState,
        builder: (final BuildContext context, final TabState tabState) =>
            Container(
          child: Card(
            margin: const EdgeInsets.all(8),
            child: Column(
              children: <Widget>[
                ListView(
                  scrollDirection: Axis.vertical,
                  shrinkWrap: true,
                  children: tabState.history.pathHistory.reversed
                      .mapIndexed(
                        (final int index, final HistoryStamp e) => ListTile(
                          dense: true,
                          enabled: index <= tabState.history.currentStateIndex,
                          leading: Icon(
                            actionToIcon[e.action] ??
                                Icons.device_unknown_outlined,
                          ),

                          // Seperate the name by capital letter (EditPoint -> Edit Point)
                          title: Text(
                            (e.action.split(RegExp(r"(?=[A-Z])")).join(" ")),
                            style: labelStyle(context, true),
                          ),
                        ),
                      )
                      .toList(),
                ),
              ],
            ),
          ),
        ),
      );
}
