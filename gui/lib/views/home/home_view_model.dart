import "package:pathfinder/shortcuts/help.dart";
import "package:pathfinder/models/history.dart";
import "package:pathfinder/models/point.dart";
import "package:pathfinder/models/robot.dart";
import "package:pathfinder/shortcuts/shortcut_def.dart";
import "package:pathfinder/store/app/app_actions.dart";
import "package:pathfinder/store/app/app_state.dart";
import "package:pathfinder/store/tab/store.dart";
import "package:pathfinder/store/tab/tab_thunk.dart";
import "package:pathfinder/store/tab/tab_ui/tab_ui.dart";
import "package:redux/redux.dart";

//TODO: it isn't exactly reduxy to have the dispatchee functions be in the model
class HomeViewModel {
  HomeViewModel({
    required this.tabAmount,
    required this.addTab,
    required this.changeTab,
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
    required this.removeTab,
    required this.saveFileAs,
    required this.newAuto,
    required this.changesSaved,
    required this.help,
    required this.selectHelp,
    required this.currentTabIndex,
  });
  TabState tabState;
  bool isSidebarOpen;
  final Function(bool) setSidebarVisibility;
  final Function selectRobot;
  final Function selectHistory;
  final History history;
  final Help help;
  final Function() selectHelp;
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
  final void Function(int) changeTab;
  final void Function(int) removeTab;
  final void Function() addTab;
  final bool changesSaved;
  final int tabAmount;
  final int currentTabIndex;

  static HomeViewModel fromStore(final Store<AppState> store) => HomeViewModel(
        currentTabIndex: store.state.currentTabIndex,
        tabAmount: store.state.tabState.length,
        addTab: () => store.dispatch(const AddTab()),
        removeTab: (final int index) => store.dispatch(RemoveTab(index: index)),
        changeTab: (final int tab) =>
            store.dispatch(ChangeCurrentTab(index: tab)),
        tabState: store.state.tabState[store.state.currentTabIndex],
        isSidebarOpen:
            store.state.tabState[store.state.currentTabIndex].ui.isSidebarOpen,
        setSidebarVisibility: (final bool visibility) {
          store.dispatch(SetSideBarVisibility(visibility));
        },
        selectRobot: () {
          store.dispatch(ObjectSelected(0, Robot));
        },
        selectHistory: () {
          store.dispatch(ObjectSelected(0, History));
        },
        history: store.state.tabState[store.state.currentTabIndex].history,
        help: const Help(shortcuts: shortcuts),
        selectHelp: () {
          store.dispatch(ObjectSelected(0, Help));
        },
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
        trajectoryFileName: store
            .state.tabState[store.state.currentTabIndex].ui.trajectoryFileName,
        autoFileName: store.state.autoFileName,
        editTrajectoryFileName: (final String fileName) {
          store.dispatch(TrajectoryFileNameChanged(fileName));
        },
        openFile: () => store.dispatch(openFileThunk()),
        pathUndo: () => store.dispatch(pathUndoThunk()),
        pathRedo: () => store.dispatch(pathRedoThunk()),
        saveFile: () => store.dispatch(saveFileThunk(false)),
        saveFileAs: () => store.dispatch(saveFileThunk(true)),
        newAuto: () => store.dispatch(newAutoThunk()),
        changesSaved: store.state.changesSaved,
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

    if (tabAmount != other.tabAmount) return false;
    if (currentTabIndex != other.currentTabIndex) return false;
    if (changesSaved != other.changesSaved) return false;
    if (autoFileName != other.autoFileName) return false;

    return true;
  }
}
