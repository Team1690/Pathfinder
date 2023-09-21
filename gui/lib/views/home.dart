import "dart:ui";

import "package:flutter/material.dart";
import "dart:core";
import "dart:io";
import "package:pathfinder/main.dart";
import "package:pathfinder/models/history.dart";
import "package:pathfinder/models/point.dart";
import "package:pathfinder/models/robot.dart";
import "package:pathfinder/store/app/app_state.dart";
import "package:pathfinder/store/tab/store.dart";
import "package:pathfinder/store/tab/tab_thunk.dart";
import "package:pathfinder/store/tab/tab_ui/tab_ui.dart";
import "package:pathfinder/utils/math.dart";
import "package:pathfinder/widgets/editor_screen.dart";
import "package:pathfinder/constants.dart";
import "package:path/path.dart" as path;
import "package:pathfinder/widgets/save_changes_dialog.dart";
import "package:redux/redux.dart";
import "package:card_settings/card_settings.dart";

class HomeViewModel {
  HomeViewModel({
    required this.isSidebarOpen,
    required this.setSidebarVisibility,
    required this.selectRobot,
    required this.selectHistory,
    required this.history,
    required this.tabState,
    required this.setPointData,
    required this.setRobot,
    required this.calculateTrajectory,
    required this.trajectoryFileName,
    required this.autoFileName,
    required this.editTrajectoryFileName,
    required this.openFile,
    required this.saveFile,
    required this.pathUndo,
    required this.pathRedo,
    required this.saveFileAs,
    required this.newAuto,
    required this.changesSaved,
  });
  TabState tabState;
  bool isSidebarOpen;
  final Function(bool) setSidebarVisibility;
  final Function selectRobot;
  final Function selectHistory;
  final History history;
  final Function(int, Point) setPointData;
  final Function(Robot) setRobot;
  final Function() calculateTrajectory;
  final String trajectoryFileName;
  final String autoFileName;
  final Function(String) editTrajectoryFileName;
  final Function() openFile;
  final Function() saveFile;
  final Function() saveFileAs;
  final Function() pathUndo;
  final Function() pathRedo;
  final Function() newAuto;
  final bool changesSaved;

  static HomeViewModel fromStore(final Store<AppState> store) => HomeViewModel(
        tabState: store.state.tabState,
        isSidebarOpen: store.state.tabState.ui.isSidebarOpen,
        setSidebarVisibility: (final bool visibility) {
          store.dispatch(SetSideBarVisibility(visibility));
        },
        selectRobot: () {
          store.dispatch(ObjectSelected(0, Robot));
        },
        selectHistory: () {
          store.dispatch(ObjectSelected(0, History));
        },
        history: store.state.tabState.history,
        setPointData: (final int index, final Point point) {
          store.dispatch(
            editPointThunk(
              pointIndex: index,
              position: point.position,
              inControlPoint: point.inControlPoint,
              outControlPoint: point.outControlPoint,
              useHeading: point.useHeading,
              heading: point.heading,
              action: point.action,
              actionTime: point.actionTime,
              cutSegment: point.cutSegment,
              isStop: point.isStop,
            ),
          );
        },
        setRobot: (final Robot robot) {
          store.dispatch(EditRobot(robot: robot));
        },
        calculateTrajectory: () => store.dispatch(
          calculateTrajectoryThunk(),
        ),
        trajectoryFileName: store.state.tabState.ui.trajectoryFileName,
        autoFileName: store.state.tabState.ui.autoFileName,
        editTrajectoryFileName: (final String fileName) {
          store.dispatch(TrajectoryFileNameChanged(fileName));
        },
        openFile: () => store.dispatch(openFileThunk()),
        pathUndo: () => store.dispatch(pathUndoThunk()),
        pathRedo: () => store.dispatch(pathRedoThunk()),
        saveFile: () => store.dispatch(saveFileThunk(false)),
        saveFileAs: () => store.dispatch(saveFileThunk(true)),
        newAuto: () => store.dispatch(newAutoThunk()),
        changesSaved: store.state.tabState.ui.changesSaved,
      );

  @override
  int get hashCode => super.hashCode;

  @override
  bool operator ==(final Object other) {
    if (other is! HomeViewModel) return false;

    if (other.isSidebarOpen != isSidebarOpen) return false;

    final TabUI ui = tabState.ui;
    final TabUI otherUi = other.tabState.ui;

    if (ui.selectedIndex != otherUi.selectedIndex) return false;
    if (ui.selectedType != otherUi.selectedType) return false;

    // When the history is open, always update
    if (ui.selectedType == History) return false;

    if (ui.selectedIndex != -1) {
      if (ui.selectedType == Point &&
          (tabState.path.points[ui.selectedIndex] !=
              other.tabState.path.points[otherUi.selectedIndex])) return false;
      if (ui.selectedType == Robot && (tabState.robot != other.tabState.robot))
        return false;
    }

    if (ui.autoFileName != otherUi.autoFileName) return false;

    if (ui.changesSaved != otherUi.changesSaved) return false;

    return true;
  }
}

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

class SettingsDetails extends StatelessWidget {
  SettingsDetails({
    required this.tabState,
    required this.onPointEdit,
    required this.onRobotEdit,
  });
  final TabState tabState;
  final Function(int index, Point point) onPointEdit;
  final Function(Robot robot) onRobotEdit;
  final TextEditingController inAngleController = TextEditingController();
  final TextEditingController outAngleController = TextEditingController();

  CardSettingsText _cardSettingsDouble({
    required final String label,
    required final double initialValue,
    required final Function(double) onChanged,
    final bool allowNegative = true,
    final int fractionDigits = 3,
    final String unitLabel = "m",
    final TextEditingController? controller,
  }) {
    final String text =
        double.parse(initialValue.toStringAsFixed(fractionDigits)).toString();
    return CardSettingsText(
      controller: controller
        ?..text = text
        ..selection = TextSelection(
          baseOffset: text.length - 1,
          extentOffset: text.length - 1,
        ),
      label: label,
      // Remove trailing zeros and set to the wanted fraction digits
      initialValue:
          double.parse(initialValue.toStringAsFixed(fractionDigits)).toString(),
      hintText: label,
      unitLabel: unitLabel,
      validator: (final String? value) {
        if (value == null) return "$label is required.";
        if (double.tryParse(value) == null) return "Not a number";
        if (!allowNegative && double.parse(value) < 0) return "No negatives";
        return null;
      },
      onChanged: (final String val) =>
          onChanged(double.tryParse(val) ?? initialValue),
    );
  }

  @override
  Widget build(final BuildContext context) {
    final int index = tabState.ui.selectedIndex;
    final List<Point> points = tabState.path.points;
    final Robot robot = tabState.robot;

    // On init the selected index may be negative
    if (index < 0) return const SizedBox.shrink();

    if (tabState.ui.selectedType == Robot) {
      return Form(
        child: CardSettings(
          contentAlign: TextAlign.right,
          labelAlign: TextAlign.left,
          shrinkWrap: true,
          children: <CardSettingsSection>[
            CardSettingsSection(
              children: <CardSettingsWidget>[
                _cardSettingsDouble(
                  label: "Width",
                  unitLabel: "m",
                  allowNegative: false,
                  initialValue: robot.width,
                  onChanged: (final double value) {
                    onRobotEdit(
                      robot.copyWith(
                        width: value,
                      ),
                    );
                  },
                ),
                _cardSettingsDouble(
                  label: "Height",
                  unitLabel: "m",
                  allowNegative: false,
                  initialValue: robot.height,
                  onChanged: (final double value) {
                    onRobotEdit(
                      robot.copyWith(
                        height: value,
                      ),
                    );
                  },
                ),
                _cardSettingsDouble(
                  label: "Max Velocity",
                  unitLabel: "m/s",
                  allowNegative: false,
                  initialValue: robot.maxVelocity,
                  onChanged: (final double value) {
                    onRobotEdit(
                      robot.copyWith(
                        maxVelocity: value,
                      ),
                    );
                  },
                ),
                _cardSettingsDouble(
                  label: "Max Accel",
                  unitLabel: "m/s²",
                  allowNegative: false,
                  initialValue: robot.maxAcceleration,
                  onChanged: (final double value) {
                    onRobotEdit(
                      robot.copyWith(
                        maxAcceleration: value,
                      ),
                    );
                  },
                ),
                _cardSettingsDouble(
                  label: "Max Jerk",
                  unitLabel: "m/s³",
                  allowNegative: false,
                  initialValue: robot.maxJerk,
                  onChanged: (final double value) {
                    onRobotEdit(
                      robot.copyWith(
                        maxJerk: value,
                      ),
                    );
                  },
                ),
                _cardSettingsDouble(
                  label: "Skid Accel",
                  unitLabel: "m/s²",
                  initialValue: robot.skidAcceleration,
                  onChanged: (final double value) {
                    onRobotEdit(
                      robot.copyWith(
                        skidAcceleration: value,
                      ),
                    );
                  },
                ),
                _cardSettingsDouble(
                  label: "Cycle Time",
                  unitLabel: "s",
                  allowNegative: false,
                  initialValue: robot.cycleTime,
                  onChanged: (final double value) {
                    onRobotEdit(
                      robot.copyWith(
                        cycleTime: value,
                      ),
                    );
                  },
                ),
                _cardSettingsDouble(
                  label: "Angular Accel Perc",
                  unitLabel: "%",
                  allowNegative: false,
                  initialValue: 100 * robot.angularAccelerationPercentage,
                  onChanged: (final double value) {
                    onRobotEdit(
                      robot.copyWith(
                        angularAccelerationPercentage: value / 100,
                      ),
                    );
                  },
                ),
              ],
            ),
          ],
        ),
      );
    }

    if (tabState.ui.selectedType == History) {
      return Container(
        child: Card(
          margin: const EdgeInsets.all(8),
          child: Column(
            children: <Widget>[
              ListView(
                scrollDirection: Axis.vertical,
                shrinkWrap: true,
                children: tabState.history.pathHistory
                    .asMap()
                    .entries
                    .map(
                      (final MapEntry<int, HistoryStamp> e) => ListTile(
                        dense: true,
                        enabled: e.key <= tabState.history.currentStateIndex,
                        leading: Icon(
                          actionToIcon[e.value.action] ??
                              Icons.device_unknown_outlined,
                        ),

                        // Seperate the name by capital letter (EditPoint -> Edit Point)
                        title: Text(
                          (e.value.action
                              .split(RegExp(r"(?=[A-Z])"))
                              .join(" ")),
                        ),
                      ),
                    )
                    .toList()
                    .reversed
                    .toList(),
              ),
            ],
          ),
        ),
      );
    }

    if (tabState.ui.selectedType == Point) {
      if (points.isEmpty) return const SizedBox.shrink();

      final Point pointData = points[index];
      final bool isFirstOrLast = index == 0 || index == points.length - 1;

      return Form(
        child: CardSettings.sectioned(
          contentAlign: TextAlign.right,
          labelAlign: TextAlign.left,
          shrinkWrap: true,
          children: <CardSettingsSection>[
            CardSettingsSection(
              children: <CardSettingsWidget>[
                _cardSettingsDouble(
                  label: "Position X",
                  initialValue: pointData.position.dx,
                  onChanged: (final double value) {
                    onPointEdit(
                      index,
                      pointData.copyWith(
                        position: Offset(value, pointData.position.dy),
                      ),
                    );
                  },
                ),
                _cardSettingsDouble(
                  label: "Position Y",
                  initialValue: pointData.position.dy,
                  onChanged: (final double value) {
                    onPointEdit(
                      index,
                      pointData.copyWith(
                        position: Offset(pointData.position.dx, value),
                      ),
                    );
                  },
                ),
                _cardSettingsDouble(
                  label: "In Mag",
                  initialValue: pointData.inControlPoint.distance,
                  allowNegative: false,
                  onChanged: (final double value) {
                    onPointEdit(
                      index,
                      pointData.copyWith(
                        inControlPoint: Offset.fromDirection(
                          pointData.inControlPoint.direction,
                          value,
                        ),
                      ),
                    );
                  },
                ),
                _cardSettingsDouble(
                  controller: inAngleController,
                  label: "In Angle",
                  initialValue: degrees(pointData.inControlPoint.direction),
                  unitLabel: "°",
                  fractionDigits: 1,
                  onChanged: (final double value) {
                    final double opposite = radians(value + 180);
                    onPointEdit(
                      index,
                      pointData.copyWith(
                        inControlPoint: Offset.fromDirection(
                          radians(value),
                          pointData.inControlPoint.distance,
                        ),
                        outControlPoint: pointData.isStop
                            ? pointData.outControlPoint
                            : Offset.fromDirection(
                                opposite,
                                pointData.outControlPoint.distance,
                              ),
                      ),
                    );
                    outAngleController.text = opposite.toString();
                  },
                ),
                _cardSettingsDouble(
                  label: "Out Mag",
                  allowNegative: false,
                  initialValue: pointData.outControlPoint.distance,
                  onChanged: (final double value) {
                    onPointEdit(
                      index,
                      pointData.copyWith(
                        outControlPoint: Offset.fromDirection(
                          pointData.outControlPoint.direction,
                          value,
                        ),
                      ),
                    );
                  },
                ),
                _cardSettingsDouble(
                  controller: outAngleController,
                  label: "Out Angle",
                  initialValue: degrees(pointData.outControlPoint.direction),
                  fractionDigits: 1,
                  unitLabel: "°",
                  onChanged: (final double value) {
                    final double opposite = radians(value + 180);

                    onPointEdit(
                      index,
                      pointData.copyWith(
                        outControlPoint: Offset.fromDirection(
                          radians(value),
                          pointData.outControlPoint.distance,
                        ),
                        inControlPoint: pointData.isStop
                            ? pointData.inControlPoint
                            : Offset.fromDirection(
                                opposite,
                                pointData.inControlPoint.direction,
                              ),
                      ),
                    );
                    inAngleController.text = opposite.toString();
                  },
                ),
                CardSettingsSwitch(
                  enabled: index != 0,
                  initialValue: pointData.useHeading,
                  label: "Use Heading",
                  onChanged: (final bool value) {
                    onPointEdit(index, pointData.copyWith(useHeading: value));
                    triggerSidebarRender();
                  },
                ),
                if (pointData.useHeading)
                  _cardSettingsDouble(
                    label: "Heading",
                    initialValue: degrees(pointData.heading),
                    fractionDigits: 1,
                    unitLabel: "°",
                    onChanged: (final double value) {
                      onPointEdit(
                        index,
                        pointData.copyWith(heading: radians(value)),
                      );
                    },
                  ),
                if (!isFirstOrLast)
                  CardSettingsSwitch(
                    enabled: !pointData.isStop,
                    initialValue: pointData.cutSegment,
                    label: "Cut segments",
                    onChanged: (final bool value) {
                      onPointEdit(index, pointData.copyWith(cutSegment: value));
                      triggerSidebarRender();
                    },
                  ),
                if (!isFirstOrLast)
                  CardSettingsSwitch(
                    initialValue: pointData.isStop,
                    label: "Stop point",
                    onChanged: (final bool value) {
                      onPointEdit(index, pointData.copyWith(isStop: value));
                      triggerSidebarRender();
                    },
                  ),
              ],
            ),
            CardSettingsSection(
              children: <CardSettingsWidget>[
                CardSettingsListPicker<String>(
                  label: "Action",
                  initialItem:
                      pointData.action == "" ? "None" : pointData.action,
                  items: const <String>[
                    "None",
                    ...autoActions,
                  ],
                  onChanged: (String? value) {
                    if (value == "None") value = "";
                    onPointEdit(index, pointData.copyWith(action: value));
                  },
                ),
                if (pointData.action != "")
                  _cardSettingsDouble(
                    label: "Action Time",
                    initialValue: pointData.actionTime,
                    unitLabel: "s",
                    onChanged: (final double value) {
                      onPointEdit(index, pointData.copyWith(actionTime: value));
                    },
                  ),
              ],
            ),
          ],
          // );
          // },
        ),
      );
    }
    return const SizedBox.shrink();
  }
}

String getSideBarHeadline(final TabState tabState) {
  final int selectedIndex = tabState.ui.selectedIndex;
  final Type selectedType = tabState.ui.selectedType;

  if (selectedType == Robot) return "ROBOT DATA";
  if (selectedType == Point && selectedIndex > -1)
    return "POINT $selectedIndex";
  if (selectedType == History) return "HISTORY";

  return "NO SELECTION";
}
