import 'dart:async';
import 'dart:io';
import 'dart:ui' as ui;

import 'package:pathfinder/rpc/protos/PathFinder.pb.dart' as rpc;
import 'package:pathfinder/store/tab/tab_actions.dart';
import 'package:pathfinder/store/tab/tab_thunk.dart';
import 'package:pathfinder/widgets/path_editor/full_path_point.dart';
import 'package:pathfinder/widgets/path_editor/temp_spline_point.dart';
import 'package:redux/redux.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:pathfinder/models/point.dart';
import 'package:pathfinder/models/segment.dart';
import 'package:pathfinder/store/app/app_state.dart';
import 'package:pathfinder/widgets/path_editor/path_point.dart';

class PathViewModel {
  final List<Point> points;
  final List<Segment> segments;
  final int? selectedPointIndex;
  final Function(Offset) addPoint;
  final Function(int) deletePoint;
  final Function(int, Offset) finishDrag;
  final Function(int) selectPoint;
  final Function(int, Offset) finishInControlDrag;
  final Function(int, Offset) finishOutControlDrag;
  final List<rpc.SplineResponse_Point>? evaulatedPoints;

  PathViewModel({
    required this.points,
    required this.segments,
    required this.selectedPointIndex,
    required this.addPoint,
    required this.deletePoint,
    required this.finishDrag,
    required this.selectPoint,
    required this.evaulatedPoints,
    required this.finishInControlDrag,
    required this.finishOutControlDrag,
  });

  static PathViewModel fromStore(Store<AppState> store) {
    return PathViewModel(
      points: store.state.tabState.path.points,
      segments: store.state.tabState.path.segments,
      evaulatedPoints: store.state.tabState.path.evaluatedPoints,
      selectedPointIndex: (store.state.tabState.ui.selectedType == Point
          ? store.state.tabState.ui.selectedIndex
          : null),
      addPoint: (Offset position) {
        store.dispatch(addPointThunk(position));
      },
      deletePoint: (int index) {
        store.dispatch(removePointThunk(index));
      },
      finishDrag: (int index, Offset position) {
        store.dispatch(editPointPositionThunk(index, position));
      },
      selectPoint: (int index) {
        store.dispatch(ObjectSelected(index, Point));
      },
      finishInControlDrag: (int index, Offset position) {
        store.dispatch(editInControlThunk(index, position));
      },
      finishOutControlDrag: (int index, Offset position) {
        store.dispatch(editOutControlThunk(index, position));
      },
    );
  }
}

StoreConnector<AppState, PathViewModel> pathEditor() {
  return new StoreConnector<AppState, PathViewModel>(
      converter: (store) => PathViewModel.fromStore(store),
      builder: (_, props) => _PathEditor(pathProps: props));
}

extension GlobalKeyExtension on GlobalKey {
  Rect? get globalPaintBounds {
    final renderObject = currentContext?.findRenderObject();
    final translation = renderObject?.getTransformTo(null).getTranslation();
    print("${renderObject} , ${translation}");
    if (translation != null && renderObject?.paintBounds != null) {
      final offset = Offset(translation.x, translation.y);
      return renderObject!.paintBounds.shift(offset);
    } else {
      return null;
    }
  }
}

class SmartImage extends StatelessWidget {
  GlobalKey _key = GlobalKey();

  // final Function(Offset) setPosition;
  final String imagePath;

  SmartImage(this.imagePath);

  // this function is trigger when the user presses the floating button
  // void _getOffset(GlobalKey key) {
  //   RenderObject? box = key.currentContext?.findRenderObject();
  //   if (box != null) {
  //     Offset position = box!.localToGlobal(Offset.zero);
  //     setPosition(position);
  //   }

  @override
  Widget build(BuildContext context) {
      print('absolute coordinates on screen: ${_key.globalPaintBounds}');
    return Container(
      key: _key,
      child: Image(
        image: AssetImage(imagePath)
      )
    );
  }
}

// class SmartImage extends StatelessWidget {
//   final String imagePath;
//   final Function(Offset) setSize;

//   SmartImage(this.imagePath, this.setSize);

//   @override
//   Widget build(final BuildContext context) {

//     final Image image = Image(
//       image: AssetImage(imagePath)
//     );

//     image.image
//       .resolve(ImageConfiguration())
//       .addListener(ImageStreamListener(
//         (ImageInfo info, bool _) {
//           setSize(Offset(info.image.width.toDouble(), info.image.height.toDouble()));
//         })
//       );

//     return image;
//   }
// }

class _PathEditor extends StatefulWidget {
  final PathViewModel pathProps;

  _PathEditor({
    required this.pathProps,
  });

  @override
  _PathEditorState createState() => _PathEditorState();
}

class _PathEditorState extends State<_PathEditor> {
  Set<LogicalKeyboardKey> pressedKeys = {};
  bool shiftPressed = false;
  bool ctrlPressed = false;
  Offset? dragPoint;
  Offset ImageSize = Offset(0,0);

  _PathEditorState();

  @override
  Widget build(final BuildContext context) {
    final PointSettings pointSetting = pointSettings[PointType.path]!;
    // final double imageHeight = 0.6 * MediaQuery.of(context).size.height;
    // final double imageWidth = 2 * imageHeight;
    // final SmartImage image = SmartImage('assets/images/frc_2020_field.png', (Offset size) {
    //   setState(() {
    //     ImageSize =  size;
    //   });
    // });

    return RawKeyboardListener(
      autofocus: true,
      focusNode: FocusNode(),
      onKey: (final RawKeyEvent event) {
        setState(() {
          if (event is RawKeyDownEvent)
            pressedKeys.add(event.logicalKey);
          else if (event is RawKeyUpEvent) pressedKeys.remove(event.logicalKey);
          shiftPressed = pressedKeys.contains(LogicalKeyboardKey.shiftLeft);
          ctrlPressed = pressedKeys.contains(LogicalKeyboardKey.controlLeft) ||
              pressedKeys.contains(LogicalKeyboardKey.metaLeft);
        });

        // if (ctrlPressed) {
        //   if (pressedKeys.contains(LogicalKeyboardKey.keyZ))
        //     _bloc.add(Undo());
        //   else if (pressedKeys.contains(LogicalKeyboardKey.keyY))
        //     _bloc.add(Redo());

        //   if (pressedKeys.contains(LogicalKeyboardKey.backspace)) {
        //     _bloc.add(ClearAllPoints());
        //     selectedPointIndex = null;
        //   }
        // }

        if (pressedKeys.contains(LogicalKeyboardKey.backspace) &&
            widget.pathProps.selectedPointIndex != null) {
          widget.pathProps.deletePoint(widget.pathProps.selectedPointIndex!);
        }
      },
      child: Center(
        child: Stack(
          children: [
            GestureDetector(
              child: SmartImage('assets/images/frc_2020_field.png'),
              // child: Image(
              //   image: AssetImage('assets/images/frc_2020_field.png'),
              // ),
              onTapDown: (final TapDownDetails detailes) {
                // Add point to board
                final Offset tapPos = detailes.localPosition;
                widget.pathProps.addPoint(tapPos);
              },
              onPanStart: (_) {},
            ),

            // Draw dragging point
            if (dragPoint != null)
              Positioned(
                top: dragPoint!.dy - pointSetting.radius,
                left: dragPoint!.dx - pointSetting.radius,
                child: Container(
                  width: 2 * pointSetting.radius,
                  height: 2 * pointSetting.radius,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: pointSetting.color,
                  ),
                ),
              ),

            ...[
              for (final entery in widget.pathProps.points.asMap().entries)
                FullPathPoint(
                  key: Key(entery.key.toString()),
                  point: entery.value,
                  onDrag: (final DragUpdateDetails details) {
                    // Drag point on bored
                    setState(() {
                      if (dragPoint == null) {
                        Offset basePoint = entery.value.position;
                        dragPoint = Offset(basePoint.dx + details.delta.dx,
                            basePoint.dy + details.delta.dy);
                      } else {
                        dragPoint = Offset(dragPoint!.dx + details.delta.dx,
                            dragPoint!.dy + details.delta.dy);
                      }
                    });
                  },
                  onDragEnd: (_) {
                    // Finish to drag point on bored
                    widget.pathProps.finishDrag(entery.key, dragPoint!);
                    setState(() {
                      dragPoint = null;
                    });
                  },
                  onTap: () {
                    widget.pathProps.selectPoint(entery.key);
                  },
                  isSelected: entery.key == widget.pathProps.selectedPointIndex,
                  onInControlDragEnd: (Offset position) {
                    widget.pathProps.finishInControlDrag(entery.key, position);
                  },
                  enableControlPointsEdit: ctrlPressed,
                  enableHeadingEdit: shiftPressed,
                  onOutControlDragEnd: (Offset position) {
                    print(position);
                    widget.pathProps.finishOutControlDrag(entery.key, position);
                  },
                )
            ],

            for (final evaluatedPoint in widget.pathProps.evaulatedPoints ?? [])
              SplinePoint(point: evaluatedPoint)
          ],
        ),
      ),
    );
  }
}
