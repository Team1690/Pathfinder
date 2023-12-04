import "package:flutter/cupertino.dart";

class Shortcut {
  const Shortcut({
    required this.shortcut,
    required this.description,
    this.activator,
  });

  final ShortcutActivator? activator;
  final String shortcut;
  final String description;
}
