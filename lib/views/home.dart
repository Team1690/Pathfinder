import 'dart:collection';
import 'dart:ui';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:pathfinder/main.dart';
import 'package:pathfinder/models/point.dart';
import 'package:pathfinder/store/app/app_state.dart';
import 'package:pathfinder/store/tab/store.dart';
import 'package:pathfinder/store/tab/tab_thunk.dart';
import 'package:pathfinder/widgets/card.dart';
import 'package:pathfinder/widgets/editor_screen.dart';
import 'package:pathfinder/constants.dart';
import 'package:pathfinder/widgets/tab.dart';
import 'package:redux/redux.dart';
import 'package:card_settings/card_settings.dart';

class HomeViewModel {
  final bool isSidebarOpen;
  final Function(bool) setSidebarVisibility;

  HomeViewModel({
    required this.isSidebarOpen,
    required this.setSidebarVisibility,
  });

  static HomeViewModel fromStore(Store<AppState> store) {
    return HomeViewModel(
      isSidebarOpen: store.state.tabState.ui.isSidebarOpen,
      setSidebarVisibility: (visibility) {
        store.dispatch(SetSideBarVisibility(visibility));
      },
    );
  }

  @override
  // TODO: implement hashCode
  int get hashCode => super.hashCode;

  @override
  bool operator ==(Object other) {
    if (other is HomeViewModel) {
      final equal = other.isSidebarOpen == isSidebarOpen;
      return equal;
    }

    return false;
  }
}

StoreConnector<AppState, HomeViewModel> homePage() {
  return new StoreConnector<AppState, HomeViewModel>(
    converter: (store) => HomeViewModel.fromStore(store),
    builder: (_, props) => _HomePage(props: props),
    distinct: true,
  );
}

class _HomePage extends StatelessWidget {
  final HomeViewModel props;

  _HomePage({
    required this.props,
  });

  @override
  Widget build(final BuildContext context) {
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
              // PathEditor(),
              // Expanded(
              //   child: Padding(
              //     padding: const EdgeInsets.all(defaultPadding),
              //     child: Row(
              //       children: [
              //         optimizeAndGenerateCard(),
              //         const SizedBox(width: defaultPadding),
              //         pointPropertiesCard(),
              //         const SizedBox(width: defaultPadding),
              //         Expanded(
              //           flex: 2,
              //           child: PropertiesCard(
              //             body: Container(),
              //           ),
              //         ),
              //         const SizedBox(width: defaultPadding),
              //         fileManagementCard(),
              //       ],
              //     ),
              //   ),
              // ),
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
                    width: 300.0,
                    height: MediaQuery.of(context).size.height,
                    color: theme.primaryColor.withOpacity(0.5),
                    child: Stack(
                      children: [
                        ListView(
                          padding: EdgeInsets.zero,
                          children: [
                            ListTile(
                              textColor: theme.textTheme.headline1?.color,
                              title: Text("DATA"),
                            ),
                            Divider(
                              indent: 15,
                              endIndent: 15,
                              color: theme.textTheme.headline1?.color,
                              thickness: 0.5,
                            ),
                            _SettingsDetails(),
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

class SettingsViewModel {
  TabState tabState;
  final Null Function(int, double, double) setPointData;

  SettingsViewModel({
    required this.tabState,
    required this.setPointData,
  });

  static SettingsViewModel fromStore(Store<AppState> store) {
    return SettingsViewModel(
      tabState: store.state.tabState,
      setPointData: (int index, double x, double y) {
        store.dispatch(editPointThunk(index, Offset(x, y)));
      },
    );
  }

  @override
  int get hashCode => 111;

  @override
  bool operator ==(Object other) {
    if (other is SettingsViewModel) {
      final ui = tabState.ui;
      final otherUi = other.tabState.ui;

      if (ui.selectedIndex == otherUi.selectedIndex &&
          ui.selectedType == otherUi.selectedType) {
        final point = tabState.path.points[ui.selectedIndex];
        final otherPoint = other.tabState.path.points[otherUi.selectedIndex];

        final equal = point == otherPoint;
        return equal;
      }
    }

    return false;
  }
}

// StoreConnector<AppState, SettingsViewModel> settingsDetails() {
//   return new StoreConnector<AppState, SettingsViewModel>(
//     converter: (store) => SettingsViewModel.fromStore(store),
//     builder: (_, props) {
//       return _SettingsDetails(props);
//     },
//     distinct: true,
//   );
// }

class _SettingsDetails extends StatefulWidget {
  // final SettingsViewModel props;

  _SettingsDetails();

  @override
  _SettingsDetailsState createState() => _SettingsDetailsState();
}

class _SettingsDetailsState extends State<_SettingsDetails> {
  SettingsViewModel props = SettingsViewModel.fromStore(store);

  // _SettingsDetailsState(this.props);

  @override
  Widget build(BuildContext context) {
    final newProps = SettingsViewModel.fromStore(store);
    // if (props != newProps) {
    setState(() {
      this.props = newProps;
    });
    // }

    final index = props.tabState.ui.selectedIndex;
    final points = props.tabState.path.points;

    // On init the selected index may be negative
    if (index < 0) return SizedBox.shrink();

    if (props.tabState.ui.selectedType == Point) {
      if (points.length == 0) return SizedBox.shrink();

      setPoint(int index, double x, y) {
        props.setPointData(index, x, y);
      }

      final pointData = points[index];

      return Form(
        // child: StoreConnector<AppState, SettingsViewModel>(
        //   converter: (store) => SettingsViewModel.fromStore(store),
        //   distinct: false,
        //   onWillChange: (_, newViewModel) =>
        //       setState(() => props = newViewModel),
        //   builder: (_, newProps) {
        child: CardSettings(
          // return CardSettings(
          cardless: true,
          children: <CardSettingsSection>[
            CardSettingsSection(
              children: <CardSettingsWidget>[
                CardSettingsDouble(
                    label: 'Position X',
                    initialValue: pointData.position.dx,
                    validator: (value) {
                      if (value == null) return 'Position X is required.';
                    },
                    onChanged: (xValue) {
                      setPoint(
                        index,
                        xValue ?? 0,
                        pointData.position.dy,
                      );
                    }),
                CardSettingsDouble(
                  label: 'Position Y',
                  initialValue: pointData.position.dy,
                  validator: (value) {
                    if (value == null) return 'Position Y is required.';
                  },
                  onChanged: (yValue) {
                    setPoint(
                      index,
                      pointData.position.dx,
                      yValue ?? 0,
                    );
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

  Widget pointPropertiesCard() {
    return Expanded(
      flex: 2,
      child: PropertiesCard(
        body: Padding(
          padding: const EdgeInsets.all(defaultPadding),
          child: Column(
            children: [
              Expanded(
                child: Row(
                  children: [
                    // Text("Position: "),
                    // TextField(),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget optimizeAndGenerateCard() {
    return Expanded(
      flex: 2,
      child: PropertiesCard(
        body: Padding(
          padding: const EdgeInsets.symmetric(
              horizontal: defaultPadding, vertical: 2 * defaultPadding),
          child: Row(
            children: [
              Expanded(
                child: ElevatedButton(
                  onPressed: () {},
                  child: Center(child: Text("Generate")),
                ),
              ),
              const SizedBox(width: defaultPadding),
              Expanded(
                child: ElevatedButton(
                  onPressed: () {},
                  child: Center(child: Text("Optimize")),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget fileManagementCard() {
    return Expanded(
      flex: 2,
      child: PropertiesCard(
        body: Padding(
          padding: const EdgeInsets.symmetric(
              horizontal: defaultPadding, vertical: 2 * defaultPadding),
          child: Row(
            children: [
              Expanded(
                child: ElevatedButton(
                  onPressed: () {},
                  child: Center(child: Text("Import")),
                ),
              ),
              const SizedBox(width: defaultPadding),
              Expanded(
                child: ElevatedButton(
                  onPressed: () {},
                  child: Center(child: Text("Export")),
                ),
              ),
              const SizedBox(width: defaultPadding),
              Expanded(
                child: ElevatedButton(
                  onPressed: () {},
                  child: Center(child: Text("Upload")),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
