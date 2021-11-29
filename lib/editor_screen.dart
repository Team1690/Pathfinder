import 'dart:math';

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
                  flex: 4,
                  child: Padding(
                    padding: const EdgeInsets.all(defaultPadding),
                    child: PathTimeline(
                      segments: List.generate(
                          3,
                          (index) => TimeLineSegment(
                              color: Random().nextBool() ? blue : red,
                              velocity: Random().nextInt(5).roundToDouble(),
                              points: List.generate(
                                  Random().nextBool() ? 3 : 5,

                                  // 5,
                                  (index) => TimelinePoint(
                                      onTap: () {},
                                      color: Color(0xffE1E1E1CC))))),
                    ),
                  ),
                ),
                Expanded(
                    flex: 2,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        ElevatedButton.icon(
                          onPressed: () {},
                          icon: Icon(Icons.travel_explore),
                          label: Text('Path'),
                        ),
                        ElevatedButton.icon(
                          onPressed: () {},
                          icon: Icon(Icons.trending_flat_rounded),
                          label: Text('Trajectory'),
                        ),
                        ElevatedButton.icon(
                          onPressed: () {},
                          icon: Icon(Icons.trending_up_rounded),
                          label: Text('Graph'),
                        )
                      ],
                    ))
              ],
            ),
          ),
        ],
      ),
    );
  }
}
