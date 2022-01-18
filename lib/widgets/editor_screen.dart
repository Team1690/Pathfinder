import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:pathfinder/constants.dart';
import 'package:pathfinder/store/app/app_reducer.dart';
import 'package:pathfinder/store/tab/tab_ui/tab_ui.dart';
import 'package:pathfinder/views/timeline.dart';
import 'package:pathfinder/widgets/path_editor/path_editor.dart';

class EditorScreen extends StatefulWidget {
  final Function calculateTrajectory;
  final String trajectoryFileName;
  final Function(String) editTrajectoryFileName;
  final Function() openFile;
  final Function() saveFile;

  const EditorScreen({
    Key? key,
    required this.calculateTrajectory,
    required this.trajectoryFileName,
    required this.editTrajectoryFileName,
    required this.openFile,
    required this.saveFile,
  }) : super(key: key);

  @override
  _EditorScreenState createState() => _EditorScreenState();
}

class _EditorScreenState extends State<EditorScreen> {
  final TextEditingController _trajectoryFileNameController =
      TextEditingController(text: '');

  @override
  Widget build(BuildContext context) {
    _trajectoryFileNameController.text = widget.trajectoryFileName;

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
                      ConstrainedBox(
                        constraints:
                            BoxConstraints.tightFor(width: 100, height: 60),
                        child: TextField(
                          controller: _trajectoryFileNameController,
                          keyboardType: TextInputType.text,
                          decoration: InputDecoration(
                            focusColor: white,
                            fillColor: white,
                            hintText: defaultTrajectoryFileName,
                            labelText: 'Trajectory File Name',
                            suffixText: '.csv',
                          ),
                          onChanged: (value) {
                            widget.editTrajectoryFileName(value);
                            _trajectoryFileNameController.text = value;
                            _trajectoryFileNameController.selection =
                                TextSelection.fromPosition(
                                    TextPosition(offset: value.length));
                          },
                          textAlign: TextAlign.left,
                        ),
                      ),
                      ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                            primary: Color(0xffD7AD17)),
                        onPressed: () {
                          widget.calculateTrajectory();
                        },
                        icon: Icon(Icons.trending_flat_rounded),
                        label: Text('Trajectory'),
                      ),
                      SizedBox(height: 10),
                      ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                            primary: Color(0xff0078D7)),
                        onPressed: widget.openFile,
                        icon: Icon(Icons.search),
                        label: Text('Open'),
                      ),
                      SizedBox(height: 10),
                      ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                            primary: Color(0xffD45C36)),
                        onPressed: widget.saveFile,
                        icon: Icon(Icons.save),
                        label: Text('Save'),
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
