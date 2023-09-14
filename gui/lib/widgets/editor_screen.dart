import "package:flutter/material.dart";
import "package:pathfinder/constants.dart";
import "package:pathfinder/store/tab/tab_ui/tab_ui.dart";
import "package:pathfinder/views/timeline.dart";
import "package:pathfinder/widgets/path_editor/path_editor.dart";

class EditorScreen extends StatefulWidget {
  const EditorScreen({
    final Key? key,
    required this.calculateTrajectory,
    required this.trajectoryFileName,
    required this.editTrajectoryFileName,
    required this.openFile,
    required this.saveFile,
    required this.saveFileAs,
    required this.changesSaved,
  }) : super(key: key);
  final Function calculateTrajectory;
  final String trajectoryFileName;
  final Function(String) editTrajectoryFileName;
  final Function() openFile;
  final Function() saveFile;
  final Function() saveFileAs;
  final bool changesSaved;

  @override
  _EditorScreenState createState() => _EditorScreenState();
}

class _EditorScreenState extends State<EditorScreen> {
  final TextEditingController _trajectoryFileNameController =
      TextEditingController(text: "");

  @override
  Widget build(final BuildContext context) {
    _trajectoryFileNameController.text = widget.trajectoryFileName;

    return Container(
      width: 10000,
      color: primary,
      child: Column(
        children: <Widget>[
          pathEditor(),
          Expanded(
            child: Row(
              children: <Widget>[
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
                    children: <Widget>[
                      ConstrainedBox(
                        constraints: const BoxConstraints.tightFor(
                          width: 100,
                          height: 60,
                        ),
                        child: TextField(
                          controller: _trajectoryFileNameController,
                          keyboardType: TextInputType.text,
                          decoration: const InputDecoration(
                            focusColor: white,
                            fillColor: white,
                            hintText: defaultTrajectoryFileName,
                            labelText: "Trajectory File Name",
                            suffixText: ".csv",
                          ),
                          onChanged: (final String value) {
                            widget.editTrajectoryFileName(value);
                            _trajectoryFileNameController.text = value;
                            _trajectoryFileNameController.selection =
                                TextSelection.fromPosition(
                              TextPosition(offset: value.length),
                            );
                          },
                          textAlign: TextAlign.left,
                        ),
                      ),
                      ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xffD7AD17),
                          textStyle:
                              const TextStyle(overflow: TextOverflow.ellipsis),
                        ),
                        onPressed: () {
                          widget.calculateTrajectory();
                        },
                        icon: const Icon(Icons.trending_flat_rounded),
                        label: const Text("Trajectory"),
                      ),
                      const SizedBox(height: 10),
                      ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xff0078D7),
                          textStyle:
                              const TextStyle(overflow: TextOverflow.ellipsis),
                        ),
                        onPressed: widget.openFile,
                        icon: const Icon(Icons.search),
                        label: const Text("Open"),
                      ),
                      const SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Expanded(
                            flex: 1,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: widget.changesSaved
                                    ? const Color.fromARGB(255, 116, 116, 116)
                                    : const Color(0xffD45C36),
                                padding: const EdgeInsets.all(1),
                                textStyle: const TextStyle(
                                  overflow: TextOverflow.clip,
                                ),
                              ),
                              onPressed: widget.saveFile,
                              child: const Icon(Icons.save),
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            flex: 2,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xffD45C36),
                                textStyle: const TextStyle(
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              onPressed: widget.saveFileAs,
                              child: const Text("Save As"),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  width: 350,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
