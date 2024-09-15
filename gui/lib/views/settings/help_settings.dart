import "package:flutter/material.dart";
import "package:orbit_card_settings/helpers/platform_functions.dart";
import "package:pathfinder/shortcuts/shortcut.dart";
import "package:pathfinder/shortcuts/shortcut_def.dart";

class HelpSettings extends StatelessWidget {
  const HelpSettings({super.key});

  @override
  Widget build(final BuildContext context) => Container(
        child: Card(
          margin: const EdgeInsets.all(8),
          child: Column(
            children: <Widget>[
              ListView(
                controller: ScrollController(),
                scrollDirection: Axis.vertical,
                shrinkWrap: true,
                children: shortcuts.reversed
                    .map(
                      (final Shortcut e) => ListTile(
                        dense: true,

                        leading: e.icon ??
                            const Icon(
                              Icons.circle_rounded,
                              size: 10,
                            ),

                        // Seperate the name by capital letter (EditPoint -> Edit Point)
                        title: Text(
                          "${e.shortcut} : \n${e.description}",
                          style: labelStyle(context, true),
                        ),
                      ),
                    )
                    .expand(
                      (final ListTile element) =>
                          <Widget>[element, const Divider()],
                    )
                    .toList(),
              ),
            ],
          ),
        ),
      );
}
