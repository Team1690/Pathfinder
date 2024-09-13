import "package:flutter/material.dart";
import "package:pathfinder/constants.dart";
import "package:pathfinder/models/tab_ui.dart";
import "package:pathfinder/utils/sendFileOverSSH.dart";

class FileButtons extends StatefulWidget {
  const FileButtons({
    super.key,
    required this.calculateTrajectory,
    required this.trajectoryFileName,
    required this.editTrajectoryFileName,
    required this.openFile,
    required this.saveFile,
    required this.saveFileAs,
    required this.changesSaved,
  });

  final void Function() calculateTrajectory;
  final String trajectoryFileName;
  final Function(String) editTrajectoryFileName;
  final Function() openFile;
  final Function() saveFile;
  final Function() saveFileAs;
  final bool changesSaved;

  @override
  State<FileButtons> createState() => _FileButtonsState();
}

class _FileButtonsState extends State<FileButtons> {
  late final TextEditingController _trajectoryFileNameController =
      TextEditingController(text: widget.trajectoryFileName);
  @override
  Widget build(final BuildContext context) => Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Row(
            children: <Widget>[
              Expanded(
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
                  onChanged: widget.editTrajectoryFileName,
                  onTap: () {
                    _trajectoryFileNameController.selection =
                        TextSelection.fromPosition(
                      TextPosition(
                        offset: _trajectoryFileNameController.text.length,
                      ),
                    );
                  },
                  textAlign: TextAlign.left,
                ),
              ),
            ],
          ),
          const SizedBox(
            height: defaultPadding / 2,
          ),
          Row(
            children: <Widget>[
              Expanded(
                child: ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xffD7AD17),
                    textStyle: const TextStyle(
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  onPressed: widget.calculateTrajectory,
                  icon: const Icon(Icons.trending_flat_rounded),
                  label: const Text("Trajectory"),
                ),
              ),
              const SizedBox(
                width: defaultPadding / 2,
              ),
              Expanded(
                child: ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xff0078D7),
                    textStyle: const TextStyle(
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  onPressed: widget.openFile,
                  icon: const Icon(Icons.search),
                  label: const Text("Open"),
                ),
              ),
            ],
          ),
          const SizedBox(
            height: defaultPadding / 2,
          ),
          Row(
            children: <Widget>[
              Expanded(
                child: ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xff0078D7),
                    textStyle: const TextStyle(
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  onPressed: () => sendToRobot(context),
                  icon: const Icon(Icons.send),
                  label: const Text("Send File"),
                ),
              ),
              const SizedBox(
                width: defaultPadding / 2,
              ),
              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Expanded(
                      flex: 1,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: widget.changesSaved
                              ? const Color.fromARGB(
                                  255,
                                  116,
                                  116,
                                  116,
                                )
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
                    const SizedBox(
                      width: defaultPadding / 2,
                    ),
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
              ),
            ],
          ),
        ],
      );
}
