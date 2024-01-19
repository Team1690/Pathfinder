import "dart:ui";

import "package:flutter/material.dart";
import "dart:core";
import "dart:io";
import "package:pathfinder/main.dart";
import "package:pathfinder/models/help.dart";
import "package:pathfinder/models/history.dart";
import "package:pathfinder/models/point.dart";
import "package:pathfinder/models/robot.dart";
import "package:pathfinder/store/app/app_state.dart";
import "package:pathfinder/store/tab/store.dart";
import "package:pathfinder/widgets/editor_screen.dart";
import "package:pathfinder/constants.dart";
import "package:path/path.dart" as path;
import "package:pathfinder/widgets/save_changes_dialog.dart";
import "package:pathfinder/views/home/home_view_model.dart";
import "package:pathfinder/views/home/settings_details.dart";

class HomePage extends StatefulWidget {
  HomePage();
  final HomeViewModel props = HomeViewModel.fromStore(store);

  @override
  _HomePageState createState() => _HomePageState(props);
}

GlobalKey<State<StatefulWidget>> _scaffoldKey = GlobalKey();
// A very ugly workaround to rerender sidebar when needed
// We don't have outer control of the form so we need to rerender to
// set the initial value
void triggerSidebarRender() {
  _scaffoldKey = GlobalKey();
}

class _HomePageState extends State<HomePage> {
  _HomePageState(this.props);
  HomeViewModel props;

  void onPointEdit(final int index, final Point point) {
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

  void onRobotEdit(final Robot robot) {
    setState(() {
      props.tabState = editRobot(props.tabState, EditRobot(robot: robot));
    });

    props.setRobot(robot);
  }

  @override
  Widget build(final BuildContext context) {
    // Handle store events to update the form if another widget changed state
    store.onChange.listen((final AppState event) {
      final HomeViewModel newProps = HomeViewModel.fromStore(store);
      if (newProps != props) {
        setState(() {
          props = newProps;
        });

        triggerSidebarRender();
      }
    });

    final ThemeData theme = Theme.of(context);

    return Scaffold(
      key: _scaffoldKey,
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
                        color: theme.textTheme.bodyLarge?.color,
                        onPressed: () {
                          props.setSidebarVisibility(true);
                        },
                        tooltip: "Show sidebar",
                        icon: const Icon(Icons.menu),
                      ),
                      IconButton(
                        color: theme.textTheme.bodyLarge?.color,
                        onPressed: () {
                          if (!props.changesSaved) {
                            showAlertDialog(
                              context,
                              props.newAuto,
                              props.saveFile,
                              () {},
                            );
                            return;
                          }

                          props.newAuto();
                        },
                        tooltip: "New auto",
                        icon: const Icon(Icons.new_label),
                      ),
                      IconButton(
                        color: theme.textTheme.bodyLarge?.color,
                        onPressed: () {
                          props.pathUndo();
                        },
                        tooltip: "Undo",
                        icon: const Icon(Icons.chevron_left_outlined),
                      ),
                      IconButton(
                        color: theme.textTheme.bodyLarge?.color,
                        onPressed: () {
                          props.pathRedo();
                        },
                        tooltip: "Redo",
                        icon: const Icon(Icons.chevron_right_outlined),
                      ),
                      IconButton(
                        color: theme.textTheme.bodyLarge?.color,
                        onPressed: () {
                          props.selectRobot();
                        },
                        tooltip: "Edit robot",
                        icon: const Icon(Icons.adb),
                      ),
                      IconButton(
                        color: theme.textTheme.bodyLarge?.color,
                        onPressed: () {
                          props.selectHistory();
                        },
                        tooltip: "History",
                        icon: const Icon(Icons.history),
                      ),
                      IconButton(
                        color: theme.textTheme.bodyLarge?.color,
                        onPressed: () {
                          props.selectHelp();
                        },
                        tooltip: "Help",
                        icon: const Icon(Icons.question_mark_sharp),
                      ),
                      const SizedBox(width: 10),
                      Text(
                        path.dirname(props.autoFileName) +
                            Platform.pathSeparator,
                        style: TextStyle(
                          fontSize: 10,
                          fontStyle: FontStyle.italic,
                          color: theme.textTheme.bodyLarge!.color!
                              .withOpacity(0.7),
                        ),
                      ),
                      const SizedBox(width: 1),
                      Text(path.basename(props.autoFileName)),
                      if (!props.changesSaved)
                        const Text(
                          " •",
                          style: TextStyle(
                            fontSize: 30,
                            height: 1.1,
                          ),
                        ),
                      const SizedBox(width: 10),
                      ...List<Widget>.generate(
                        props.tabAmount,
                        (final int index) => ElevatedButton(
                          style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all(
                              const Color(0),
                            ),
                            shadowColor: MaterialStateProperty.all(
                              const Color(0),
                            ),
                            surfaceTintColor: MaterialStateProperty.all(
                              const Color(0),
                            ),
                          ),
                          onLongPress: () {
                            if (!props.changesSaved) {
                              showAlertDialog(
                                context,
                                () => props.removeTab(props.currentTabIndex),
                                props.saveFile,
                                () {},
                              );
                            } else if (props.tabAmount > 1) {
                              props.removeTab(props.currentTabIndex);
                            }
                          },
                          onPressed: () {
                            props.changeTab(index);
                          },
                          child: Text(
                            "$index",
                            style: TextStyle(
                              color: index == props.currentTabIndex
                                  ? Colors.lightGreen
                                  : null,
                            ),
                          ),
                        ),
                      ),
                      IconButton(
                        onPressed: props.addTab,
                        icon: const Icon(Icons.add),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: EditorScreen(
                    calculateTrajectory: props.calculateTrajectory,
                    trajectoryFileName: props.trajectoryFileName,
                    editTrajectoryFileName: props.editTrajectoryFileName,
                    openFile: props.openFile,
                    saveFile: props.saveFile,
                    saveFileAs: props.saveFileAs,
                    changesSaved: props.changesSaved,
                  ),
                ),
              ],
            ),
            if (props.isSidebarOpen)
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
                      color: theme.primaryColor.withOpacity(0.5),
                      child: Stack(
                        children: <Widget>[
                          ListView(
                            padding: EdgeInsets.zero,
                            children: <Widget>[
                              ListTile(
                                // textColor: theme.textTheme.headline1?.color,
                                title: Text(getSideBarHeadline(props.tabState)),
                              ),
                              Divider(
                                indent: 15,
                                endIndent: 15,
                                color: theme.textTheme.displayLarge?.color,
                                thickness: 0.5,
                              ),
                              SettingsDetails(
                                tabState: props.tabState,
                                onPointEdit: onPointEdit,
                                onRobotEdit: onRobotEdit,
                              ),
                            ],
                          ),
                          Positioned(
                            right: 5,
                            top: 5,
                            child: IconButton(
                              color: theme.textTheme.displayLarge?.color,
                              onPressed: () {
                                props.setSidebarVisibility(false);
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
    );
  }
}

String getSideBarHeadline(final TabState tabState) {
  final int selectedIndex = tabState.ui.selectedIndex;
  final Type selectedType = tabState.ui.selectedType;

  if (selectedType == Robot) return "ROBOT DATA";
  if (selectedType == Point && selectedIndex > -1)
    return "POINT $selectedIndex";
  if (selectedType == History) return "HISTORY";
  if (selectedType == Help) return "HELP";
  return "NO SELECTION";
}
