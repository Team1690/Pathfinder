import 'package:flutter/material.dart';
import 'package:pathfinder/constants.dart';
import 'package:pathfinder/views/timeline.dart';
import 'package:pathfinder/main.dart';
import 'package:pathfinder/services/pathfinder.dart';
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
          pathEditor(),
          Expanded(
            child: Row(
              children: [
                Expanded(
                  flex: 4,
                  child: Padding(
                    padding: const EdgeInsets.all(defaultPadding),
                    child: timeLineView(),
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
                          onPressed: () {
                            PathFinderService.calculateTrjactory(
                              store.state.tabState.path.points,
                              store.state.tabState.path.segments,
                              store.state.tabState.robot,
                            );
                          },
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
