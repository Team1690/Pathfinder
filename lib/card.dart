import 'package:flutter/material.dart';
import "package:pathfinder/constants.dart";

class PropertiesCard extends StatelessWidget {
  final Widget body;
  const PropertiesCard({Key? key, required this.body}) : super(key: key);

  @override
  Widget build(final BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: secondaryColor,
        borderRadius: BorderRadius.all(Radius.circular(10)),
      ),
      child: Center(
        child: Column(
          children: [
            Expanded(child: body),
          ],
        ),
      ),
    );
  }
}
