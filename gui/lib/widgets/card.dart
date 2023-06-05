import "package:flutter/material.dart";
import "package:pathfinder/constants.dart";

class PropertiesCard extends StatelessWidget {
  const PropertiesCard({final Key? key, required this.body}) : super(key: key);
  final Widget body;

  @override
  Widget build(final BuildContext context) => Container(
        decoration: const BoxDecoration(
          color: secondaryColor,
          borderRadius: BorderRadius.all(Radius.circular(10)),
        ),
        child: Center(
          child: Column(
            children: <Widget>[
              Expanded(child: body),
            ],
          ),
        ),
      );
}
