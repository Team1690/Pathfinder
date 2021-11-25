import 'package:meta/meta.dart';
import 'package:provider/provider.dart';
import 'package:redux/redux.dart';

abstract class TabAction {
  @override
  String toString() {
    return '$runtimeType';
  }
}

class SetSideBarVisibility extends TabAction {
  final bool visibility = false;
}

class CloseSideBar extends TabAction {}
