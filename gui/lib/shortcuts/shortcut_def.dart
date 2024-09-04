import "package:flutter/material.dart";
import "package:flutter/services.dart";
import "package:pathfinder/shortcuts/shortcut.dart";

//TODO: Standardize the description and shortcut
const Shortcut noZoomShortcut = Shortcut(
  shortcut: "Ctrl + 0",
  description: "Reset zoom",
  activator: SingleActivator(LogicalKeyboardKey.digit0, control: true),
);
const Shortcut toggleHeading = Shortcut(
  shortcut: "h",
  description:
      "Toggles ability to move heading points without selecting specific point",
  activator: SingleActivator(LogicalKeyboardKey.keyH),
);
const Shortcut toggleControl = Shortcut(
  shortcut: "g",
  description:
      "Toggles ability to move control points without selecting specific point",
  activator: SingleActivator(LogicalKeyboardKey.keyG),
);
const Shortcut unSelectPoint = Shortcut(
  shortcut: "On Point + ESC",
  description: "Unselect the current selected point",
  activator: SingleActivator(LogicalKeyboardKey.escape),
);
const Shortcut deletePoint = Shortcut(
  shortcut: "On Point + Ctrl + Backspace",
  description: "Delete the current selected point",
  activator: SingleActivator(LogicalKeyboardKey.backspace, control: true),
);
const Shortcut undo = Shortcut(
  shortcut: "Ctrl + z",
  description: "Undo the last action",
  activator: SingleActivator(LogicalKeyboardKey.keyZ, control: true),
);
const Shortcut redo = Shortcut(
  description: "Redo the last action",
  shortcut: "Ctrl + y",
  activator: SingleActivator(LogicalKeyboardKey.keyY, control: true),
);
const Shortcut save = Shortcut(
  description: "Save file",
  shortcut: "Ctrl + s",
  activator: SingleActivator(LogicalKeyboardKey.keyS, control: true),
);
const Shortcut saveAs = Shortcut(
  description: "Save file as",
  shortcut: "Ctrl + Shift + s",
  activator:
      SingleActivator(LogicalKeyboardKey.escape, control: true, shift: true),
);
const Shortcut zoomIn = Shortcut(
  description: "Zoom in",
  shortcut: "Ctrl + =",
  activator: SingleActivator(LogicalKeyboardKey.equal, control: true),
);
const Shortcut zoomOut = Shortcut(
  description: "Zoom out",
  shortcut: "Ctrl + -",
  activator: SingleActivator(LogicalKeyboardKey.minus, control: true),
);
const Shortcut panUp = Shortcut(
  description: "Pan up",
  shortcut: "Ctrl + Up_Arrow",
  activator: SingleActivator(LogicalKeyboardKey.arrowUp, control: true),
);
const Shortcut panDown = Shortcut(
  description: "Pan down",
  shortcut: "Ctrl + Down_Arrow",
  activator: SingleActivator(LogicalKeyboardKey.arrowDown, control: true),
);
const Shortcut panLeft = Shortcut(
  description: "Pan left",
  shortcut: "Ctrl + Left_Arrow",
  activator: SingleActivator(LogicalKeyboardKey.arrowLeft, control: true),
);
const Shortcut panRight = Shortcut(
  description: "Pan right",
  shortcut: "Ctrl + Right_Arrow",
  activator: SingleActivator(LogicalKeyboardKey.arrowRight, control: true),
);
const Shortcut addPoint = Shortcut(
  description: "Add point",
  shortcut: "Ctrl + Mouse press",
);
const Shortcut stopPointToggle = Shortcut(
  description: "On stop point, the control points become collinear",
  shortcut: "On Stop Point + Control Point Pressed + f",
);
const Shortcut mouseDragPan = Shortcut(
  shortcut: "Ctrl + Mouse Drag",
  description: "Pan with mouse",
);

const Shortcut deleteTab = Shortcut(
  shortcut: "Long Press a tab",
  description: "Deletes the pressed tab",
);

const Shortcut animateRobot = Shortcut(
  shortcut: "Ctrl + A",
  description: "Animates robot in field",
  activator: SingleActivator(LogicalKeyboardKey.keyA, control: true),
);
const Shortcut copyPoint = Shortcut(
  shortcut: "On Point + Ctrl + C",
  description: "Copies the current selected point",
  activator: SingleActivator(LogicalKeyboardKey.keyC, control: true),
);

const Shortcut pastePoint = Shortcut(
  shortcut: "On Point + Ctrl + V",
  description: "Pastes the current selected point",
  activator: SingleActivator(LogicalKeyboardKey.keyV, control: true),
);

const List<Shortcut> shortcuts = <Shortcut>[
  stopPointToggle,
  panUp,
  panDown,
  panLeft,
  panRight,
  noZoomShortcut,
  zoomIn,
  zoomOut,
  toggleHeading,
  toggleControl,
  unSelectPoint,
  deletePoint,
  addPoint,
  undo,
  redo,
  save,
  saveAs,
  deleteTab,
  animateRobot,
  copyPoint,
  pastePoint,
];
