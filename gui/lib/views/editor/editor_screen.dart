import "package:flutter/material.dart";
import "package:pathfinder_gui/constants.dart";
import "package:pathfinder_gui/views/editor/file_buttons.dart";
import "package:pathfinder_gui/views/editor/timeline/time_line_view.dart";
import "package:pathfinder_gui/views/editor/path_editor/path_editor.dart";

class EditorScreen extends StatefulWidget {
  const EditorScreen({
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
  _EditorScreenState createState() => _EditorScreenState();
}

class _EditorScreenState extends State<EditorScreen> {
  @override
  Widget build(final BuildContext context) => Container(
        color: primary,
        child: Column(
          children: <Widget>[
            Expanded(
              child: AspectRatio(
                child: PathEditor(),
                aspectRatio: officialFieldWidth / officialFieldHeight,
              ),
            ),
            Row(
              children: <Widget>[
                Expanded(
                  flex: 6,
                  child: Padding(
                    padding: const EdgeInsets.all(defaultPadding),
                    child: TimeLineView(),
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: FileButtons(
                    calculateTrajectory: widget.calculateTrajectory,
                    trajectoryFileName: widget.trajectoryFileName,
                    editTrajectoryFileName: widget.editTrajectoryFileName,
                    openFile: widget.openFile,
                    saveFile: widget.saveFile,
                    saveFileAs: widget.saveFileAs,
                    changesSaved: widget.changesSaved,
                  ),
                ),
                const SizedBox(
                  width: defaultPadding,
                ),
              ],
            ),
            const SizedBox(
              height: defaultPadding / 2,
            ),
          ],
        ),
      );
}
