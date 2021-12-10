import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:pathfinder/main.dart';
import 'package:pathfinder/models/point.dart';
import 'package:pathfinder/store/app/app_state.dart';
import 'package:pathfinder/store/tab/store.dart';
import 'package:pathfinder/store/tab/tab_thunk.dart';
import 'package:pathfinder/widgets/editor_screen.dart';
import 'package:pathfinder/constants.dart';
import 'package:pathfinder/widgets/tab.dart';
import 'package:redux/redux.dart';
import 'package:card_settings/card_settings.dart';

class HomeViewModel {
  TabState tabState;
  bool isSidebarOpen;
  final Function(bool) setSidebarVisibility;
  final Function(int, Point) setPointData;

  HomeViewModel({
    required this.isSidebarOpen,
    required this.setSidebarVisibility,
    required this.tabState,
    required this.setPointData,
  });

  static HomeViewModel fromStore(Store<AppState> store) {
    return HomeViewModel(
      tabState: store.state.tabState,
      isSidebarOpen: store.state.tabState.ui.isSidebarOpen,
      setSidebarVisibility: (visibility) {
        store.dispatch(SetSideBarVisibility(visibility));
      },
      setPointData: (int index, Point point) {
        store.dispatch(editPointThunk(
          pointIndex: index,
          position: point.position,
          inControlPoint: point.inControlPoint,
          outControlPoint: point.outControlPoint,
          heading: point.heading,
        ));
      },
    );
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
          tabState.path.points[ui.selectedIndex] !=
              other.tabState.path.points[otherUi.selectedIndex]) return false;
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

class _HomePageState extends State<HomePage> {
  HomeViewModel props;

  _HomePageState(this.props);

  onPointEdit(int index, Point point) {
    props.tabState = editPoint(
        props.tabState,
        EditPoint(
          pointIndex: index,
          position: point.position,
          inControlPoint: point.inControlPoint,
          outControlPoint: point.outControlPoint,
          heading: point.heading,
        ));

    props.setPointData(index, point);
  }

  @override
  Widget build(final BuildContext context) {
    store.onChange.listen((event) {
      final newProps = HomeViewModel.fromStore(store);
      if (newProps != props) {
        setState(() {
          props = newProps;
        });
      }
    });

    final theme = Theme.of(context);
    final _scaffoldKey = GlobalKey();

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
              left: 0,
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
                              title: Text("DATA"),
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

  SettingsDetails({
    required this.tabState,
    required this.onPointEdit,
  });

  _cardSettingsDouble({label, initialValue, onChanged, unitLabel = 'cm'}) {
    return CardSettingsDouble(
      label: label,
      initialValue: initialValue,
      decimalDigits: 3,
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

    // On init the selected index may be negative
    if (index < 0) return SizedBox.shrink();

    if (tabState.ui.selectedType == Point) {
      if (points.length == 0) return SizedBox.shrink();

      final pointData = points[index];

      return Form(
        child: CardSettings(
          // return CardSettings(
          // cardless: true,
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
                  label: 'Position X',
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
                  label: 'Control In X',
                  initialValue: pointData.inControlPoint.dx,
                  onChanged: (value) {
                    onPointEdit(
                        index,
                        pointData.copyWith(
                          inControlPoint:
                              Offset(value ?? 0, pointData.inControlPoint.dy),
                        ));
                  },
                ),
                _cardSettingsDouble(
                  label: 'Control In Y',
                  initialValue: pointData.inControlPoint.dy,
                  onChanged: (value) {
                    onPointEdit(
                        index,
                        pointData.copyWith(
                          inControlPoint:
                              Offset(pointData.inControlPoint.dx, value ?? 0),
                        ));
                  },
                ),
                _cardSettingsDouble(
                  label: 'Control Out X',
                  initialValue: pointData.outControlPoint.dx,
                  onChanged: (value) {
                    onPointEdit(
                        index,
                        pointData.copyWith(
                          inControlPoint:
                              Offset(value ?? 0, pointData.outControlPoint.dy),
                        ));
                  },
                ),
                _cardSettingsDouble(
                  label: 'Control Out Y',
                  initialValue: pointData.outControlPoint.dy,
                  onChanged: (value) {
                    onPointEdit(
                        index,
                        pointData.copyWith(
                          inControlPoint:
                              Offset(pointData.outControlPoint.dx, value ?? 0),
                        ));
                  },
                ),
                _cardSettingsDouble(
                  label: 'Heading',
                  initialValue: pointData.heading,
                  unitLabel: '°',
                  onChanged: (value) {
                    onPointEdit(index, pointData.copyWith(heading: value ?? 0));
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
