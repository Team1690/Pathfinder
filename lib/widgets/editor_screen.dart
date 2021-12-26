import 'package:flutter/material.dart';
import 'package:pathfinder/constants.dart';
import 'package:pathfinder/views/timeline.dart';
import 'package:pathfinder/widgets/path_editor/path_editor.dart';

class EditorScreen extends StatefulWidget {
  final Function calculateTrajectory;

  const EditorScreen(this.calculateTrajectory, {Key? key}) : super(key: key);

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
                  flex: 6,
                  child: Padding(
                    padding: const EdgeInsets.all(defaultPadding),
                    child: timeLineView(),
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                            primary: Color(0xff0078D7)),
                        onPressed: () {},
                        icon: Icon(Icons.search),
                        label: Text('Path'),
                      ),
                      SizedBox(height: 10),
                      ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                            primary: Color(0xffD45C36)),
                        onPressed: () {},
                        icon: Icon(Icons.trending_up_rounded),
                        label: Text('Graph'),
                      ),
                      SizedBox(height: 10),
                      ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                            primary: Color(0xffD7AD17)),
                        onPressed: () {
                          widget.calculateTrajectory();
                        },
                        icon: Icon(Icons.trending_flat_rounded),
                        label: Text('Trajectory'),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  width: 350,
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
