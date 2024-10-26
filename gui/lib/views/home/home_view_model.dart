import "package:pathfinder_gui/shortcuts/help.dart";
import "package:pathfinder_gui/models/history.dart";
import "package:pathfinder_gui/models/path_point.dart";
import "package:pathfinder_gui/models/robot.dart";
import "package:pathfinder_gui/store/app/app_actions.dart";
import "package:pathfinder_gui/store/app/app_state.dart";
import "package:pathfinder_gui/store/tab/store.dart";
import "package:pathfinder_gui/store/tab/tab_thunk.dart";
import "package:redux/redux.dart";

class HomeViewModel {
  HomeViewModel({
    required this.tabAmount,
    required this.addTab,
    required this.changeTab,
    required this.isSidebarOpen,
    required this.setSidebarVisibility,
    required this.selectRobot,
    required this.selectHistory,
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
    required this.selectHelp,
    required this.currentTabIndex,
  });
  TabState tabState;
  bool isSidebarOpen;
  final Function(bool) setSidebarVisibility;
  final Function() selectRobot;
  final Function() selectHistory;
  final Function() selectHelp;
  final Function(int, PathPoint) setPointData;
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
        tabState: store.state.currentTabState,
        isSidebarOpen: store.state.currentTabState.ui.isSidebarOpen,
        setSidebarVisibility: (final bool visibility) {
          store.dispatch(SetSideBarVisibility(visibility));
        },
        selectRobot: () {
          store.dispatch(ObjectSelected(0, Robot));
        },
        selectHistory: () {
          store.dispatch(ObjectSelected(0, History));
        },
        selectHelp: () {
          store.dispatch(ObjectSelected(0, Help));
        },
        setPointData: (final int index, final PathPoint point) {
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
        trajectoryFileName: store.state.currentTabState.ui.trajectoryFileName,
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
}
