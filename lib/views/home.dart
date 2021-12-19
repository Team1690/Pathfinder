import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:pathfinder/main.dart';
import 'package:pathfinder/models/point.dart';
import 'package:pathfinder/models/robot.dart';
import 'package:pathfinder/store/app/app_state.dart';
import 'package:pathfinder/store/tab/store.dart';
import 'package:pathfinder/store/tab/tab_thunk.dart';
import 'package:pathfinder/utils/math.dart';
import 'package:pathfinder/widgets/editor_screen.dart';
import 'package:pathfinder/constants.dart';
import 'package:pathfinder/widgets/tab.dart';
import 'package:redux/redux.dart';
import 'package:card_settings/card_settings.dart';

class HomeViewModel {
  TabState tabState;
  bool isSidebarOpen;
  final Function(bool) setSidebarVisibility;
  final Function selectRobot;
  final Function(int, Point) setPointData;
  final Function(Robot) setRobot;

  HomeViewModel({
    required this.isSidebarOpen,
    required this.setSidebarVisibility,
    required this.selectRobot,
    required this.tabState,
    required this.setPointData,
    required this.setRobot,
  });

  static HomeViewModel fromStore(Store<AppState> store) {
    return HomeViewModel(
        tabState: store.state.tabState,
        isSidebarOpen: store.state.tabState.ui.isSidebarOpen,
        setSidebarVisibility: (visibility) {
          store.dispatch(SetSideBarVisibility(visibility));
        },
        selectRobot: () {
          store.dispatch(ObjectSelected(0, Robot));
        },
        setPointData: (int index, Point point) {
          store.dispatch(editPointThunk(
            pointIndex: index,
            position: point.position,
            inControlPoint: point.inControlPoint,
            outControlPoint: point.outControlPoint,
            heading: point.heading,
            cutSegment: point.cutSegment,
            isStop: point.isStop,
          ));
        },
        setRobot: (Robot robot) {
          store.dispatch(EditRobot(robot: robot));
        });
  }

  @override
  int get hashCode => super.hashCode;

  @override
  bool operator ==(Object other) {
    if (!(other is HomeViewModel)) return false;

    if (other.isSidebarOpen != isSidebarOpen) return false;

    final ui = tabState.ui;
    final otherUi = other.tabState.ui;

    if (ui.selectedIndex != otherUi.selectedIndex) return false;
    if (ui.selectedType != otherUi.selectedType) return false;

    if (ui.selectedIndex != -1) {
      if (ui.selectedType == Point &&
          (tabState.path.points[ui.selectedIndex] !=
              other.tabState.path.points[otherUi.selectedIndex])) return false;
      if (ui.selectedType == Robot && (tabState.robot != other.tabState.robot))
        return false;
    }

    return true;
  }
}

class HomePage extends StatefulWidget {
  final HomeViewModel props = HomeViewModel.fromStore(store);

  HomePage();

  @override
  _HomePageState createState() => _HomePageState(props);
}

var _scaffoldKey = GlobalKey();
// A very ugly workaround to rerender sidebar when needed
// We don't have outer control of the form so we need to rerender to
// set the initial value
triggerSidebarRender() {
  _scaffoldKey = GlobalKey();
}

class _HomePageState extends State<HomePage> {
  HomeViewModel props;

  _HomePageState(this.props);

  onPointEdit(int index, Point point) {
    setState(() {
      props.tabState = editPoint(
          props.tabState,
          EditPoint(
            pointIndex: index,
            position: point.position,
            inControlPoint: point.inControlPoint,
            outControlPoint: point.outControlPoint,
            heading: point.heading,
            cutSegment: point.cutSegment,
            isStop: point.isStop,
          ));
    });

    props.setPointData(index, point);
  }

  onRobotEdit(Robot robot) {
    setState(() {
      props.tabState = editRobot(props.tabState, EditRobot(robot: robot));
    });

    props.setRobot(robot);
  }

  @override
  Widget build(final BuildContext context) {
    // Handle store events to update the form if another widget changed state
    store.onChange.listen((event) {
      final newProps = HomeViewModel.fromStore(store);
      if (newProps != props) {
        setState(() {
          props = newProps;
        });

        triggerSidebarRender();
      }
    });

    final theme = Theme.of(context);

    return Scaffold(
      key: _scaffoldKey,
      body: SafeArea(
        child: Stack(fit: StackFit.expand, children: [
          Column(
            children: [
              Container(
                color: secondary,
                child: Row(
                  children: [
                    IconButton(
                      color: theme.textTheme.bodyText1?.color,
                      onPressed: () {
                        props.setSidebarVisibility(true);
                      },
                      icon: Icon(Icons.menu),
                    ),
                    IconButton(
                      color: theme.textTheme.bodyText1?.color,
                      onPressed: () {
                        props.selectRobot();
                      },
                      icon: Icon(Icons.adb),
                    ),
                    BroswerTab(
                      name: 'TEST',
                      activated: false,
                    ),
                  ],
                ),
              ),
              Expanded(child: EditorScreen()),
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
                      children: [
                        ListView(
                          padding: EdgeInsets.zero,
                          children: [
                            ListTile(
                              // textColor: theme.textTheme.headline1?.color,
                              title: Text(getSideBarHeadline(props.tabState)),
                            ),
                            Divider(
                              indent: 15,
                              endIndent: 15,
                              color: theme.textTheme.headline1?.color,
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
                            color: theme.textTheme.headline1?.color,
                            onPressed: () {
                              props.setSidebarVisibility(false);
                            },
                            icon: Icon(Icons.exit_to_app_rounded),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
        ]),
      ),
    );
  }
}

class SettingsDetails extends StatelessWidget {
  final TabState tabState;
  final Function(int index, Point point) onPointEdit;
  final Function(Robot robot) onRobotEdit;

  SettingsDetails({
    required this.tabState,
    required this.onPointEdit,
    required this.onRobotEdit,
  });

  _cardSettingsDouble({label, initialValue, onChanged, unitLabel = 'm'}) {
    return CardSettingsDouble(
      label: label,
      initialValue: initialValue,
      decimalDigits: 3,
      hintText: label,
      unitLabel: unitLabel,
      validator: (value) {
        if (value == null) return '$label is required.';
      },
      onChanged: onChanged,
    );
  }

  @override
  Widget build(BuildContext context) {
    final index = tabState.ui.selectedIndex;
    final points = tabState.path.points;
    final robot = tabState.robot;

    // On init the selected index may be negative
    if (index < 0) return SizedBox.shrink();

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
                  label: 'Width',
                  unitLabel: 'm',
                  initialValue: robot.width,
                  onChanged: (value) {
                    onRobotEdit(robot.copyWith(
                      width: value ?? 0,
                    ));
                  },
                ),
                _cardSettingsDouble(
                  label: 'Height',
                  unitLabel: 'm',
                  initialValue: robot.height,
                  onChanged: (value) {
                    onRobotEdit(robot.copyWith(
                      height: value ?? 0,
                    ));
                  },
                ),
                _cardSettingsDouble(
                  label: 'Max Velocity',
                  unitLabel: 'm/s',
                  initialValue: robot.maxVelocity,
                  onChanged: (value) {
                    onRobotEdit(robot.copyWith(
                      maxVelocity: value ?? 0,
                    ));
                  },
                ),
                _cardSettingsDouble(
                  label: 'Max Accel',
                  unitLabel: 'm/s²',
                  initialValue: robot.maxAcceleration,
                  onChanged: (value) {
                    onRobotEdit(robot.copyWith(
                      maxAcceleration: value ?? 0,
                    ));
                  },
                ),
                _cardSettingsDouble(
                  label: 'Max Jerk',
                  unitLabel: 'm/s³',
                  initialValue: robot.maxJerk,
                  onChanged: (value) {
                    onRobotEdit(robot.copyWith(
                      maxJerk: value ?? 0,
                    ));
                  },
                ),
                _cardSettingsDouble(
                  label: 'Skid Accel',
                  unitLabel: 'm/s²',
                  initialValue: robot.skidAcceleration,
                  onChanged: (value) {
                    onRobotEdit(robot.copyWith(
                      skidAcceleration: value ?? 0,
                    ));
                  },
                ),
                _cardSettingsDouble(
                  label: 'Cycle Time',
                  unitLabel: 's',
                  initialValue: robot.cycleTime,
                  onChanged: (value) {
                    onRobotEdit(robot.copyWith(
                      cycleTime: value ?? 0,
                    ));
                  },
                ),
                _cardSettingsDouble(
                  label: 'Max Angular Vel',
                  unitLabel: '°/s',
                  initialValue: robot.maxAngularVelocity,
                  onChanged: (value) {
                    onRobotEdit(robot.copyWith(
                      maxAngularVelocity: value ?? 0,
                    ));
                  },
                ),
                _cardSettingsDouble(
                  label: 'Max Angular Accel',
                  unitLabel: '°/s²',
                  initialValue: robot.maxAngularAcceleration,
                  onChanged: (value) {
                    onRobotEdit(robot.copyWith(
                      maxAngularAcceleration: value ?? 0,
                    ));
                  },
                ),
              ],
            ),
          ],
        ),
      );
    }

    if (tabState.ui.selectedType == Point) {
      if (points.length == 0) return SizedBox.shrink();

      final pointData = points[index];

      return Form(
        child: CardSettings(
          contentAlign: TextAlign.right,
          labelAlign: TextAlign.left,
          shrinkWrap: true,
          children: <CardSettingsSection>[
            CardSettingsSection(
              children: <CardSettingsWidget>[
                _cardSettingsDouble(
                  label: 'Position X',
                  initialValue: pointData.position.dx,
                  onChanged: (value) {
                    onPointEdit(
                        index,
                        pointData.copyWith(
                          position: Offset(value ?? 0, pointData.position.dy),
                        ));
                  },
                ),
                _cardSettingsDouble(
                  label: 'Position Y',
                  initialValue: pointData.position.dy,
                  onChanged: (value) {
                    onPointEdit(
                        index,
                        pointData.copyWith(
                          position: Offset(pointData.position.dx, value ?? 0),
                        ));
                  },
                ),
                _cardSettingsDouble(
                  label: 'In Mag',
                  initialValue: pointData.inControlPoint.distance,
                  onChanged: (value) {
                    onPointEdit(
                      index,
                      pointData.copyWith(
                        inControlPoint: Offset.fromDirection(
                            pointData.inControlPoint.direction, value),
                      ),
                    );
                  },
                ),
                _cardSettingsDouble(
                  label: 'In Angle',
                  initialValue: degrees(pointData.inControlPoint.direction),
                  unitLabel: "°",
                  onChanged: (value) {
                    onPointEdit(
                      index,
                      pointData.copyWith(
                        inControlPoint: Offset.fromDirection(
                            radians(value), pointData.inControlPoint.distance),
                      ),
                    );
                  },
                ),
                _cardSettingsDouble(
                  label: 'Out Mag',
                  initialValue: pointData.outControlPoint.distance,
                  onChanged: (value) {
                    onPointEdit(
                      index,
                      pointData.copyWith(
                        inControlPoint: Offset.fromDirection(
                            radians(pointData.outControlPoint.direction),
                            value),
                      ),
                    );
                  },
                ),
                _cardSettingsDouble(
                  label: 'Out Angle',
                  initialValue: degrees(pointData.outControlPoint.direction),
                  unitLabel: "°",
                  onChanged: (value) {
                    onPointEdit(
                      index,
                      pointData.copyWith(
                        outControlPoint: Offset.fromDirection(
                            radians(value), pointData.outControlPoint.distance),
                      ),
                    );
                  },
                ),
                _cardSettingsDouble(
                  label: 'Heading',
                  initialValue: degrees(pointData.heading),
                  unitLabel: '°',
                  onChanged: (value) {
                    onPointEdit(index,
                        pointData.copyWith(heading: radians(value ?? 0)));
                  },
                ),
                if (index != 0 && index != points.length - 1)
                  CardSettingsSwitch(
                    enabled: !pointData.isStop,
                    initialValue: pointData.cutSegment,
                    label: 'Cut segments',
                    onChanged: (value) {
                      onPointEdit(index, pointData.copyWith(cutSegment: value));
                      triggerSidebarRender();
                    },
                  ),
                if (index != 0 && index != points.length - 1)
                  CardSettingsSwitch(
                    initialValue: pointData.isStop,
                    label: 'Stop point',
                    onChanged: (value) {
                      onPointEdit(index, pointData.copyWith(isStop: value));
                      triggerSidebarRender();
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
    return SizedBox.shrink();
  }
}

String getSideBarHeadline(TabState tabState) {
  final selectedIndex = tabState.ui.selectedIndex;
  final selectedType = tabState.ui.selectedType;

  if (selectedType == Robot) return "ROBOT DATA";
  if (selectedType == Point && selectedIndex > -1)
    return 'POINT $selectedIndex';

  return "NO SELECTION";
}
