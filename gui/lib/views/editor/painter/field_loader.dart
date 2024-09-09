import "dart:async";
import "dart:ui" as ui;

import "package:flutter/material.dart";
import "package:flutter/services.dart";
import "package:orbit_standard_library/orbit_standard_library.dart";
import "package:pathfinder/models/old%20path_point.dart";
import "package:pathfinder/models/robot.dart";
import "package:pathfinder/models/robot_on_field.dart";
import "package:pathfinder/models/old%20segment.dart";
import "package:pathfinder/models/spline_point.dart" as modelspath;
import "package:pathfinder/views/editor/painter/field_painter.dart";
import "package:pathfinder/views/editor/dragging_point.dart";

//TODO: move this to constants
const double headingLength = 50;

//TODO: see if you can shorten this code a bit and make it more concise
//TODO: field loader shoudn't accept this many params instead it should have a model with store connector
class FieldLoader extends StatefulWidget {
  FieldLoader(
    this.points,
    this.segments,
    this.selectedPoint,
    this.dragPoints,
    this.enableHeadingEditing,
    this.enableControlEditing,
    this.evaluatedPoints,
    this.setFieldSizePixels,
    this.robot,
    this.imageZoom,
    this.imageOffset,
    this.robotOnField,
  );
  final List<PathPoint> points;
  final List<Segment> segments;
  final int? selectedPoint;
  final List<DraggingPoint> dragPoints;
  final bool enableHeadingEditing;
  final bool enableControlEditing;
  final List<modelspath.SplinePoint> evaluatedPoints;
  final Function(Offset) setFieldSizePixels;
  final Robot robot;
  final Optional<RobotOnField> robotOnField;
  final double imageZoom;
  final Offset imageOffset;

  @override
  _FieldLoaderState createState() => _FieldLoaderState();
}

//TODO: this should be in the state and not global
({ui.Image field, ui.Image robot})? globalImages;

class _FieldLoaderState extends State<FieldLoader> {
  void initState() {
    super.initState();
    init();
  }

  Future<Null> init() async {
    if (globalImages != null) {
      return;
    }

    final ByteData fieldData =
        await rootBundle.load("assets/images/frc_2024_field.png");
    final ByteData robotData =
        await rootBundle.load("assets/images/doppler.png");
    final ui.Image field = await loadImage(Uint8List.view(fieldData.buffer));
    final ui.Image robot = await loadImage(Uint8List.view(robotData.buffer));

    globalImages = (field: field, robot: robot);
    setState(() {});
  }

  Future<ui.Image> loadImage(final Uint8List img) async {
    final Completer<ui.Image> completer = Completer<ui.Image>();
    ui.decodeImageFromList(img, completer.complete);
    return completer.future;
  }

  Widget _buildImage() {
    //TODO: these should be decided from the ratio of field size these seem like random numbers
    final double width = 0.7 * MediaQuery.of(context).size.width;
    final double height = 0.6 * MediaQuery.of(context).size.height;
    widget.setFieldSizePixels(Offset(width, height));

    if (globalImages != null) {
      return Container(
        decoration: BoxDecoration(
          boxShadow: <BoxShadow>[
            BoxShadow(
              color: Colors.black.withOpacity(0.5),
              spreadRadius: 2,
              blurRadius: 14,
              offset: const Offset(0, 4), // changes position of shadow
            ),
          ],
        ),
        child: CustomPaint(
          painter: FieldPainter(
            globalImages!.robot,
            globalImages!.field,
            widget.points,
            widget.segments,
            widget.selectedPoint,
            widget.dragPoints,
            widget.enableHeadingEditing,
            widget.enableControlEditing,
            widget.evaluatedPoints,
            widget.robot,
            widget.imageZoom,
            widget.imageOffset,
            widget.robotOnField,
          ),
          size: Size(width, height),
        ),
      );
    } else {
      return const Center(child: Text("loading"));
    }
  }

  @override
  Widget build(final BuildContext context) => _buildImage();
}
