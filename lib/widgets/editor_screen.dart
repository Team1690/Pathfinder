import 'package:flutter/material.dart';
import 'package:pathfinder/constants.dart';
import 'package:pathfinder/widgets/path_editor/path_editor.dart';

class EditorScreen extends StatefulWidget {
  const EditorScreen({Key? key}) : super(key: key);

  @override
  _EditorScreenState createState() => _EditorScreenState();
}

class _EditorScreenState extends State<EditorScreen> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 10000,
      color: primary,
      child: Column(
        children: [
          Container(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(200, 30, 200, 30),
              child: Container(
                child: PathEditor(),
                decoration: BoxDecoration(boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.5),
                    spreadRadius: 2,
                    blurRadius: 14,
                    offset: Offset(0, 4), // changes position of shadow
                  ),
                ]),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
