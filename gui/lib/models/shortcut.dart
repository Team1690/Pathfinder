import "package:flutter/cupertino.dart";

class Shortcut {
  const Shortcut({
    required this.description,
    this.activator,
    required this.shortcut,
  });

  final ShortcutActivator? activator;
  final String shortcut;
  final String description;
}
