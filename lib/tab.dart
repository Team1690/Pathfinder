import 'package:flutter/material.dart';
import 'package:pathfinder/constants.dart';

class BroswerTab extends StatelessWidget {
  final String name;
  final bool activated;
  const BroswerTab({required this.name, required this.activated, Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 35,
      width: 250,
      decoration: BoxDecoration(
        color: activated ? primary : secondary,
        borderRadius: BorderRadius.vertical(
          top: activated ? Radius.circular(10) : Radius.circular(0),
          bottom: activated ? Radius.circular(0) : Radius.circular(10),
        ),
      ),
      child: Row(
        children: [
          SizedBox(width: 20),
          Expanded(
              flex: 5,
              child: Text(
                name,
                style: TextStyle(color: white),
              )),
          Expanded(
              child: IconButton(
            color: Colors.grey[300],
            icon: Icon(Icons.disabled_by_default_rounded),
            iconSize: 16,
            onPressed: () {},
          ))
        ],
      ),
    );
  }
}
