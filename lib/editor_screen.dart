import 'package:flutter/material.dart';
import 'package:pathfinder/constants.dart';
import 'package:pathfinder/path_editor/path_editor.dart';
import 'package:pathfinder/timeline.dart';

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
          Expanded(
            child: Row(
              children: [
                Expanded(
                  flex: 3,
                  child: Padding(
                    padding: const EdgeInsets.all(defaultPadding),
                    child: PathTimeline(
                      points: List.generate(
                          8,
                          (index) => TimelinePoint(
                              onTap: () {}, color: Color(0xffE1E1E1CC))),
                    ),
                  ),
                ),
                Expanded(flex: 1, child: Container())
              ],
            ),
          ),
        ],
      ),
    );
  }
}
