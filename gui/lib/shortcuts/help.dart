import "package:pathfinder_gui/shortcuts/shortcut.dart";

//TODO: make an interface or mixin for all the models for the sidebar
class Help {
  const Help({required this.shortcuts});
  final List<Shortcut> shortcuts;
}
