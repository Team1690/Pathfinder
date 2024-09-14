import "dart:ui";
import "dart:core";
import "dart:io";

import "package:flutter/material.dart";
import "package:flutter_redux/flutter_redux.dart";
import "package:pathfinder/shortcuts/help.dart";
import "package:pathfinder/models/history.dart";
import "package:pathfinder/models/path_point.dart";
import "package:pathfinder/models/robot.dart";
import "package:pathfinder/store/app/app_state.dart";
import "package:pathfinder/store/tab/store.dart";
import "package:pathfinder/views/editor/editor_screen.dart";
import "package:pathfinder/constants.dart";
import "package:path/path.dart" as path;
import "package:pathfinder/views/editor/save_changes_dialog.dart";
import "package:pathfinder/views/home/home_view_model.dart";
import "package:pathfinder/views/home/settings_details.dart";

//TODO: concise + add TODOS
class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
//TODO: these two functions shoudn't exist as all they do is call the same function twice
// instead this logic should be in the reducer itself
  void onPointEdit(
    final int index,
    final PathPoint point,
    final HomeViewModel props,
  ) {
    setState(() {
      props.tabState = editPoint(
        props.tabState,
        EditPoint(
          pointIndex: index,
          position: point.position,
          inControlPoint: point.inControlPoint,
          outControlPoint: point.outControlPoint,
          useHeading: point.useHeading,
          heading: point.heading,
          cutSegment: point.cutSegment,
          isStop: point.isStop,
          action: point.action,
          actionTime: point.actionTime,
        ),
      );
    });

    props.setPointData(index, point);
  }

  void onRobotEdit(final Robot robot, final HomeViewModel props) {
    setState(() {
      props.tabState = editRobot(props.tabState, EditRobot(robot: robot));
    });

    props.setRobot(robot);
  }

  @override
  Widget build(final BuildContext context) =>
      StoreConnector<AppState, HomeViewModel>(
        converter: HomeViewModel.fromStore,
        builder: (final BuildContext context, final HomeViewModel model) =>
            Scaffold(
          body: SafeArea(
            child: Stack(
              fit: StackFit.expand,
              children: <Widget>[
                Column(
                  children: <Widget>[
                    Container(
                      color: secondary,
                      child: Row(
                        children: <Widget>[
                          IconButton(
                            color: Theme.of(context).textTheme.bodyLarge?.color,
                            onPressed: () {
                              model.setSidebarVisibility(true);
                            },
                            tooltip: "Show sidebar",
                            icon: const Icon(Icons.menu),
                          ),
                          IconButton(
                            color: Theme.of(context).textTheme.bodyLarge?.color,
                            onPressed: () {
                              if (!model.changesSaved) {
                                showAlertDialog(
                                  context,
                                  model.newAuto,
                                  model.saveFile,
                                  () {},
                                  "Confirm new auto",
                                  "You have made change, are you sure you want to discard them?",
                                );
                                return;
                              }

                              model.newAuto();
                            },
                            tooltip: "New auto",
                            icon: const Icon(Icons.new_label),
                          ),
                          IconButton(
                            color: Theme.of(context).textTheme.bodyLarge?.color,
                            onPressed: model.pathUndo,
                            tooltip: "Undo",
                            icon: const Icon(Icons.chevron_left_outlined),
                          ),
                          IconButton(
                            color: Theme.of(context).textTheme.bodyLarge?.color,
                            onPressed: model.pathRedo,
                            tooltip: "Redo",
                            icon: const Icon(Icons.chevron_right_outlined),
                          ),
                          IconButton(
                            color: Theme.of(context).textTheme.bodyLarge?.color,
                            onPressed: model.selectRobot,
                            tooltip: "Edit robot",
                            icon: const Icon(Icons.adb),
                          ),
                          IconButton(
                            color: Theme.of(context).textTheme.bodyLarge?.color,
                            onPressed: model.selectHistory,
                            tooltip: "History",
                            icon: const Icon(Icons.history),
                          ),
                          IconButton(
                            color: Theme.of(context).textTheme.bodyLarge?.color,
                            onPressed: model.selectHelp,
                            tooltip: "Help",
                            icon: const Icon(Icons.question_mark_sharp),
                          ),
                          const SizedBox(width: 10),
                          Text(
                            path.dirname(model.autoFileName) +
                                Platform.pathSeparator,
                            style: TextStyle(
                              fontSize: 10,
                              fontStyle: FontStyle.italic,
                              color: Theme.of(context)
                                  .textTheme
                                  .bodyLarge!
                                  .color!
                                  .withOpacity(0.7),
                            ),
                          ),
                          const SizedBox(width: 1),
                          Text(path.basename(model.autoFileName)),
                          if (!model.changesSaved)
                            const Text(
                              " •",
                              style: TextStyle(
                                fontSize: 30,
                                height: 1.1,
                              ),
                            ),
                          const SizedBox(width: 10),
                          ...List<Widget>.generate(
                            model.tabAmount,
                            (final int index) => ElevatedButton(
                              style: ButtonStyle(
                                splashFactory: InkRipple.splashFactory,
                                backgroundColor: WidgetStateProperty.all(
                                  index == model.currentTabIndex
                                      ? Colors.white
                                      : const Color(0),
                                ),
                                shadowColor: WidgetStateProperty.all(
                                  const Color(0),
                                ),
                                surfaceTintColor: WidgetStateProperty.all(
                                  const Color(0),
                                ),
                              ),
                              onLongPress: () {
                                if (model.tabAmount == 1) return;

                                if (!model.changesSaved) {
                                  showAlertDialog(
                                    context,
                                    () =>
                                        model.removeTab(model.currentTabIndex),
                                    model.saveFile,
                                    () {},
                                    "Confirm tab delete",
                                    "Are you sure you want to discard this tab? Please save to back this up",
                                  );
                                } else {
                                  model.removeTab(model.currentTabIndex);
                                }
                              },
                              onPressed: () {
                                model.changeTab(index);
                              },
                              child: Text(
                                "$index",
                                style: TextStyle(
                                  color: index == model.currentTabIndex
                                      ? Colors.lightGreen
                                      : null,
                                ),
                              ),
                            ),
                          ),
                          IconButton(
                            onPressed: model.addTab,
                            icon: const Icon(Icons.add),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: EditorScreen(
                        calculateTrajectory: model.calculateTrajectory,
                        trajectoryFileName: model.trajectoryFileName,
                        editTrajectoryFileName: model.editTrajectoryFileName,
                        openFile: model.openFile,
                        saveFile: model.saveFile,
                        saveFileAs: model.saveFileAs,
                        changesSaved: model.changesSaved,
                      ),
                    ),
                  ],
                ),
                if (model.isSidebarOpen)
                  Positioned(
                    right: 0,
                    top: 0,
                    width: 300,
                    height: MediaQuery.of(context).size.height,
                    child: ClipRect(
                      child: BackdropFilter(
                        filter: new ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                        child: Container(
                          width: 300,
                          height: MediaQuery.of(context).size.height,
                          color:
                              Theme.of(context).primaryColor.withOpacity(0.5),
                          child: Stack(
                            children: <Widget>[
                              ListView(
                                padding: EdgeInsets.zero,
                                children: <Widget>[
                                  ListTile(
                                    // textColor: Theme.of(context).textTheme.headline1?.color,
                                    title: Text(
                                        getSideBarHeadline(model.tabState)),
                                  ),
                                  Divider(
                                    indent: 15,
                                    endIndent: 15,
                                    color: Theme.of(context)
                                        .textTheme
                                        .displayLarge
                                        ?.color,
                                    thickness: 0.5,
                                  ),
                                  SettingsDetails(
                                    tabState: model.tabState,
                                    onPointEdit: (
                                      final int pointIndex,
                                      final PathPoint pathPoint,
                                    ) {
                                      onPointEdit(pointIndex, pathPoint, model);
                                    },
                                    onRobotEdit: (final Robot robot) {
                                      onRobotEdit(robot, model);
                                    },
                                  ),
                                ],
                              ),
                              Positioned(
                                right: 5,
                                top: 5,
                                child: IconButton(
                                  color: Theme.of(context)
                                      .textTheme
                                      .displayLarge
                                      ?.color,
                                  onPressed: () {
                                    model.setSidebarVisibility(false);
                                  },
                                  icon: const Icon(Icons.exit_to_app_rounded),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
      );
}

String getSideBarHeadline(final TabState tabState) {
  final int selectedIndex = tabState.ui.selectedIndex;
  final Type selectedType = tabState.ui.selectedType;

  if (selectedType == Robot) return "ROBOT DATA";
  if (selectedType == PathPoint && selectedIndex > -1)
    return "POINT $selectedIndex";
  if (selectedType == History) return "HISTORY";
  if (selectedType == Help) return "HELP";
  return "NO SELECTION";
}
