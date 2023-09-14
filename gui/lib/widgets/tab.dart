import "package:flutter/material.dart";
import "package:pathfinder/constants.dart";

class BroswerTab extends StatelessWidget {
  const BroswerTab({
    required this.name,
    required this.activated,
    final Key? key,
  }) : super(key: key);
  final String name;
  final bool activated;

  @override
  Widget build(final BuildContext context) => Container(
        height: 35,
        width: 250,
        decoration: BoxDecoration(
          color: activated ? primary : secondary,
          borderRadius: BorderRadius.vertical(
            top: activated ? const Radius.circular(10) : Radius.zero,
            bottom: activated ? Radius.zero : const Radius.circular(10),
          ),
        ),
        child: Row(
          children: <Widget>[
            const SizedBox(width: 20),
            Expanded(
              flex: 5,
              child: Text(
                name,
                style: const TextStyle(color: white),
              ),
            ),
            Expanded(
              child: IconButton(
                color: Colors.grey[300],
                icon: const Icon(Icons.disabled_by_default_rounded),
                iconSize: 16,
                onPressed: () {},
              ),
            ),
          ],
        ),
      );
}
