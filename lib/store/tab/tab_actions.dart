import 'package:flutter/cupertino.dart';
import 'package:meta/meta.dart';
import 'package:pathfinder/rpc/protos/PathFinder.pb.dart';
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
class AddPointToPath extends TabAction {
  final Offset position;
  AddPointToPath({
    required this.position 
  });
}
